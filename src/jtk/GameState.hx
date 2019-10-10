package jtk;

import h2d.Object;
import h2d.Scene;
class GameState extends Scene {

    var game : Game;

    public var updatables(get, null) : Array<Entity>;

    public function new(game : Game) {
        super();
        
        this.game = game;

        updatables = new Array<Entity>();
    }

    public function update(dt : Float) {
    }

    public function onExit() {
    }

    public function onEnter() { }

    private function get_updatables() {
        return this.updatables;
    }
}
