import h2d.col.Point;
import h2d.Drawable;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Object;
import hxd.Key;

enum AiState {
    Idle;
    Wander;
    SeekItem;
    Attack;
}

class Enemy extends Entity {
    public var sprite : Tile;

    public var speed : Float = 48.0;

    var state : AiState;
    var target : Drawable;
    var path : Array<Point>;

    var walkableSpaces : Array<Array<Bool>>;
    var rooms : Array<Point>;

    public function new(parent : Object, main : Main) {
        super(parent, main);

        this.state = Idle;

        var mapWidth = this.game.map.width;
        var mapHeight = this.game.map.height;
        this.walkableSpaces = [for (r in 0...mapHeight) [for (c in 0...mapWidth) false]];
        var layer = this.game.map.layers[0];
        for (i in 0...layer.data.tiles.length) {
            var t = layer.data.tiles[i];
            var tileset = this.game.map.tilesets['tileset'];
            var tile = tileset.tiles[t.gid - tileset.firstGid];
            if (tile == null) continue;
            
            if (tile.type == "ground") {
                var tileWorldX = i % layer.width;
                var tileWorldY = Math.floor(i / layer.width);
                walkableSpaces[tileWorldY][tileWorldX] = true;
            }
        }

        this.rooms = new Array<Point>();
        for (r in this.game.map.objects["rooms"].objects) {
            rooms.push(new Point(r.x, r.y));
        }

        this.path = new Array<Point>();

        sprite = h2d.Tile.fromColor(0xCC0044, 16, 16);
        sprite.setCenterRatio();
        var bitmap = new Bitmap(sprite, this);

        this.onDeath = function () {
            this.game.init();
        }
    }

    public override function update(dt : Float) {
        // If we're not currently doing anything, pathfind to a random room
        if (state == Idle) {
            var point = rooms[Std.random(rooms.length)];

            state = Wander;
            var tileX = Math.floor(this.x / Main.TILE_SIZE);
            var tileY = Math.floor(this.y / Main.TILE_SIZE);
            var targetX = Math.floor(point.x / Main.TILE_SIZE);
            var targetY = Math.floor(point.y / Main.TILE_SIZE);

            this.path = getPath(new Point(tileX, tileY), new Point(targetX, targetY));
        }

        if (state == Attack) {
            if (weapon.type == Sword) {
                var distToPlayer = new Point(game.player.x - this.x, game.player.y - this.y);
                if (distToPlayer.length() < 10 && distToPlayer.length() > 3 && weapon.canAttack) {
                    weapon.attack(this, game.player);
                }
                else if (distToPlayer.length() > 10 && path.length == 0) {
                    seekPlayer();
                }
            }
            else {
                var dirToPlayer = new Point(game.player.x - this.x, game.player.y - this.y);
                LookAt(dirToPlayer.x, dirToPlayer.y);
                if (weapon.canAttack) {
                    weapon.attack(this, game.player);
                }
            }
        }

        if (this.target != null) {
            var distToTarget = new Point(target.x - this.x, target.y - this.y);
            if (distToTarget.length() < 25) {
                path = [];
                distToTarget.normalize();
                LookAt(distToTarget.x, distToTarget.y);
                this.x += distToTarget.x * dt * this.speed;
                this.y += distToTarget.y * dt * this.speed;
            }
        }

        if (path.length > 0) {
            var faceX = (path[0].x * Main.TILE_SIZE) - this.x;
            var faceY = (path[0].y * Main.TILE_SIZE) - this.y;

            LookAt(faceX, faceY);
            var vec = new Point(faceX, faceY);
            if (vec.length() < 1) {
                this.path.shift();
                if (path.length == 0) {
                    state = Idle;
                }
            }

            vec.normalize();
            this.x += vec.x * dt * this.speed;
            this.y += vec.y * dt * this.speed;
        }

        if (weapon != null && this.state != Attack) {
            seekPlayer();
            this.state = Attack;
        }
        else if (this.state != SeekItem) {
            // Look for pick ups
            for (p in game.pickups) {
                if (p.isWeapon() && weapon != null) {
                    continue;
                }

                var dX = p.x - this.x;
                var dY = p.y - this.y;
                var pt : Point = new Point(dX, dY);
                if (pt.length() < 100) {
                    var tp = getTilePosFromWorld(this.x, this.y);
                    var pickupPos = getTilePosFromWorld(p.x, p.y);
                    this.path = getPath(tp, pickupPos);
                    this.state = SeekItem;
                    this.target = p;
                    trace ('Seeking ${p.type}');
                    break;
                }
            }
        }

        var spriteBounds = new h2d.col.Bounds();
        spriteBounds.x = this.x - 8;
        spriteBounds.y = this.y - 8;
        spriteBounds.width = sprite.width;
        spriteBounds.height = sprite.height;

        for (p in this.game.pickups) {
            if (spriteBounds.intersects(p.getBounds(this.game.camera))) {
                if (weapon == null) {
                    game.switchMusic(game.enemyWeaponMusic);
                }
                
                p.onPickup(this);
            }
        }
    }

