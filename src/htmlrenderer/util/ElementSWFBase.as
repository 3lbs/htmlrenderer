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

package htmlrenderer.util
{

	import htmlrenderer.html.ElementImage;
	import totem.display.ISWFObject;

	public class ElementSWFBase extends ElementImage implements ISWFObject
	{
		public function ElementSWFBase()
		{
			super();
		}

		override public function set display( value : Boolean ) : void
		{
		}

		public function loadURL( value : String ) : void
		{
		}

		public function unload() : void
		{

		}
	}
}
