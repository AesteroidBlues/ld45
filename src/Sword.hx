import h2d.Anim;
import h2d.col.Point;
import h2d.Graphics;
import h2d.col.Circle;
import h2d.Object;
import h2d.Drawable;

class Sword extends Drawable {
    var game : Main;
    var graphics : Graphics;

    var DAMAGE = 10;

    var anim : Anim;

    public function new(parent : Object, game : Main) {
        super(parent);

        this.game = game;
        this.graphics = new h2d.Graphics(this.game.camera);

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

    public function attack(owner : Player, target : Enemy) {
        this.anim.pause = false;

        var forward = new Point(Math.sin(owner.rotation), -Math.cos(owner.rotation));
        forward.normalize();
        forward.scale(10);
        var circleX = owner.x + forward.x;
        var circleY = owner.y + forward.y;
        var circle : Circle = new Circle(circleX, circleY, 7.);
        if (circle.collideBounds(game.enemy.getBounds(this.game.camera))) {
            target.takeDamage(this.DAMAGE);
        }
    }

    function onSwingEnd() {
        this.anim.currentFrame = 0;
        this.anim.pause = true;
    }
}
