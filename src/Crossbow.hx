import hxd.res.Sound;
import h2d.Bitmap;
import h2d.Tile;
import h2d.Drawable;
import h2d.Object;
import h2d.col.Point;
import h2d.Anim;

class Crossbow extends Weapon {
    var anim : Anim;
    var shootSound : Sound;

    public function new(parent : Object) {
        super(parent);

        this.type = Crossbow;
        shootSound = hxd.Res.sfx_crossbow;

        var spriteSheet = hxd.Res.bow_png.toTile();
        var sprites = spriteSheet.gridFlatten(16);
        this.anim = new Anim(sprites);
        this.anim.pause = true;
        this.anim.loop = false;
        this.anim.onAnimEnd = onShotEnd;
        anim.x -= 4;
        anim.y -= 16;
        addChild(anim);
    }

    override function attack(owner:Entity, target:Entity) {
        anim.pause = false;
        this.canAttack = false;

        var arrow = new Arrow(owner.game.camera, owner.game, owner);
        arrow.x = owner.x;
        arrow.y = owner.y;
        arrow.rotation = owner.rotation;
        this.shootSound.play();
    }

    function onShotEnd() {
        this.anim.currentFrame = 0;
        this.anim.pause = true;
        this.canAttack = true;
    }
}

class Arrow extends Entity {
    public var speed : Int = 200;
    public var damage : Float = 5;

    var sprite : Tile;
    var owner : Entity;

    public function new(parent : Object, game : Main, owner : Entity) {
        super(parent, game);
        this.game = game;
        this.owner = owner;

        this.sprite = hxd.Res.arrow.toTile();
        var bitmap = new Bitmap(sprite, this);
    }

    public override function update(dt : Float) {
        var forward = new Point(Math.sin(this.rotation), -Math.cos(this.rotation));
        forward.normalize();
        
        this.x += forward.x * speed * dt;
        this.y += forward.y * speed * dt;

        var spriteBounds = new h2d.col.Bounds();
        spriteBounds.x = this.x - 8;
        spriteBounds.y = this.y - 8;
        spriteBounds.width = sprite.width;
        spriteBounds.height = sprite.height;

        for (obj in this.game.map.objects["collision"].objects) {
            var bounds = new h2d.col.Bounds();
            bounds.x = obj.x;
            bounds.y = obj.y;
            bounds.width = obj.width;
            bounds.height = obj.height;
            
            // Collide with a wall
            if (spriteBounds.intersects(bounds)) {
                remove();
            }
        }

        if (this.owner != game.player && spriteBounds.intersects(game.player.getBounds(game.camera))) {
            game.player.takeDamage(damage);
            remove();
        }

        if (this.owner != game.enemy && spriteBounds.intersects(game.enemy.getBounds(game.camera))) {
            game.enemy.takeDamage(damage);
            remove();
        }
    }
}
