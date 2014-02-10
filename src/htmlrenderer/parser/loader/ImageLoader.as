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

package htmlrenderer.parser.loader
{

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;

	import htmlrenderer.html.Document;

	public class ImageLoader extends Asset
	{

		public var document : Document;

		public var objectData : Object;

		private var _loader : Loader = new Loader();

		public function ImageLoader( url : String )
		{
			super( url );
		}

		public function get bitmapData() : BitmapData
		{
			if ( data is BitmapData )
			{
				return data
			}
			else if ( data is Bitmap )
			{
				return Bitmap( data ).bitmapData;
			}
			return null;
		}

		override public function get data() : *
		{
			return loader.content;
		}

		override public function destroy() : void
		{
			removeEvents();

			_loader.unloadAndStop();
			_loader = null;

			document = null;

			objectData = null;

			super.destroy();
		}

		public function get loader() : Loader
		{
			return _loader;
		}

		override public function start() : void
		{
			super.start();

			if ( _status != EMPTY )
				return;

			var context : LoaderContext = new LoaderContext( true, new ApplicationDomain( ApplicationDomain.currentDomain ) );

			//loader.load( req, context );

			var request : URLRequest = new URLRequest( url );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, handleError );
			loader.contentLoaderInfo.addEventListener( Event.INIT, simpleLoaderInit );
			loader.load( request, context );
		}

		protected function handleComplete( event : Event ) : void
		{
			removeEvents();
			finished();
		}

		protected function handleError( event : IOErrorEvent ) : void
		{
			removeEvents();
			throw new Error( event.text );
		}

		protected function simpleLoaderInit( event : Event ) : void
		{
			dispatchEvent( event );
		}

		override protected function removeEvents() : void
		{
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, handleComplete );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, handleError );
			loader.contentLoaderInfo.removeEventListener( Event.INIT, simpleLoaderInit );
		}
	}
}
