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
//   3lbs Copyright 2014 
//   For more information see http://www.3lbs.com 
//   All rights reserved. 
//
//------------------------------------------------------------------------------


// rules : 

//  capital letters in css id properties

package htmlrenderer
{

	import flash.filesystem.File;
	
	import htmlrenderer.event.HTMLEvent;
	import htmlrenderer.html.Document;
	import htmlrenderer.parser.loader.AssetManager;
	
	import totem.core.Destroyable;
	import totem.monitors.promise.DeferredEventDispatcher;
	import totem.monitors.promise.IPromise;

	public class HTMLRenderer extends Destroyable
	{

		public var baseURL : File;

		public var scriptURL : String = "";
		
		private var _baseFont : int = 16;

		private var _fontURLFiles : Array = [];

		private var assetManager : AssetManager;

		public function HTMLRenderer( assetManager : AssetManager )
		{
			this.assetManager = assetManager;
	
		}

		public function addFontURL( url : String ) : void
		{
			_fontURLFiles.push( url );
		}

		public function get baseFont() : int
		{
			return _baseFont;
		}

		public function set baseFont( value : int ) : void
		{
			_baseFont = value;
		}

		override public function destroy() : void
		{
			super.destroy();

			_fontURLFiles.length = 0;
			_fontURLFiles = null;

			assetManager = null;
		}

		public function get fontURLFiles() : Array
		{
			return _fontURLFiles;
		}

		public function renderDocument( source : String, width : int, height : int ) : IPromise
		{
			var document : Document = new Document( width, height, assetManager );
			document.baseFile = baseURL;
			document.scriptLoc = scriptURL;
			document.baseFont = _baseFont;

			if ( _fontURLFiles.length > 0 )
			{
				document.fontURLFiles = _fontURLFiles;
			}

			var defferedEventDispatcher : DeferredEventDispatcher = new DeferredEventDispatcher( document );
			defferedEventDispatcher.resolveOn( HTMLEvent.DRAW_COMPLETE_EVENT );

			document.render( source );

			return defferedEventDispatcher.promise();
		}
	}
}
