package jtk;

import h2d.Scene;
import jtk.IState;

class GameState extends Scene implements IState {

    var game : Game;

    public var updatables(get, null) : Array<Entity>;

    public function new(game : Game) {
        super();
        
        this.game = game;

        updatables = new Array<Entity>();
    }

    public function update(dt : Float) {
        for (updatable in this.updatables) {
            updatable.update(dt);
        }
    }

    public function onEnter() { }

    public function onExit() { }

    private function get_updatables() {
        return this.updatables;
    }
}
