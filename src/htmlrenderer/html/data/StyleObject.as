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

package htmlrenderer.html.data
{

	public dynamic class StyleObject extends StyleRect
	{

		public var background : StyleBackground = new StyleBackground();

		public var clear : String = "none";

		public var display : String = "block";

		public var float : String = "none";

		public var margin : StyleRect = new StyleRect();

		public var padding : StyleRect = new StyleRect();

		public var position : String = "static";
		
		public var border : StyleBorder = new StyleBorder();

		public function StyleObject()
		{
		}

		override public function clone() : StyleRect
		{
			var so : StyleObject = new StyleObject();

			so.margin = margin.clone();
			so.padding = padding.clone();

			so.clear = clear;
			so.display = display;
			so.float = float;
			so.position = position;
			
			so.background = background.clone();

			const props : Array = [ "backgroundColor", "*zoom" ];

			for each ( var prop : String in props )
			{
				if ( this[ prop ])
				{
					so[ prop ] = this[ prop ]
				}
			}

			return so;
		}
	}
}
