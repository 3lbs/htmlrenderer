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

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class SingleFileLoader extends Asset
	{

		private var urlLoader : URLLoader = new URLLoader();

		public function SingleFileLoader( url : String )
		{
			super( url );
		}

		override public function get data() : *
		{
			return urlLoader.data;
		}

		override public function destroy() : void
		{
			removeEvents();
			
			urlLoader.data = null;
			urlLoader = null;
			
			super.destroy();
		}

		override public function start() : void
		{
			super.start();
			
			if ( _status != EMPTY )
				return;
			
			var request : URLRequest = new URLRequest( url );
			
			urlLoader.dataFormat = URLLoaderDataFormat.BINARY;
			urlLoader.addEventListener( Event.COMPLETE, handleComplete );
			urlLoader.addEventListener( IOErrorEvent.IO_ERROR, handleError );
			urlLoader.load( request );
		}

		protected function handleComplete( event : Event ) : void
		{
			removeEvents();
			finished();
		}

		protected function handleError( event : IOErrorEvent ) : void
		{
			removeEvents();
			
			failed();
			throw new Error( event.text );
		}

		override protected function removeEvents() : void
		{
			urlLoader.removeEventListener( Event.COMPLETE, handleComplete );
			urlLoader.removeEventListener( IOErrorEvent.IO_ERROR, handleError );
		}
	}
}
