package hxtiled;

class TiledTile {
    public var gid(get, null) : Int;
    public var id(get, null) : Int;
    public var type(get, null) : String;
    public var terrain(get, null) : String;
    public var probability(get, null) : Float;

    public function new(param : Dynamic) {
        if (Std.is(param, Xml)) {
            setAttributes(cast(param, Xml));
            setChildren(cast(param, Xml));
        }
        else if (Std.is(param, Int)) {
            this.gid = cast(param, Int);
        }
    }

    private function setAttributes(xml : Xml) {
        for (a in xml.attributes()) {
            switch (a) {
                case "id":
                    this.id = Std.parseInt(xml.get(a));
                case "type":
                    this.type = xml.get(a);
                case "terrain":
                    this.terrain = xml.get(a);
                case "probability":
                    this.probability = Std.parseFloat(xml.get(a));
            }
        }
    }

    private function setChildren(xml : Xml) {
        for (c in xml.elements()) {
            switch (c.nodeName) {
                case "properties":
                case "image":
                case "objectgroup":
                case "animation":
            }
        }
    }

    function get_gid() {
        return this.gid;
    }

    function get_id() {
        return this.id;
    }

    function get_type() {
        return this.type;
    }

    function get_terrain() {
        return this.terrain;
    }

    function get_probability() {
        return this.probability;
    }
}
