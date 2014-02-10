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

	import flash.events.Event;
	
	import totem.display.layout.TSprite;

	public class RendererBase extends TSprite
	{

		public static const RENDERED : String = "rendered";

		public var data : Object;

		public var source : String;

		public function RendererBase( width : int, height : int )
		{
			super();

			graphics.beginFill( 0xDDDDDD, 1 );
			graphics.drawRect( 0, 0, width, height );
			graphics.endFill();

			name = "RENDERER";
		}


		public function render( source : String ) : void
		{
			
		}

		public function update( width : int, height : int ) : void
		{
			//Log.info("update", width, height)
		}

		private function onResize( event : Event ) : void
		{
			var w : int
			var h : int

			graphics.clear();
			graphics.beginFill( 0xDDDDDD, 1 );

			graphics.drawRect( 0, 0, w, h );
			graphics.endFill();

			update( w, h );
		}
	}
}
