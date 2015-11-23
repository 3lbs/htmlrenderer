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
	import flash.text.Font;

	public class FontLoader extends SingleFileLoader
	{
		public var fontNames : Array;

		private var loader : Loader;

		public function FontLoader( url : String )
		{
			super( url );
		}

		override public function destroy() : void
		{
			fontNames.length = 0;
			fontNames = null;

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

			loader.loadBytes( data, _lc );
		}

		protected function onDataComplete( event : Event ) : void
		{

			loader.contentLoaderInfo.removeEventListener( Event.COMPLETE, onDataComplete );
			loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, handleError );

			var FontLibrary : Class;

			var applicationDomain : ApplicationDomain = loader.content.loaderInfo.applicationDomain;
			//checkFonts();

			for each ( var fontName : String in fontNames )
			{
				if ( applicationDomain.hasDefinition( fontName ))
				{
					FontLibrary = applicationDomain.getDefinition( fontName ) as Class;

					if ( FontLibrary )
					{
						var font : Font = new FontLibrary();
						Font.registerFont( FontLibrary );
					}
				}
			}

			//checkFonts();

			finished();
		}

		private function checkFonts() : void
		{
			trace( "================ font test ===============" );
			var fonts : Array = Font.enumerateFonts();

			for ( var i : int = 0; i < fonts.length; i++ )
				trace( "Embedded font: " + fonts[ i ].fontName );

			trace( "==========================================" );
		}
	}
}
