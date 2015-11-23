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

	import flash.display.DisplayObject;
	import flash.filters.DropShadowFilter;
	
	import htmlrenderer.html.ElementBase;
	import htmlrenderer.html.css.CSSProperties;
	import htmlrenderer.html.css.CSSUtil;
	
	import totem.math.Vector2D;

	public class ElementUtil
	{

		public static const BLOCK : String = "block";

		public static const INLINE : String = "inline";

		private static const COMPUTED_STYLES : String = "computedStyles";

		public static function drawShadow( colorProp : String, displayObject : DisplayObject ) : void
		{

			var rgbPattern : RegExp = /(?:rgb)a?\(\d{1,3},\s?\d{1,3},\s?\d{1,3}(?:,\s?[0-9\.]+)?\)/;

			var rgbString : String = colorProp.match( rgbPattern )[ 0 ];
			
			//var result : Array = colorProp.match(/(-?\d+px)|((?:rgb)a?\(.+\))/g);
			//var result1 : Array = colorProp.match(/((?:rgb)a?\(.+\))/g);
			var shadowVector : Array = colorProp.match(/(-?\d+px)/g);
				
			//var rgbColor : uint = HTMLUtils.convertCSS_RGBColor( rgbString );

			//var a : Array = colorProp.split( "(" )[ 1 ].split( ")" );
			/*var c : Array = a[ 0 ].split( "," );
			var color : uint = HTMLUtils.convertRGB( c[ 0 ], c[ 1 ], c[ 2 ]);*/

			var rgbArray : Array = rgbString.match( CSSUtil.getDelemitedNumbers );
			var color : uint = HTMLUtils.convertRGB( rgbArray[ 0 ], rgbArray[ 1 ], rgbArray[ 2 ]);

			var alpha : Number = 1;

			if ( rgbArray[ 3 ])
			{
				alpha = parseFloat( rgbArray[ 3 ]);
			}

			//var propArray : Array = a[ 1 ].split( " " );

			var blur : Number = TypeUtils.cleanString( shadowVector[ 2 ]);
			var point : Vector2D = new Vector2D( TypeUtils.cleanString( shadowVector[ 0 ]), TypeUtils.cleanString( shadowVector[ 1 ]));
			var angle : Number = point.toRotation() * ( 180 / Math.PI );

			var shadow : DropShadowFilter = new DropShadowFilter();
			shadow.distance = point.length;
			shadow.color = color;
			shadow.blurX = blur;
			shadow.blurY = blur;
			shadow.quality = 3;
			shadow.alpha = 1;
			shadow.angle = angle;
			shadow.alpha = alpha;


			
			
			displayObject.filters = [ shadow ];
		}

		public static function sortElementDepth( element : ElementBase ) : void
		{
			var standardItems : Array = [];
			var floatedItems : Array = [];

			//-----------------------------------------------
			//
			// Changes depths of items based on there properties, floats are above. I'm not sure if this is correct.
			//
			// -----------------------------------------------

			var childrenList : Vector.<ElementBase> = element.childrenElements;

			for ( var h : int = 0; h < childrenList.length; h++ )
			{
				var currentItem : * = childrenList[ h ];

				if ( currentItem.hasOwnProperty( COMPUTED_STYLES ))
				{
					if ( currentItem.computedStyles.hasOwnProperty( CSSProperties.FLOAT ))
					{
						if ( currentItem.computedStyles.float == "left" )
						{
							floatedItems.push( currentItem );
						}
						else if ( currentItem.computedStyles.float == "right" )
						{
							floatedItems.push( currentItem );
						}
					}
					else
					{
						standardItems.push( currentItem );
					}
				}
				else
				{
					standardItems.push( currentItem );
				}
			}

			var depthCount : int = 0;

			for each ( var depthItem : * in standardItems )
			{
				element.addChildAt( depthItem, depthCount );
				depthCount++;
			}

			for each ( depthItem in floatedItems )
			{
				element.addChildAt( depthItem, depthCount );
				depthCount++;
			}

			standardItems.length = 0;
			floatedItems.length = 0;

		}

		public function ElementUtil()
		{
		}
	}
}
