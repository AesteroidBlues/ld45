package components;

import jtk.components.Component;

import hxmath.math.Vector2;
import hxd.Key;

class KeyboardMoveComponent implements Component {

    public function update(dt : Float, entity : Entity) {
        var p = Vector2.zero;

        if (Key.isDown(Key.W)) {
            p.y -= entity.speed * dt;
        }
        if (Key.isDown(Key.S)) {
            p.y += entity.speed * dt;
        }
        if (Key.isDown(Key.A)) {
            p.x -= entity.speed * dt;
        }
        if (Key.isDown(Key.D)) {
            p.x += entity.speed * dt;
        }

        entity.position.x += p.x;
        entity.position.y += p.y;
    }
}
