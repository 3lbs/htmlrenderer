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

package htmlrenderer.html.css
{

	import totem.core.Destroyable;

	public class MediaStyles extends Destroyable
	{

		private var blocks : Vector.<MediaBlockStyle>;

		private var sizePattern : RegExp = /\(max\-width:[\s]*([\s]*[0-9]+)px[\s]*\)/g;

		public function MediaStyles()
		{
			blocks = new Vector.<MediaBlockStyle>();
			super();
		}

		override public function destroy() : void
		{
			super.destroy();

			while ( blocks.length )
				blocks.pop().destroy();

			blocks = null;

			sizePattern = null;
		}

		public function getMediaStyle( styleName : String, width : Number ) : Object
		{
			for each ( var mediaBlock : MediaBlockStyle in blocks )
			{
				if ( mediaBlock.max_width <= width )
				{
					return mediaBlock.getStyle( styleName );
				}
			}
			return null;
		}

		public function hasMediaBlock( styleName : String, width : Number ) : Boolean
		{
			for each ( var mediaBlock : MediaBlockStyle in blocks )
			{
				if ( mediaBlock.max_width <= width )
				{
					return mediaBlock.hasStyle( styleName );
				}
			}
			return false;
		}

		public function parseMediaCSS( css : String ) : void
		{

			var mediaBlock : MediaBlockStyle = new MediaBlockStyle();

			// the max-width from the media block
			var mediaBlockCSS : String = css.substring( css.indexOf( "#" ), css.length );

			var max_width : Number = parseInt( css.match( /\d{1,}px/ )[ 0 ]);
			mediaBlock.max_width = max_width;
			mediaBlock.parseCSS( mediaBlockCSS );

			blocks.push( mediaBlock );
			blocks.sort( compareFunction );
		}

		private function compareFunction( item0 : MediaBlockStyle, item1 : MediaBlockStyle ) : int
		{
			if ( item0.max_width > item1.max_width )
			{
				return 1;
			}
			else if ( item0.max_width < item1.max_width )
			{
				return -1;
			}

			return 0;
		}
	}
}
