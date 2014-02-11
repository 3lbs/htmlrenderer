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

package htmlrenderer
{

	import htmlrenderer.event.HTMLEvent;
	import htmlrenderer.html.Document;
	import htmlrenderer.parser.loader.AssetManager;

	import totem.core.Destroyable;
	import totem.monitors.promise.DeferredEventDispatcher;
	import totem.monitors.promise.IPromise;

	public class HTMLRenderer extends Destroyable
	{

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

			if ( _fontURLFiles.length > 0 )
			{
				document.fontURLFiles = _fontURLFiles;
			}
			var defferedEventDispatcher : DeferredEventDispatcher = new DeferredEventDispatcher( document );
			defferedEventDispatcher.resolveOn( HTMLEvent.PARSE_COMPLETE_EVENT );

			document.render( source );

			return defferedEventDispatcher.promise();
		}
	}
}
