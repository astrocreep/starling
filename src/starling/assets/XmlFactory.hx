// =================================================================================================
//
//	Starling Framework
//	Copyright Gamua GmbH. All Rights Reserved.
//
//	This program is free software. You can redistribute and/or modify it
//	in accordance with the terms of the accompanying license agreement.
//
// =================================================================================================

package starling.assets;

import openfl.utils.ByteArray;
import openfl.errors.Error;

import starling.text.BitmapFont;
import starling.text.TextField;
import starling.textures.Texture;
import starling.textures.TextureAtlas;
import starling.utils.ByteArrayUtil;

/** This AssetFactory creates XML assets, texture atlases and bitmap fonts. */
class XmlFactory extends AssetFactory
{
    /** Creates a new instance. */
    public function new()
    {
        super();
        addMimeTypes(["application/xml", "text/xml"]);
        addExtensions(["xml", "fnt"]);
    }

    /** Returns true if mime type or extension fit for XML data, or if the data starts
     *  with a "&lt;" character. */
    override public function canHandle(reference:AssetReference):Bool
    {
        return super.canHandle(reference) || (Std.is(reference.data, #if commonjs ByteArray #else ByteArrayData #end) &&
            ByteArrayUtil.startsWithString(cast(reference.data, ByteArray), "<"));
    }

    /** Creates the XML asset and passes it to 'onComplete'. If the XML contains a
     *  TextureAtlas or a BitmapFont, adds suitable post processors. */
    override public function create(reference:AssetReference, helper:AssetFactoryHelper,
                                    onComplete:String->Dynamic->Void, onError:String->Void):Void
    {
        var xml:Xml = null;
        
        var textureAtlasPostProcessor:AssetManager->Void = null;
        var bitmapFontPostProcessor:AssetManager->Void = null;
        
        textureAtlasPostProcessor = function (store:AssetManager):Void
        {
            var name:String = helper.getNameFromUrl(xml.firstElement().get("imagePath"));
            var texture:Texture = store.getTexture(name);
            if (texture != null ) store.addAsset(name, new TextureAtlas(texture, xml));
            else helper.log("Cannot create atlas: texture '" + name + "' is missing.");
        }

        bitmapFontPostProcessor = function (store:AssetManager):Void
        {
            var textureName:String = helper.getNameFromUrl(xml.firstElement().elementsNamed("pages").next().elementsNamed("page").next().get("file"));
            var texture:Texture = store.getTexture(textureName);
            var fontName:String = store.registerBitmapFontsWithFontFace ?
                xml.elementsNamed("info").next().get("face") : textureName;

            if (texture != null)
            {
                var bitmapFont:BitmapFont = new BitmapFont(texture, xml);
                store.addAsset(fontName, bitmapFont);
                TextField.registerCompositor(bitmapFont, fontName);
            }
            else helper.log("Cannot create bitmap font: texture '" + textureName + "' is missing.");
        }
        
        try
        {
            if(Std.is(reference.data, Xml))
                xml = cast(reference.data, Xml);
            else
            {
                var bytes:ByteArray = cast(reference.data, ByteArray);
                if (bytes != null)
                    xml = Xml.parse(bytes.toString());
            }
            
            var rootNode:String = xml.firstElement().nodeName;

            if (rootNode == "TextureAtlas")
                helper.addPostProcessor(textureAtlasPostProcessor, 100);
            else if (rootNode == "font")
                helper.addPostProcessor(bitmapFontPostProcessor);
                
            onComplete(reference.name, xml);
        
        }
        catch (e:Error)
        {
            onError("Could not parse XML: " + e.message);
            return;
        }
    }
}