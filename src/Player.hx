import h2d.Bitmap;
import h2d.Tile;
import h2d.Object;
import hxd.Key;
import h2d.Graphics;

import components.KeyboardMoveComponent;

import hxmath.math.Vector2;

class Player extends Entity {
    public var sprite : Tile;

    private var mouseX : Float;
    private var mouseY : Float;

    var graphics : Graphics;

    public function new(parent : Object, main : MyGameState) {
        super(parent, main);

        sprite = hxd.Res.player.toTile();
        sprite.setCenterRatio();
        var bitmap = new Bitmap(sprite, this);
        
        main.subscribeToComponent(KeyboardMoveComponent, this);

        this.graphics = new Graphics(this.game.camera);
    }

    public override function update(dt : Float) {
        if (this.dead) {
            this.deathTimer -= dt;
            if (deathTimer <= 0) {
                //game.init();
            }
            return;
        }

        

        var mouseWorldSpace = this.game.camera.screenToWorldSpace(this.game.mouseX, this.game.mouseY);
        var lookTarget = new Vector2(mouseWorldSpace.x - this.x, mouseWorldSpace.y - this.y);

        var spriteBounds = new h2d.col.Bounds();
        // spriteBounds.x = this.x + p.x - 8;
        // spriteBounds.y = this.y + p.y - 8;
        spriteBounds.width = sprite.width;
        spriteBounds.height = sprite.height;

        for (obj in this.game.map.objects["collision"].objects) {
            var bounds = new h2d.col.Bounds();
            bounds.x = obj.x;
            bounds.y = obj.y;
            bounds.width = obj.width;
            bounds.height = obj.height;

            if (spriteBounds.intersects(bounds)) {
                return;
            }
        }

        // for (obj in this.game.map.objects["transition"].objects) {
        //     var bounds = new h2d.col.Bounds();
        //     bounds.x = obj.x;
        //     bounds.y = obj.y;
        //     bounds.width = obj.width;
        //     bounds.height = obj.height;

        //     if (spriteBounds.intersects(bounds)) {
        //         var coords = obj.name.split(",");
        //         var x = Std.parseInt(coords[0]);
        //         var y = Std.parseInt(coords[1]);
        //         this.game.moveCamera(x, y);

        //         var spawnId = obj.properties["target"].intValue;

        //         var roomSpawn = this.game.map.objects["spawn"].objects.filter(function(o) {
        //             return o.id == spawnId;
        //         });

        //         this.x = roomSpawn[0].x;
        //         this.y = roomSpawn[0].y;
        //     }
        // }

        for (p in this.game.pickups) {
            if (spriteBounds.intersects(p.getBounds(this.game.camera))) {
                if (game.enemy.weapon == null && this.weapon == null) {
                    // game.switchMusic(game.playerWeaponFirstMusic);
                }

                p.onPickup(this);
            }
        }

        if (Key.isPressed(Key.SPACE) && weapon != null) {
            this.weapon.attack(this, game.enemy);
        }

        super.update(dt);
    }
}
