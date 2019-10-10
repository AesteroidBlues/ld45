import hxmath.math.Vector2;
import h2d.Object;
import h2d.Drawable;

class Entity extends Drawable {
    public var MAX_HEALTH = 50;
    public var health : Float;

    public var weapon : Weapon;
    public var hasArmor : Bool;

    public var game : MyGameState;
    public var dead : Bool = false;
    public var deathTimer : Float = 0.5;

    public var position : Vector2;

    var onDeath : () -> Void;

    public function new(parent : Object, game : MyGameState) {
        super(parent);

        this.game = game;
        position = new Vector2(0, 0);

        this.health = MAX_HEALTH;

        weapon = null;
        hasArmor = false;

        game.updatables.push(this);
    }

    function LookAt(x : Float, y : Float) {
        this.rotation = (Math.PI/2) + Math.atan2(y, x);
    }

    public function takeDamage(damage : Float) {
        this.health -= damage;
        if (this.health <= 0) {
            this.dead = true;
            if (onDeath != null) {
                onDeath();
            }
            
            this.visible = false;
        }
    }

    public override function onRemove() {
        game.updatables.remove(this);
    }

    public function update(dt : Float) { }
}
