package hxtiled;

class TiledObject {
    public var id : Int;
    public var name : String;
    public var type : String;
    public var x : Int;
    public var y : Int;
    public var width : Int;
    public var height : Int;

    public var properties : Map<String, TiledProperty>;
    public var text : String;

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
}
