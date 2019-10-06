import Powerup.PowerupType;
import h2d.Drawable;

class Weapon extends Drawable {
    public var type : PowerupType;
    public var canAttack : Bool = true;

    public function attack(owner : Entity, target : Entity) {
        
    }
}
