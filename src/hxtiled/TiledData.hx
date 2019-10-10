package hxtiled;

import haxe.crypto.Base64;
import haxe.zip.InflateImpl;

class TiledData {
    public var encoding(get, null) : Null<String>;
    public var compression(get, null) : Null<String>;

    public var tiles(get, null) : Array<TiledTile>;

    public function new(xml : Xml) {
        setAttributes(xml);
        setChildren(xml);
    }

    function setAttributes(xml : Xml) {
        for (a in xml.attributes()) {
            switch(a) {
                case "encoding":
                    this.encoding = xml.get(a);
                case "compression":
                    this.compression = xml.get(a);
            }
        }
    }
    
    function setChildren(xml : Xml) {
        switch (encoding) {
            case "csv":
                tiles = getTilesFromCsv();
            case "base64": {
                switch (compression) {
                    case "gzip":
                        tiles = getTilesFromBase64GZip();
                    case "zlib":
                        tiles = getTilesFromBase64ZLib(xml.firstChild().nodeValue);
                }
            }
            default:
                tiles = getTilesFromChildren(xml);
        }
    }

    function getTilesFromChildren(xml : Xml) : Array<TiledTile> {
        return null;
    }

    function getTilesFromCsv() : Array<TiledTile> {
        return null;
    }

    function getTilesFromBase64GZip() : Array<TiledTile> {
        return null;
    }

    function getTilesFromBase64ZLib(layerData : String) : Array<TiledTile> {
        var parsedTiles = new Array<TiledTile>();
        var base = new haxe.crypto.BaseCode(haxe.io.Bytes.ofString("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"));
        var data = StringTools.trim(layerData);
        while( data.charCodeAt(data.length-1) == "=".code ) {
            data = data.substr(0, data.length - 1);
        }

        var bytes = haxe.io.Bytes.ofString(data);
        var bytes = base.decodeBytes(bytes);
        bytes = format.tools.Inflate.run(bytes);
        var input = new haxe.io.BytesInput(bytes);
        for( i in 0...bytes.length >> 2 ) {
            parsedTiles.push(new TiledTile(input.readInt32()));
        }
    
        return parsedTiles;
    }

    function get_encoding() {
        return this.encoding;
    }

    function get_compression() {
        return this.compression;
    }

    function get_tiles() {
        return this.tiles;
    }
}
