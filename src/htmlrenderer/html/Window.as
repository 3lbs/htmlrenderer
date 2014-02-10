//------------------------------------------------------------------------------
//
//     _______ __ __           
//    |   _   |  |  |--.-----. 
//    |___|   |  |  _  |__ --| 
//     _(__   |__|_____|_____| 
//    |:  1   |                
//    |::.. . |                
//    `-------'      
//                       
//   3lbs Copyright 2013 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------

package htmlrenderer.html
{

	import htmlrenderer.parser.loader.AssetManager;

	import totem.display.layout.TSprite;
	import htmlrenderer.html.css.CSS;

	/*
	import com.hurlant.eval.ByteLoader;
	import com.hurlant.eval.CompiledESC;
	import com.hurlant.eval.dump.ABCDump;
	import com.hurlant.jsobject.JSObject;
	import com.hurlant.util.Hex;
*/
	public class Window extends TSprite
	{
		public var css : CSS

		public var document : Document;

		public var frames : Vector.<Frame> = new Vector.<Frame>();

		private var _fontFilesURL : Array = [];

		private var _windowURL : String;

		private var assetManager : AssetManager;

		public function Window( width : int, height : int, url : String = null, name : String = "_self", features : Object = null, replace : Boolean = false )
		{
			super();

			graphics.beginFill( 0xDDDDDD, 0.01 );
			graphics.drawRect( 0, 0, width, height );
			graphics.endFill();

			_windowURL = url;

			this.assetManager = new AssetManager( url );

			document = new Document( this, assetManager );
			addChild( document );

			var frame : Frame = new Frame( document, url, name, features );
			frame.graphics.clear();
			frames.push( frame );

			css = new CSS( width );

		}

		public function get fontFilesURL() : Array
		{
			return _fontFilesURL;
		}

		public function set fontFilesURL( value : Array ) : void
		{
			_fontFilesURL = value;
		}

		public function render( value : String ) : void
		{
			frames[ 0 ].getLayer( 0 ).innerHTML = value;
		}

		public function resizeTo( width : int, height : int ) : void
		{
			graphics.clear();
			graphics.beginFill( 0xDDDDDD, 1 );
			graphics.drawRect( 0, 0, width, height );

			for each ( var frame : Frame in frames )
			{
				//frame.draw( frame.style );
				//updateChildren( frame );

			}
		}

		//---------------------------------------
		// GETTER / SETTERS
		//---------------------------------------
		public function get windowURL() : String
		{
			return _windowURL;
		}

		public function set windowURL( value : String ) : void
		{
			if ( value !== _windowURL )
			{
				_windowURL = value;
			}
		}
	}
}
