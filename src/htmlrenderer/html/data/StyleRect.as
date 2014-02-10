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

	import flash.geom.Rectangle;

	public class StyleRect
	{

		private var _bottom : * = 0;

		private var _height : * = 0;

		private var _left : * = 0;

		private var _rect : Rectangle;

		private var _right : * = 0;

		private var _top : * = 0;

		private var _width : * = 0;

		private var dirty : Boolean;

		public function StyleRect( width : * = 0, height : * = 0, left : * = 0, top : * = 0, right : * = 0, bottom : * = 0 )
		{
			this.width = width;
			this.height = height;

			this.left = left;
			this.top = top;
			this.right = right;
			this.bottom = bottom;
		}

		public function get bottom() : *
		{
			return _bottom;
		}

		public function set bottom( value : * ) : void
		{
			if ( value != _bottom )
			{
				_bottom = value;
				dirty = true;
			}
		}

		public function clone() : StyleRect
		{
			return new StyleRect( width, height, left, top, right, bottom );
		}

		public function get height() : *
		{
			return _height;
		}

		public function set height( value : * ) : void
		{
			if ( value != _height )
			{
				_height = value;
				dirty = true;
			}
		}

		public function get left() : *
		{
			return _left;
		}

		public function set left( value : * ) : void
		{

			if ( value != _left )
			{
				_left = value;
				dirty = true;
			}
		}

		public function get rect() : Rectangle
		{
			if ( !_rect || dirty )
			{
				_rect = new Rectangle( left, top, width, height );
				dirty = false;
			}
			return rect;
		}

		public function get right() : *
		{
			return _right;
		}

		public function set right( value : * ) : void
		{

			if ( value != _right )
			{
				_right = value;
				dirty = true;
			}
		}

		public function get top() : *
		{
			return _top;
		}

		public function set top( value : * ) : void
		{
			if ( value != top )
			{
				_top = value;
				dirty = true;
			}
		}

		public function get width() : *
		{
			return _width;
		}

		public function set width( value : * ) : void
		{
			if ( value != _width )
			{
				_width = value;
				dirty = true;
			}
		}
	}
}
