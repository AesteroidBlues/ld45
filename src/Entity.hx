import h2d.Object;
import h2d.Drawable;

class Entity extends Drawable {
    public var MAX_HEALTH = 30;
    public var health : Float;

    public var weapon : Weapon;
    public var hasArmor : Bool;

    public var game : Main;
    public var dead : Bool = false;
    public var deathTimer : Float = 0;

    var onDeath : () -> Void;

    public function new(parent : Object, game : Main) {
        super(parent);

        this.game = game;

        this.health = MAX_HEALTH;

        weapon = null;
        hasArmor = false;

        game.updateables.push(this);
    }

    function LookAt(x : Float, y : Float) {
        this.rotation = (Math.PI/2) + Math.atan2(y, x);
    }

    public function takeDamage(damage : Float) {
        this.health -= damage;
        if (this.health <= 0) {
            onDeath();
        }
    }

    public override function onRemove() {
        game.updateables.remove(this);
    }

    public function update(dt : Float) { }
}
