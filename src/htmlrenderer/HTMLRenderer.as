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

package htmlrenderer
{

	import htmlrenderer.event.HTMLEvent;
	import htmlrenderer.html.Layer;
	import htmlrenderer.html.Window;

	public class HTMLRenderer extends RendererBase
	{

		public var window : Window;

		public function HTMLRenderer( width : int, height : int, url : String = "" )
		{
			super( width, height );

			window = new Window( width, height, url );

			addChild( window );
		}

		override public function render( source : String ) : void
		{
			var layer : Layer = window.frames[ 0 ].getLayer( 0 );
			layer.addEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, completeParser );
			layer.innerHTML = source;
		}

		override public function update( width : int, height : int ) : void
		{
			window.resizeTo( width, height );
		}

		protected function completeParser( event : HTMLEvent ) : void
		{
			Layer( event.target ).removeEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, completeParser );

			dispatchEvent( event.clone());
		}
	}
}
