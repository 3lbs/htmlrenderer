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

	import flash.text.Font;
	import flash.text.engine.FontWeight;

	public class FontUtil
	{

		public static var FONT_TYPE_ADOBE : String = "edgefonts";

		public static function cleanFontName( value : String ) : String
		{
			//value = value.replace( "-", "_" );
			
			//trace("value before " + value );
			var pattern:RegExp = /-/g;
			value = value.replace(pattern,"_");
			
			value = value.replace(/["']/g, "")
			//trace("value before " + value );
			return value;
		}

		public static function getFontSize( value : *, baseFont : Number = 16 ) : Number
		{
			if ( value is Number )
				return value as Number;
			else if ( value is String )
			{
				if ( TypeUtils.isStringPercent( value as String ))
					return TypeUtils.percentToNumber( value as String, baseFont );
				else if ( isEM( value ))
					return emToNumber( value, baseFont );
				else if ( TypeUtils.isStringFloat( value as String ))
					return parseFloat( value as String );
			}

			return baseFont;
		}

		public static function getFontWeight( value : * ) : String
		{
			if ( !isNaN( value ))
			{
				var weight : Number = parseFloat( value );

				if ( weight > 400 )
				{
					return FontWeight.BOLD;
				}
			}

			return FontWeight.NORMAL;
		}

		public static function hasFont( value : String ) : Boolean
		{

			var fonts : Array = Font.enumerateFonts( false );

			for each ( var font : Font in fonts )
			{
				//trace( font.fontName + ":" + font.fontType );

				if ( font.fontName.toLowerCase() == value )
				{
					return true;
				}
			}
			return false;
		}

		public static function parseFontString_AdobeReflow( value : String ) : Vector.<String>
		{

			return null;
		}

		private static function emToNumber( value : *, baseFont : Number ) : Number
		{
			return parseFloat( value ) * baseFont;
		}

		private static function isEM( value : String ) : Boolean
		{
			return ( value != null && value.indexOf( "em" ) > -1 );
		}
	}
}
