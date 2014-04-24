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

package htmlrenderer.event
{

	import flash.events.Event;

	import htmlrenderer.html.ElementBase;

	public class HTMLEvent extends Event
	{

		public static const DRAW_COMPLETE_EVENT : String = "HTMLEvent:drawCompleteEvent";

		public static const PARSE_COMPLETE_EVENT : String = "HTMLEvent:parseCompleteEvent";

		public var element : ElementBase;

		public function HTMLEvent( type : String, element : ElementBase, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			this.element = element;
			super( type, bubbles, cancelable );
		}

		override public function clone() : Event
		{
			return new HTMLEvent( type, element, bubbles, cancelable );
		}
	}
}
