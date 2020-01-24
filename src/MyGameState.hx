import hxd.res.DefaultFont;
import h2d.Text;
import hxd.res.Sound;
import hxd.res.TiledMap.TiledMapData;
import hxd.App;
import hxd.Res;
import h2d.Object;
import jtk.GameState;
import jtk.Game;
import hxtiled.*;

class MyGameState extends GameState {
    public var sceneWidth = 240;
    public var sceneHeight = 160;

    public var camera : Camera;
    public var player : Player;
    public var enemy : Enemy;
    public var map : TiledMap;

    public inline static var ROOM_WIDTH = 15;
    public inline static var ROOM_HEIGHT = 10;

    public inline static var TILE_SIZE = 16;

    public var pickups : Array<Powerup>;

    public var startMusic : Sound;
    public var playerWeaponFirstMusic : Sound;
    public var enemyWeaponMusic : Sound;

    public var currentMusic : Sound;

    public function new(game : Game) {
        super(game);

        this.scaleMode = Stretch(240, 160);

        // startMusic = hxd.Res.spook2;
        // playerWeaponFirstMusic = hxd.Res.spook;
        // enemyWeaponMusic = hxd.Res.combat;

        // switchMusic(startMusic);


        pickups = new Array<Powerup>();

        this.removeChildren();

        this.map = new TiledMap(Res.arena.entry.getBytes().toString());
        var tiles = hxd.Res.tileset.toTile();
        
        this.camera = new Camera(this);
        drawTiledLayer(this.map, tiles, 0, TILE_SIZE, this.camera);

        var playerStart : TiledObject = null;
        var enemyStart : TiledObject = null;
        for (obj in map.objects["spawn"].objects) {
            if (obj.name == "player_spawn") {
                playerStart = obj;
            }
            if (obj.name == "enemy_spawn") {
                enemyStart = obj;
            }
        }

        for (t in map.objects["text"].objects) {
            if (t.text.length > 0) {
                var text = new Text(DefaultFont.get(), camera);
                text.x = t.x;
                text.y = t.y;
                text.text = t.text;
            }
        }

        this.player = new Player(camera, this);
        this.player.x = playerStart.x;
        this.player.y = playerStart.y;

        // this.enemy = new Enemy(camera, this);
        // this.enemy.x = enemyStart.x;
        // this.enemy.y = enemyStart.y;

        moveCamera(Math.floor(player.x / (ROOM_WIDTH * TILE_SIZE)), 
        Math.floor(player.y / (ROOM_HEIGHT * TILE_SIZE)));

        for (o in map.objects["pickups"].objects) {
            var pickup = new Powerup(camera, o.type, this);
            pickup.x = o.x;
            pickup.y = o.y;

            pickups.push(pickup);
        }
    }

    public function moveCamera(roomX : Int, roomY : Int) {
        this.camera.viewX = roomX * ROOM_WIDTH * TILE_SIZE;
        this.camera.viewY = roomY * ROOM_HEIGHT * TILE_SIZE;
    }

    public function switchMusic(newSound : Sound, loop : Bool = true) {
        if (currentMusic != null) {
            currentMusic.stop();
        }

        currentMusic = newSound;
        newSound.play(loop);
    }

    function drawTiledLayer(map : TiledMap, tiles : h2d.Tile, layer : Int, size : Int, parent : Object) {
        var tileGroup = new h2d.TileGroup(tiles, parent);
        var tileSetArray = tiles.gridFlatten(TILE_SIZE, 0, 0);
        if( map.layers.length > 0 && layer < map.layers.length ) {
            var tileX = 0;
            var tileY = 0;
            for(tile in map.layers[layer].data.tiles) {
                // Tiled stores empty tiles as 0 and offsets the tileId by 1 so we must skip empty tiles and adjust the tileId back to the proper index 
                var tileId = tile.gid;
                if( tileId > 0 && tileId < tileSetArray.length ) tileGroup.add(tileX, tileY, tileSetArray[tileId - 1]);
                tileX += size;
                if( tileX >= map.width * size ) {
                    tileX = 0; 
                    tileY += size;
                }
            }
        }
    }
    
    public override function update(dt:Float) {
        for (u in this.updatables) {
            u.update(dt);
        }

        moveCamera(Math.floor(player.x / (ROOM_WIDTH * TILE_SIZE)), 
            Math.floor(player.y / (ROOM_HEIGHT * TILE_SIZE)));
    }
}
