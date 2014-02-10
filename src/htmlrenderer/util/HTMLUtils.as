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

package htmlrenderer.util
{

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class HTMLUtils
	{
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

		public static function convertCSS_RGBColor( value : String ) : uint
		{
			if ( ColorsByName.isSupported( value ))
			{
				return ColorsByName.convertColor( value );
			}
			else if ( RegExpPatterns.isRGBandA.test( value ))
			{
				var n : Array = value.match( RegExpPatterns.getDelemitedNumbers );

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

		public static function webColor() : uint
		{
			var colorKeywordPattern : RegExp = /^(?:red|tan|grey|gray|lime|navy|blue|teal|aqua|cyan|gold|peru|pink|plum|snow|[a-z]{5,20})$/g;

			return 0;
		}

		public function HTMLUtils()
		{
		}
	}
}
