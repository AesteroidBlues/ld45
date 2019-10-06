class TiledObjectGroup {
    public var id : Int;
    public var name : String;

    public var objects : Array<TiledObject>;

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
}
