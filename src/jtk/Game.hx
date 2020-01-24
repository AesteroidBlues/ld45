package jtk;

import hxd.App;

import jtk.StateMachine;

class Game extends StateMachine<GameState> {
    var app : App;

    public function new(app : App) {
        super();

        this.app = app;
    }

    public function update(dt : Float) {
        currentState.update(dt);
    }

    public override function changeState(newState : GameState) {
        super.changeState(newState);
        app.setScene(currentState);
    }
}
