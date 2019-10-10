package jtk;

import hxd.App;
import h2d.Scene;

class Game {
    public var currentState(get, null) : GameState;
    public var states(get, null) : Map<String, GameState>;

    var app : App;

    public function new(app : App) {
        this.app = app;

        this.states = new Map<String, GameState>();
    }

    public function update(dt : Float) {
        currentState.update(dt);
    }

    public function changeState(newState : GameState) {
        if (currentState != null) {
            currentState.onExit();
        }

        currentState = newState;
        currentState.onEnter();

        app.setScene(currentState);
    }

    private function get_currentState() {
        return this.currentState;
    }

    private function get_states() {
        return this.states;
    }
}
