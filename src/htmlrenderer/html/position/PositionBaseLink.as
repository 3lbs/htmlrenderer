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

package htmlrenderer.html.position
{

	import htmlrenderer.html.ElementBase;

	public class PositionBaseLink
	{

		public static const COMPUTED_STYLES : String = "computedStyles";

		public static const MARGIN : String = "margin";

		public static const PADDING : String = "padding";

		protected var successor : PositionBaseLink;

		public function PositionBaseLink( successor : PositionBaseLink = null )
		{
			this.successor = successor;
		}

		public function destroy() : void
		{
			successor = null;
		}

		public function handleRequest( element : ElementBase ) : Boolean
		{
			if ( successor != null )
			{
				return successor.handleRequest( element );
			}
			return false;
		}

		public function setSuccessor( successor : PositionBaseLink ) : void
		{
			this.successor = successor;
		}
	}
}
