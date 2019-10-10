import h2d.Bitmap;
import h2d.Drawable;
import h2d.Object;

enum PowerupType {
    Sword;
    Armor;
    Crossbow;
}

class Powerup extends Drawable {
    public var type : PowerupType;
    var game : MyGameState;

    public function new (parent : Object, type : String, game : MyGameState) {
        super(parent);

        this.game = game;
        switch(type) {
            case "sword":
                this.type = Sword;
                var sprite = hxd.Res.sword_swing.toTile();
                var sprites = sprite.gridFlatten(16);
                new Bitmap(sprites[0], this);
            case "armor":
                this.type = Armor;
            case "crossbow":
                this.type = Crossbow;
                var sprite = hxd.Res.crossbow_closeup.toTile();
                new Bitmap(sprite, this);
        }
    }

    public function isWeapon() : Bool {
        return this.type == Crossbow || this.type == Sword;
    }

    public function onPickup(ent : Entity) {
        if (ent.weapon == null) {
            if (type == Sword) {
                var sword = new Sword(ent, this.game);
                ent.weapon = sword;
            }
            else if (type == Crossbow) {
                var crossbow = new Crossbow(ent);
                ent.weapon = crossbow;
            }

            game.pickups.remove(this);
            remove();
        }
    }
}
