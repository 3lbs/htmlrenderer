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

	public class Layer extends Node
	{
		private var _zIndex : uint = 0;

		public function Layer( document : Document, zIndex : uint )
		{
			super( document );
			style.width = style.height = "100%";

			// style.background.alpha = 0;
			// draw( style );

			_zIndex = zIndex;
			name = "_layer_" + zIndex;
		}

		public function get elements() : Array
		{
			var result : Array = []

			for ( var i : int = 0; i <= numChildren; i++ )
			{
				result.push( getChildAt( i ));
			}
			return result;
		}

		public function get zIndex() : uint
		{
			return _zIndex;
		}

		public function set zIndex( value : uint ) : void
		{
			if ( value !== _zIndex )
			{
				_zIndex = value;
					// TODO: Loop through all of the display objects and swapDepths
			}
		}
	}
}
