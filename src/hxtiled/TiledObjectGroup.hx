package hxtiled;

class TiledObjectGroup {
    public var id(get, null) : Int;
    public var name(get, null) : String;

    public var objects(get, null) : Array<TiledObject>;

    public function new(xml : Xml) {
        objects = new Array<TiledObject>();
        for (a in xml.attributes()) {
            switch (a) {
                case "id":
                    this.id = Std.parseInt(xml.get(a));
                case "name":
                    this.name = xml.get(a);
            }
        }

        for (c in xml.elements()) {
            objects.push(new TiledObject(c));
        }
    }

    private function get_id() {
        return this.id;
    }

    private function get_name() {
        return this.name;
    }

    private function get_objects() {
        return this.objects;
    }
}
