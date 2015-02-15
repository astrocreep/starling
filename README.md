starling-openfl
===============
An unofficial port of Starling framework.

[HTML5 version of the demo](http://vroad.github.io/starling-samples) (Last Update:2015/10/14)

[io.js version of the demo for Windows x86](https://www.dropbox.com/s/2rt488tjxqzdqvi/Starling_demo_iojs_20150215.zip?dl=0) (Last Update:2015/02/15)

Install
-------
   haxelib git starling https://github.com/vroad/starling-openfl

Dependencies:

    haxelib git openfl https://github.com/vroad/openfl
    haxelib git lime https://github.com/vroad/lime

To use original version of away3d and openfl again, type these commands(If you are using openfl 2.2.4 and lime 2.0.6).

    haxelib set openfl 2.2.4
    haxelib set lime 2.0.6

Current Limitations
-------------------

starling-openfl limitations:

* Needs "next" version of OpenFL.
  * Add this line to your project xml to enable it: ```<set value="openfl-next" value="1" />```
* Only works on html5, cpp, and unofficial Node.js target.
  * Except for html5, only windows platform is tested. 
* DisplacementMapFilter don't work correctly. The filter just moves a object a little bit.
  * Noises that are used in DisplacementMapFilter example cannot be generated on OpenFL for now.
* Mini-Bitmap Font is not supported.
* On native targets, only loaded fonts can be specified with their name.
* BitmapData is uploaded as non-premultiplied RGBA data.

OpenFL Limitations(As of 2.2.4):

* You need to set vertices and shader variables after setting a shader program.
* Filtering, Texture repeat, Mipmapping flags specified in AGAL shader is not used. You need to set these flags manually with Context3D.setSamplerState.
