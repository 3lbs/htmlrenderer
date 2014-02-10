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

	public class CSSProperties
	{

		public static const ADVANCED : String = "advanced";

		public static const ALIGN : String = "align";

		public static const ALPHA : String = "alpha";

		public static const ALWAYS_SHOW_SELECTION : String = "alwaysShowSelection";

		public static const ANTI_ALIAS_TYPE : String = "antiAliasType";

		public static const AUTO : String = "auto";

		public static const AUTO_SIZE : String = "autoSize";

		public static const BACKGROUND_ATTACHMENT : String = "backgroundAttachment";

		public static const BACKGROUND_COLOR : String = "backgroundColor";

		public static const BACKGROUND_IMAGE : String = "backgroundImage";

		public static const BACKGROUND_POSITION : String = "backgroundPosition";

		public static const BACKGROUND_REPEAT : String = "backgroundRepeat";

		public static const BACKGROUND_SIZE : String = "backgroundSize";

		public static const BLOCK_INDENT : String = "blockIndent";

		public static const BOLD : String = "bold";

		public static const BORDER : String = "border";

		public static const BORDER_BOTTOM_LEFT_RADIUS : String = "borderBottomLeftRadius";

		public static const BORDER_BOTTOM_RIGHT_RADIUS : String = "borderBottomRightRadius";

		public static const BORDER_TOP_LEFT_RADIUS : String = "borderTopLeftRadius";

		public static const BORDER_TOP_RIGHT_RADIUS : String = "borderTopRightRadius";

		public static const BOTTOM : String = "bottom";

		public static const BOTTOM_LEFT : String = "bottomLeft";

		public static const BOTTOM_RIGHT : String = "bottomRight";

		public static const BULLET : String = "bullet";

		public static const CENTER : String = "center";

		public static const CENTER_LEFT : String = "centerLeft";

		public static const CENTER_RIGHT : String = "centerRight";

		public static const COLOR : String = "color";

		public static const CONDENSE_WHITE : String = "condenseWhite";

		public static const CURSOR : String = "cursor";

		public static const DEFAULT_STYLE_NAME : String = "EmptyStyle";

		public static const DISPLAY_AS_PASSWORD : String = "displayAsPassword";

		public static const EMBED_FONTS : String = "embedFonts";

		public static const FLOAT_LEFT : String = "left";
		
		public static const FLOAT : String = "float";

		public static const FONT : String = "font";

		public static const FONT_FACE : String = "fontFace";

		public static const FONT_SIZE : String = "fontSize";

		public static const GRID_FIT_TYPE : String = "gridFitType";

		public static const HEIGHT : String = "height";

		public static const HIDDEN : String = "hidden";

		public static const INDENT : String = "indent";

		public static const ITALIC : String = "italic";

		public static const KERNING : String = "kerning";

		public static const LEADING : String = "leading";

		public static const LEFT : String = "left";

		public static const LEFT_MARGIN : String = "leftMargin";

		public static const LETTER_SPACING : String = "letterSpacing";

		public static const LOWERCASE : String = "lowercase";

		public static const MARGIN : String = "margin";

		public static const MARGIN_BOTTOM : String = "marginBottom";

		public static const MARGIN_LEFT : String = "marginLeft";

		public static const MARGIN_RIGHT : String = "marginRight";

		public static const MARGIN_TOP : String = "marginTop";

		public static const MAX_CHARS : String = "maxChars";

		public static const MIDDLE : String = "middle";

		public static const MOUSE_WHEEL_ENABLED : String = "mouseWheelEnabled";

		public static const MULTILINE : String = "multiline";

		public static const NONE : String = "none";

		public static const NORMAL : String = "normal";

		public static const NO_REPEAT : String = "no-repeat";

		public static const OVERFLOW : String = "overflow";

		public static const PADDING : String = "padding";

		public static const PADDING_BOTTOM : String = "paddingBottom";

		public static const PADDING_LEFT : String = "paddingLeft";

		public static const PADDING_RIGHT : String = "paddingRight";

		public static const PADDING_TOP : String = "paddingTop";

		public static const PIXEL : String = "pixel";

		public static const REPEAT : String = "repeat";

		public static const REPEAT_X : String = "repeat-x";

		public static const REPEAT_Y : String = "repeat-y";

		public static const RESTRICT : String = "restrict";

		public static const RIGHT : String = "right";

		public static const RIGHT_MARGIN : String = "rightMargin";

		public static const ROTATION : String = "rotation";

		public static const SCROLL : String = "scroll";

		public static const SELECTABLE : String = "selectable";

		public static const SELECTION_BEGIN_INDEX : String = "selectionBeginIndex";

		public static const SELECTION_END_INDEX : String = "selectioendIndex";

		public static const SHARPNESS : String = "sharpness";

		public static const SIZE : String = "size";

		public static const STYLE_SHEET : String = "styleSheet";

		public static const SUBPIXEL : String = "subpixel";

		public static const TAB_STOPS : String = "tabStops";

		public static const TARGET : String = "target";

		public static const TEXT_ALIGN : String = "textAlign";

		public static const TEXT_COLOR : String = "textColor";

		public static const TEXT_HEIGHT : String = "textHeight";

		public static const TEXT_WIDTH : String = "textWidth";

		public static const THICKNESS : String = "thickness";

		public static const TOP : String = "top";

		public static const TOP_LEFT : String = "topLeft";

		public static const TOP_RIGHT : String = "topRight";

		public static const UNDERLINE : String = "underline";

		public static const UPPERCASE : String = "uppercase";

		public static const VERTICAL_ALIGN : String = "verticalAlign";

		public static const VISIBILITY : String = "visibility";

		public static const VISIBLE : String = "visible";

		public static const WIDTH : String = "width";

		public static const WORD_WRAP : String = "wordWrap";

		public static const X : String = "x";

		public static const Y : String = "y";

		public static const Z_INDEX : String = "zIndex";

		public static function getBackgroundProps() : Array
		{
			return [ BACKGROUND_COLOR, BACKGROUND_IMAGE, BACKGROUND_POSITION, BACKGROUND_SIZE, BACKGROUND_REPEAT, BACKGROUND_ATTACHMENT ];
		}

		public static function getBorderProps() : Array
		{
			return [ BORDER, BORDER_TOP_LEFT_RADIUS, BORDER_TOP_RIGHT_RADIUS, BORDER_BOTTOM_LEFT_RADIUS, BORDER_BOTTOM_RIGHT_RADIUS ];
		}

		public static function getMarginProps() : Array
		{
			return [ MARGIN, MARGIN_BOTTOM, MARGIN_LEFT, MARGIN_RIGHT, MARGIN_TOP ];
		}

		public static function getPaddingProps() : Array
		{
			return [ PADDING, PADDING_BOTTOM, PADDING_LEFT, PADDING_RIGHT, PADDING_TOP ];
		}
	}
}

