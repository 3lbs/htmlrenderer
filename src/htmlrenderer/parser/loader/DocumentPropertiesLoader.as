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

	import htmlrenderer.html.Document;

	public class DocumentPropertiesLoader extends FileStreamLoader
	{

		private var _document : Document;

		public function DocumentPropertiesLoader( url : String )
		{
			super( url );
		}

		override public function destroy() : void
		{
			_document = null;

			super.destroy();
		}

		public function set document( value : Document ) : void
		{
			_document = value;
		}

		override protected function finished() : void
		{

			if ( _document )
			{
				var object : Object = JSON.parse( String( data ));

				var props : Object = _document.properties;

				for ( var key : String in object )
				{
					props[ key ] = object[ key ]
				}

			}

			_document = null;

			super.finished();
		}
	}
}
