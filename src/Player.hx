import hxd.clipper.Rect;
import h2d.col.Point;
import h2d.Drawable;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Object;
import hxd.Key;
import h2d.Graphics;

class Player extends Entity {
    public var sprite : Tile;

    public var speed : Float = 48.0  * 2;

    private var mouseX : Float;
    private var mouseY : Float;

    var graphics : Graphics;

    public function new(parent : Object, main : MyGameState) {
        super(parent, main);

        sprite = hxd.Res.player.toTile();
        sprite.setCenterRatio();
        var bitmap = new Bitmap(sprite, this);
        

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

        var p = new Point();
        if (Key.isDown(Key.W)) {
            p.y -= this.speed * dt;
        }
        if (Key.isDown(Key.S)) {
            p.y += this.speed * dt;
        }
        if (Key.isDown(Key.A)) {
            p.x -= this.speed * dt;
        }
        if (Key.isDown(Key.D)) {
            p.x += this.speed * dt;
        }

        var mouseWorldSpace = this.game.camera.screenToWorldSpace(this.game.mouseX, this.game.mouseY);
        var lookTargetX = mouseWorldSpace.x - this.x;
        var lookTargetY = mouseWorldSpace.y - this.y;

        LookAt(lookTargetX, lookTargetY);

        var spriteBounds = new h2d.col.Bounds();
        spriteBounds.x = this.x + p.x - 8;
        spriteBounds.y = this.y + p.y - 8;
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

        this.x += p.x;
        this.y += p.y;

        for (obj in this.game.map.objects["transition"].objects) {
            var bounds = new h2d.col.Bounds();
            bounds.x = obj.x;
            bounds.y = obj.y;
            bounds.width = obj.width;
            bounds.height = obj.height;

            if (spriteBounds.intersects(bounds)) {
                var coords = obj.name.split(",");
                var x = Std.parseInt(coords[0]);
                var y = Std.parseInt(coords[1]);
                this.game.moveCamera(x, y);

                var spawnId = obj.properties["target"].intValue;

                var roomSpawn = this.game.map.objects["spawn"].objects.filter(function(o) {
                    return o.id == spawnId;
                });

                this.x = roomSpawn[0].x;
                this.y = roomSpawn[0].y;
            }
        }

        for (p in this.game.pickups) {
            if (spriteBounds.intersects(p.getBounds(this.game.camera))) {
                if (game.enemy.weapon == null && this.weapon == null) {
                    game.switchMusic(game.playerWeaponFirstMusic);
                }

                p.onPickup(this);
            }
        }

        if (Key.isPressed(Key.SPACE) && weapon != null) {
            this.weapon.attack(this, game.enemy);
        }
    }
}
