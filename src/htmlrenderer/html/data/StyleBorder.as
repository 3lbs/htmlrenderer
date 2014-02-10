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

	public class StyleBorder extends StyleRect
	{
		public function StyleBorder()
		{
		}
		
		override public function clone() : StyleRect
		{
			var sb : StyleBorder = new StyleBorder( )
			
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
