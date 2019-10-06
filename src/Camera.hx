import h2d.col.Point;
import h2d.Object;
import h2d.Scene;

class Camera extends Object {
    public var viewX(get, set) : Float;
    public var viewY(get, set) : Float;

    public var scene:  Scene;

    public function new(scene:Scene)
    {
        super(scene);
        this.scene = scene;
    }
    
    public function screenToWorldSpace(x : Float, y : Float) : Point {
        return new Point(this.viewX + x, this.viewY + y);
    }

    private function set_viewX(value:Float) : Float {
        this.x = -value;
        return value;
    }

    private function get_viewX():Float
    {
        return -this.x;
    }

    private function set_viewY(value:Float):Float
    {
        this.y = -value;
        return value;
    }

    private function get_viewY():Float
    {
        return -this.y;
    }
}
