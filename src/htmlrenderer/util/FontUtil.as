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
	import flash.text.engine.BreakOpportunity;
	import flash.text.engine.CFFHinting;
	import flash.text.engine.DigitCase;
	import flash.text.engine.DigitWidth;
	import flash.text.engine.ElementFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.FontWeight;
	import flash.text.engine.Kerning;
	import flash.text.engine.LigatureLevel;
	import flash.text.engine.RenderingMode;
	import flash.text.engine.TextBaseline;
	import flash.text.engine.TextRotation;
	import flash.text.engine.TypographicCase;

	public class FontUtil
	{

		public static var FONT_TYPE_ADOBE : String = "edgefonts";

		public static function cleanFontName( value : String ) : String
		{
			value = value.replace( "-", "_" );
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

		/**+
		 * 	Reads a set of style properties for a named style and then creates
		 * 	a TextFormat object that uses the same properties.
		 *	@private
		 */
		public static function getFormat( style : Object ) : ElementFormat
		{

			var fd : FontDescription = new FontDescription( style.fontFamily || "_sans", getFontWeight( style.fontWeight ) || FontWeight.NORMAL, style.fontPosture || style.fontStyle || FontPosture.NORMAL, FontLookup.DEVICE, RenderingMode.NORMAL, CFFHinting.NONE );
			var format : ElementFormat = new ElementFormat( fd, style.fontSize || 12, style.color || 0, style.alpha || 1, style.textRotation || TextRotation.AUTO, style.textBaseline || TextBaseline.ROMAN, TextBaseline.USE_DOMINANT_BASELINE, 0.0, // baselineShift
				style.kerning || Kerning.ON, // "on" || "off"
				0.0, // trackingRight
				0.0, // trackingLeft
				"en", // local
				style.breakOpportunity || BreakOpportunity.AUTO, style.digitCase || DigitCase.DEFAULT, style.digitWidth || DigitWidth.DEFAULT, style.ligatureLevel || LigatureLevel.NONE, style.textTransform || style.fontVariant || style.typographicCase || TypographicCase.DEFAULT );

			if ( style.hasOwnProperty( "letterSpacing" ))
			{
				format.trackingRight = style.letterSpacing;
			}
			return format;
		}

		public static function hasFont( value : String ) : Boolean
		{

			var fonts : Array = Font.enumerateFonts( true );

			for each ( var font : Font in fonts )
			{
				//trace( font.fontName + ":" + font.fontType );

				if ( font.fontName == value )
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
