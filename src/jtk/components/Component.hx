package jtk.components;

import h2d.Drawable;

interface Component {
    public function update(dt : Float, entity : Entity) : Void;
}
