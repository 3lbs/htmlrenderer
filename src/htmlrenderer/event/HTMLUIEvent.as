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

	import totem.events.ObjectEvent;

	public class HTMLUIEvent extends ObjectEvent
	{
		public static const SCROLL_INDEX_EVENT : String = "HTMLUIEvent:scrollIndexEvent";

		public function HTMLUIEvent( type : String, data : Object = null, bubbles : Boolean = false, cancelable : Boolean = false )
		{
			super( type, data, bubbles, cancelable );
		}

		override public function clone() : Event
		{
			return new HTMLUIEvent( type, data, bubbles, cancelable ) as Event;
		}
	}
}
