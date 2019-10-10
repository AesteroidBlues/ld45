package hxtiled;

class TiledObject {
    public var id(get, null) : Int;
    public var name(get, null) : String;
    public var type(get, null) : String;
    public var x(get, null) : Int;
    public var y(get, null) : Int;
    public var width(get, null) : Int;
    public var height(get, null) : Int;

    public var properties(get, null) : Map<String, TiledProperty>;
    public var text(get, null) : String;

    public function new(xml : Xml) {
        properties = new Map<String, TiledProperty>();

        for (a in xml.attributes()) {
            var val = xml.get(a);
            switch(a) {
                case "id":
                    this.id = Std.parseInt(val); 
                case "name":
                    this.name = val;
                case "type":
                    this.type = val;
                case "x":
                    this.x = Std.parseInt(val); 
                case "y":
                    this.y = Std.parseInt(val); 
                case "width":
                    this.width = Std.parseInt(val); 
                case "height":
                    this.height = Std.parseInt(val); 
            }
        }

        for (c in xml.elements()) {
            if (c.nodeName == "properties") {
                for (p in c.elements()) {
                    var property = new TiledProperty(p);
                    properties.set(property.name, property);
                }
            }
            if (c.nodeName == "text") {
                this.text = c.firstChild().nodeValue;
            }
        }
    }

    private function get_id() {
        return this.id;
    }

    private function get_name() {
        return this.name;
    }

    private function get_type() {
        return this.type;
    }

    private function get_x() {
        return this.x;
    }

    private function get_y() {
        return this.y;
    }

    private function get_width() {
        return this.width;
    }

    private function get_height() {
        return this.height;
    }

    private function get_properties() {
        return this.properties;
    }

    private function get_text() {
        return this.text;
    }
}
