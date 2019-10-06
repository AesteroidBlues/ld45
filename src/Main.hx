import hxd.res.TiledMap.TiledMapData;
import hxd.App;
import hxd.Res;
import h2d.Object;

class Main extends App {
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

    public var updateables : Array<Entity>;

    override function init() {
        s2d.scaleMode = Stretch(sceneWidth, sceneHeight);

        engine.backgroundColor = 0x333333;

        pickups = new Array<Powerup>();
        updateables = new Array<Entity>();

        this.map = new TiledMap(Res.arena.entry.getBytes().toString());
        var tiles = hxd.Res.tileset.toTile();
        
        this.camera = new Camera(s2d);
        drawLayer(this.map, tiles, 0, TILE_SIZE, this.camera);

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

        this.player = new Player(camera, this);
        this.player.x = playerStart.x;
        this.player.y = playerStart.y;

        this.enemy = new Enemy(camera, this);
        this.enemy.x = enemyStart.x;
        this.enemy.y = enemyStart.y;

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

    function drawLayer(map : TiledMap, tiles : h2d.Tile, layer : Int, size : Int, parent : Object) {
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

    override function update(dt:Float) {
        for (u in updateables) {
            u.update(dt);
        }
    }

    static function main() {
        Res.initEmbed();
        new Main();
    }
}
