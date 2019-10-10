package hxtiled;

class TiledProperty {
    public var name(get, null) : String;
    public var type(get, null) : String;

    public var intValue(get, null) : Int;
    var value : String;

    public function new(xml : Xml) {
        for (a in xml.attributes()) {
            switch(a) {
                case "name":
                    this.name = xml.get(a);
                case "type":
                    this.type = xml.get(a);
                case "value":
                    this.value = xml.get(a);
            }
        }
    }

    public function get_name() : String {
        return this.name;
    }

    public function get_type() : String {
        return this.type;
    }

    public function get_intValue() : Int {
        return Std.parseInt(value);
    }
}
