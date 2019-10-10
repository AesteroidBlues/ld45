import hxd.App;
import hxd.Res;

class Main extends App {
    var game : MyGame;

    public override function init() {
        engine.backgroundColor = 0x333333;
        this.game = new MyGame(this);
    }

    public override function update(dt:Float) {
        this.game.update(dt);
    }

    static function main() {
        Res.initEmbed();
        new Main();
    }
}
