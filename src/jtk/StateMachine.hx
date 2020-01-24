package jtk;

import jtk.IState;

class StateMachine<T : IState> {
    public var currentState(get, null) : T;
    public var states(get, null) : Map<String, T>;

    public function new() {
        this.states = new Map<String, T>();
    }

    public function changeState(newState : T) {
        if (currentState != null) {
            currentState.onExit();
        }

        currentState = newState;
        currentState.onEnter();
    }

    private function get_currentState() {
        return this.currentState;
    }

    private function get_states() {
        return this.states;
    }
}