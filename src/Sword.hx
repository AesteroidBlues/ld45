import hxd.res.Sound;
import h2d.Anim;
import h2d.col.Point;
import h2d.Graphics;
import h2d.col.Circle;
import h2d.Object;

class Sword extends Weapon {
    var game : MyGameState;
    var graphics : Graphics;

    var DAMAGE = 10;

    var anim : Anim;
    var hitSound : Sound;

    public function new(parent : Object, game : MyGameState) {
        super(parent);

        this.game = game;
        this.graphics = new h2d.Graphics(this.game.camera);
        this.type = Sword;

        this.hitSound = hxd.Res.sfx_sword_hit;

        var spriteSheet = hxd.Res.sword_swing.toTile();
        var sprites = spriteSheet.gridFlatten(16);
        this.anim = new Anim(sprites);
        this.anim.pause = true;
        this.anim.loop = false;
        this.anim.onAnimEnd = onSwingEnd;
        anim.x -= 4;
        anim.y -= 16;
        addChild(anim);
    }

    public override function attack(owner : Entity, target : Entity) {
        this.anim.pause = false;
        this.canAttack = false;

        var forward = new Point(Math.sin(owner.rotation), -Math.cos(owner.rotation));
        forward.normalize();
        forward.scale(10);
        var circleX = owner.x + forward.x;
        var circleY = owner.y + forward.y;
        var circle : Circle = new Circle(circleX, circleY, 7.);
        if (circle.collideBounds(game.enemy.getBounds(this.game.camera))) {
            target.takeDamage(this.DAMAGE);
            hitSound.play(false);
        }
    }

    function onSwingEnd() {
        this.anim.currentFrame = 0;
        this.anim.pause = true;
        this.canAttack = true;
    }
}
