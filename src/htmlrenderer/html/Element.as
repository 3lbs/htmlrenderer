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

package htmlrenderer.html
{

	public class Element extends Node
	{

		/**
		 *	@constructor
		 *	@param	styles	 Object containing all styles for different states of this element
		 *	@param	events	 Object created by ObjectUtils to preclean method calls
		 */
		public function Element( document : Document = null, element : Node = null, xml : XML = null, style : Object = null )
		{
			super( document, element, xml, style );
		}

		override public function destroy() : void
		{
			super.destroy();
		}
	}
}
