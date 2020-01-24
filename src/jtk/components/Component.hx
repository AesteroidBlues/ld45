package jtk.components;

import h2d.Drawable;

class Component {
    private var entity : Drawable;

    public function new(drawable : Drawable) {
        this.entity = drawable;
    }
}