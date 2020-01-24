package jtk.components;

import hxmath.math.Vector2;

class Transform extends Component {
    public var position(default, set) : Vector2;

    public function set_position(value : Vector2) : Vector2 {
        this.entity.x = value.x;
        this.entity.y = value.y;
        
        return this.position = value;
    }
}