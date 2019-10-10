package hxtiled;

import format.tools.Inflate;
import haxe.io.BytesInput;
import haxe.io.Bytes;
import haxe.crypto.Base64;

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
                tiles = getTilesFromCsv(xml);
            case "base64": {
                switch (compression) {
                    case "gzip":
                        tiles = getTilesFromBase64GZip(xml.firstChild().nodeValue);
                    case "zlib":
                        tiles = getTilesFromBase64ZLib(xml.firstChild().nodeValue);
                    default:
                        tiles = getTilesFromBase64(xml.firstChild().nodeValue);
                }
            }
            default:
                tiles = getTilesFromChildren(xml);
        }
    }

    function getTilesFromChildren(xml : Xml) : Array<TiledTile> {
        var parsedTiles = new Array<TiledTile>();
        for (c in xml.elements()) {
            var attributes = c.attributes();
            if (attributes.hasNext()) {
                parsedTiles.push(new TiledTile(Std.parseInt(c.get("gid"))));
            }
            else {
                // Storing tiles that get ignored by drawTiledLayers kinda sucks
                // but oh well ¯\_(ツ)_/¯
                parsedTiles.push(new TiledTile(0));
            }
        }

        return parsedTiles;
    }

    function getTilesFromCsv(xml : Xml) : Array<TiledTile> {
        var parsedTiles = new Array<TiledTile>();
        var csvString = xml.firstChild().nodeValue;
        var splitString = csvString.split(',');
        for (c in splitString) {
            parsedTiles.push(new TiledTile(Std.parseInt(c)));
        }

        return parsedTiles;
    }

    function getTilesFromBase64(layerData : String) : Array<TiledTile> {
        var parsedTiles = new Array<TiledTile>();
        
        var bytes = decodeBase64String(layerData);
        var input = new haxe.io.BytesInput(bytes);
        for( i in 0...bytes.length >> 2 ) {
            parsedTiles.push(new TiledTile(input.readInt32()));
        }

        return parsedTiles;
    }

    function getTilesFromBase64GZip(layerData : String) : Array<TiledTile> {
        throw("Deserializing base64 (gzip compressed) is not supported.");
        return null;
    }

    function getTilesFromBase64ZLib(layerData : String) : Array<TiledTile> {
        var parsedTiles = new Array<TiledTile>();
        
        var bytes = decodeBase64String(layerData);
        bytes = Inflate.run(bytes);
        var input = new BytesInput(bytes);
        
        for( i in 0...bytes.length >> 2 ) {
            parsedTiles.push(new TiledTile(input.readInt32()));
        }
    
        return parsedTiles;
    }

    private function decodeBase64String(base64String : String) : Bytes {
        var data = StringTools.trim(base64String);
        while( data.charCodeAt(data.length-1) == "=".code ) {
            data = data.substr(0, data.length - 1);
        }

        var bytes = Bytes.ofString(data);
        var base = new haxe.crypto.BaseCode(Bytes.ofString(Base64.CHARS));
        var bytes = base.decodeBytes(bytes);
        
        return bytes;
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
