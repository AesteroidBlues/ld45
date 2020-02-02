package jtk;

import h2d.Scene;
import jtk.IState;
import jtk.components.Component;

@:coreType abstract ComponentKey from Class<Component> to {} {
}

class GameState extends Scene implements IState {

    var game : Game;

    public var updatables(get, null) : Array<Entity>;
    public var components : Map<ComponentKey, Component>;
    private var componentSubscriptions : Map<Component, Array<Entity>>;

    public function new(game : Game) {
        super();
        
        this.game = game;

        updatables = new Array<Entity>();

        components = new Map<ComponentKey, Component>();
        componentSubscriptions = new Map<Component, Array<Entity>>();
    }

    public function subscribeToComponent(componentType : Class<Component>, subscriber : Entity) {
        if (!components.exists(componentType)) {
            var component = Type.createInstance(componentType, new Array<Dynamic>());
            
            components.set(componentType, component);
            componentSubscriptions.set(component, new Array<Entity>());
        }

        componentSubscriptions[components[componentType]].push(subscriber);
    }

    public function update(dt : Float) {
        for (updatable in this.updatables) {
            updatable.update(dt);
        }

        for (kv in componentSubscriptions.keyValueIterator()) {
            for (entity in kv.value) {
                kv.key.update(dt, entity);
            }
        }
    }

    public function onEnter() { }

    public function onExit() { }

    private function get_updatables() {
        return this.updatables;
    }

    private function get_components() {
        return this.components;
    }
}