    private function seekPlayer() {
        // Seek the player
        this.target = game.player;
        var tilePos = getTilePosFromWorld(this.x, this.y);
        var playerPos = getTilePosFromWorld(game.player.x, game.player.y);
        this.path = getPath(tilePos, playerPos);
        trace ("Attacking player!");
    }

    private function getTilePosFromWorld(x : Float, y : Float) : Point {
        return new Point(Math.floor(x / Main.TILE_SIZE), Math.floor(y / Main.TILE_SIZE));
    }

    public function getPath(start : Point, dest : Point) : Array<Point> {
        var mapWidth = this.game.map.width;
        var mapHeight = this.game.map.height;

        var openList = new Array<Point>();
        var closedList = [for (x in 0...mapHeight) [for (y in 0...mapWidth) false]];
        var fCost = [for (x in 0...mapHeight) [for (y in 0...mapWidth) -1]];
        var gScore = [for (x in 0...mapHeight) [for (y in 0...mapWidth) -1]];

        var cameFrom = [for (x in 0...mapHeight) [for (y in 0...mapWidth) null]];

        var path = new Array<Point>();

        openList.push(start);
        while (openList.length > 0) {
            // Grab the lowest f(x) to process next
            var currY = 0;
            var currX = 0;
            var lowestF = 9999999;
            for(i in 0...openList.length) {
                var x : Int = cast openList[i].x;
                var y : Int = cast openList[i].y;
                if (fCost[y][x] < lowestF) {
                    currY = y;
                    currX = x;
                    lowestF = fCost[y][x];
                }
            }

            // Check if we've found our destination
            if (currX == dest.x && currY == dest.y) {
                var cameX : Int = cast dest.x;
                var cameY : Int = cast dest.y;
                path.push(dest);
                while (cameFrom[cameY][cameX] != null) {
                    path.push(cameFrom[cameY][cameX]);
                    var newX : Int = cast cameFrom[cameY][cameX].x;
                    var newY : Int = cast cameFrom[cameY][cameX].y;
                    cameX = newX;
                    cameY = newY;
                }
                
                path.reverse();
                return path;
            }

            var openNode = openList.filter(function (f) {
                return f.x == currX && f.y == currY;
            });
            openList.remove(openNode[0]);

            closedList[currY][currX] = true;

            for (r in -1...2) {
                for (c in -1...2) {
                    var newR = currY + r;
                    var newC = currX + c;
                    if (newR < 0 || newR >= this.game.map.height ||
                        newC < 0 || newC >= this.game.map.width) {
                            continue;
                        }

                    if (closedList[newR][newC]) { 
                        continue; 
                    }

                    if (!this.walkableSpaces[newR][newC]) {
                        continue;
                    }

                    var newPoint = new Point(newC, newR);
                    openList.push(newPoint);
                    cameFrom[newR][newC] = openNode[0];

                    gScore[newR][newC] = gScore[newR][newC] + 1;
                    fCost[newR][newC] = gScore[newR][newC] + heuristic(newC, newR, dest);
                }
            }

        }

        return path;
    }

    private function heuristic(x : Float, y : Float, dest : Point) : Int {
        var d1 = Math.abs(x - dest.x);
        var d2 = Math.abs(y - dest.y);
        return Math.floor(Math.sqrt(d1 * d1 + d2 * d2));
    }
}
