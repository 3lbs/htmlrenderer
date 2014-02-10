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

	public dynamic class StyleBackground
	{

		public var alpha : Number = 1;

		public var color : *;

		public var type : String = "none";

		public function StyleBackground( alpha : Number = 1, color : * = null, type : String = "none" )
		{
			this.alpha = alpha;
			this.color = color;
			this.type = type;
		}

		public function clone() : StyleBackground
		{
			var sb : StyleBackground = new StyleBackground( alpha, color, type )
				
			const props : Array = [ "backgroundImage" ];
			
			for each ( var prop : String in props )
			{
				if ( this[ prop ])
				{
					sb[ prop ] = this[ prop ]
				}
			}

			return sb;
		}
	}
}
