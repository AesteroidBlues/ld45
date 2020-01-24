import hxd.App;
import jtk.Game;

class MyGame extends Game {
    public function new(app : App) {
        super(app);

        this.states.set("game", new MyGameState(this));
        this.changeState(this.states.get("game"));
    }
}
