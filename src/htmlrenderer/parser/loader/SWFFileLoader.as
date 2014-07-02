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

package htmlrenderer.parser.loader
{

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;

	public class SWFFileLoader extends SingleFileLoader
	{
		
		public var loader : Loader;
		
		public function SWFFileLoader( url : String )
		{
			super( url );
		}

		
		override public function destroy() : void
		{
			loader.unloadAndStop();
			loader = null;
		}
		
		
		override protected function handleComplete( e : Event ) : void
		{
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, onDataComplete );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, handleError );

			var _lc : LoaderContext = new LoaderContext( false, ApplicationDomain.currentDomain, null );
			_lc.allowCodeImport = true;
			_lc.allowLoadBytesCodeExecution = true;
			
			loader.loadBytes( data, _lc );
		}
		
		protected function onDataComplete( event : Event ) : void
		{
			
			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onDataComplete );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, handleError );
			
			var FontLibrary : Class;
			
			var applicationDomain : ApplicationDomain = loader.content.loaderInfo.applicationDomain;
	
			
			finished();
		}
	}
}
