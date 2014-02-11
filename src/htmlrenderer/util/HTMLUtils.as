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

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import htmlrenderer.html.css.CSSUtil;

	public class HTMLUtils
	{

		private static const COLORS : Object = new Object();

		public static function cleanURL( value : String ) : String
		{
			if ( value.indexOf( "url(" ) != -1 )
			{
				return value.substr( value.indexOf( "url(" ) + 4, value.lastIndexOf( ")" ) - 1 ).split( '"' ).join( "" ).split( ")" ).join( "" );
			}

			return value;
		}

		public static function cloneObject( source : Object ) : Object
		{
			var ba : ByteArray = new ByteArray();
			ba.writeObject( source );
			ba.position = 0;
			return ba.readObject();
		}

		/**
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public static function convertCSS_RGBColor( value : String ) : uint
		{
			if ( HTMLUtils.isSupported( value ))
			{
				return HTMLUtils.convertColor( value );
			}
			else if ( CSSUtil.isRGBandA.test( value ))
			{
				var n : Array = value.match( CSSUtil.getDelemitedNumbers );

				if ( n.length == 3 )
				{
					return convertRGB( n[ 0 ], n[ 1 ], n[ 2 ]);
				}
				else if ( n.length == 4 )
				{
					return convertRGBA( n[ 0 ], n[ 1 ], n[ 2 ], n[ 3 ]);
				}
			}
			return TypeUtils.cleanString( value );
		}

		/**
		 *
		 * @param name
		 * @param value
		 */
		public static function convertColor( colorName : String ) : uint
		{
			return COLORS.hasOwnProperty( colorName ) ? COLORS[ colorName ] : 0x000000;
		}

		public static function convertRGB( r : uint, g : uint, b : uint ) : uint
		{
			return (( r << 16 ) | ( g << 8 ) | b )
		}

		public static function convertRGBA( r : uint, g : uint, b : uint, a : Number ) : uint
		{
			if ( a < 0.0 )
				a = 0.0;
			else if ( a > 1.0 )
				a = 1.0;

			if ( r < 0.0 )
				r = 0.0;
			else if ( r > 1.0 )
				r = 1.0;

			if ( g < 0.0 )
				g = 0.0;
			else if ( g > 1.0 )
				g = 1.0;

			if ( b < 0.0 )
				b = 0.0;
			else if ( b > 1.0 )
				b = 1.0;

			return int( a * 255 ) << 24 | int( r * 255 ) << 16 | int( g * 255 ) << 8 | int( b * 255 );
		}

		public static function generateCheckerboard( width : int, height : int, cellWidth : int = 32, cellHeight : int = 32, color1 : uint = 0xffe7e6e6, color2 : uint = 0xffd9d5d5 ) : BitmapData
		{
			var bitmapData : BitmapData = new BitmapData( width, height );
			var numRows : int = Math.ceil( height / cellHeight );
			var numCols : int = Math.ceil( width / cellWidth );

			var clipRect : Rectangle = new Rectangle( 0, 0, cellWidth, cellHeight );

			var y : int;
			var x : int;
			var lastColor : uint = color1;

			for ( y = 0; y < numRows; y++ )
			{
				for ( x = 0; x < numCols; x++ )
				{
					clipRect.y = y * cellHeight;
					clipRect.x = x * cellWidth;
					bitmapData.fillRect( clipRect, lastColor );

					lastColor = ( lastColor == color1 ) ? color2 : color1;

					if ( x + 1 == numCols && x % 2 != 0 )
						lastColor = ( lastColor == color1 ) ? color2 : color1;
				}
			}

			return bitmapData;
		}

		/**
		 * <p>Looks up the property type and confirms that it exists.</p>
		 *
		 * @param property
		 */
		public static function isSupported( colorName : String ) : Boolean
		{
			return ( COLORS.hasOwnProperty( colorName ));
		}

		public static function registerColor( name : String, color : uint ) : void
		{
			COLORS[ name ] = color;
		}

		public static function removeColor( name : String ) : void
		{
			delete COLORS[ name ];
		}

		public static function webColor() : uint
		{
			var colorKeywordPattern : RegExp = /^(?:red|tan|grey|gray|lime|navy|blue|teal|aqua|cyan|gold|peru|pink|plum|snow|[a-z]{5,20})$/g;

			return 0;
		}

		{
			COLORS[ "black" ] = 0x000000;
			COLORS[ "blue" ] = 0x0000FF;
			COLORS[ "green" ] = 0x008000;
			COLORS[ "gray" ] = 0x808080;
			COLORS[ "silver" ] = 0xC0C0C0;
			COLORS[ "lime" ] = 0x00FF00;
			COLORS[ "olive" ] = 0x808000;
			COLORS[ "white" ] = 0xFFFFFF;
			COLORS[ "yellow" ] = 0xFFFF00;
			COLORS[ "maroon" ] = 0x800000;
			COLORS[ "navy" ] = 0x000080;
			COLORS[ "red" ] = 0xFF0000;
			COLORS[ "purple" ] = 0x800080;
			COLORS[ "teal" ] = 0x008080;
			COLORS[ "fuchsia" ] = 0xFF00FF;
			COLORS[ "aqua" ] = 0x00FFFF;
			COLORS[ "magenta" ] = 0xFF00FF;
			COLORS[ "cyan" ] = 0x00FFFF;
		}

		public function HTMLUtils()
		{
		}
	}
}
