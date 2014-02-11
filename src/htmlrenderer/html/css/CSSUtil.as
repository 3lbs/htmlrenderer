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

package htmlrenderer.html.css
{

	import htmlrenderer.util.HTMLUtils;
	import htmlrenderer.util.TypeUtils;

	public class CSSUtil
	{

		public static const getDelemitedNumbers : RegExp = /-?\d+(\.\d+)?/g;

		//number = /^-?[0-9]*\.?[0-9]+$/
		/**
		 * Test for the following color patterns
		 * rgba(153,248,204,0.65098)
		 * rgb(68, 199, 239)
		 * argb(3233, 432423, 32.343, 4323)
		 *
		 */
		public static const isRGBandA : RegExp = /^a?(?:rgb|hsl)a?/;

		public static var urlPattern : RegExp = /((?<=\")[^\"]*(?=\"))/;

		protected static const COMPRESS_CSS : RegExp = /\s*([@{}:;,]|\)\s|\s\()\s*|\/\*([^*\\\\]|\*(?!\/))+\*\/|[\n\r\t]/g;

		/**
		 * <p>Returns given lowercaseandunderscoreword as a camelCased word.</p>
		 *
		 * @param string lowercaseandunderscoreword Word to camelize
		 * @return string Camelized word. likeThis.
		 */
		public static function camelize( lowercaseandunderscoreword : String, deimiter : String = "-" ) : String
		{
			var tarray : Array = lowercaseandunderscoreword.split( deimiter );

			for ( var i : int = 1; i < tarray.length; i++ )
			{
				tarray[ i ] = ucfirst( tarray[ i ] as String );
			}
			var replace : String = tarray.join( "" );
			return replace;
		}

		public static function cleanBackground( styleObject : Object ) : Object
		{

			var _background : Object = { type: "none", alpha: 1 };

			var propList : Array = CSSProperties.getBackgroundProps();
			var value : String;

			for each ( var prop : String in propList )
			{
				if ( styleObject.hasOwnProperty( prop ))
				{
					value = styleObject[ prop ];

					if ( prop == CSSProperties.BACKGROUND_COLOR )
					{
						_background.color = HTMLUtils.convertCSS_RGBColor( value ); //TypeUtils.cleanString( value );

					}
					else if ( prop == CSSProperties.BACKGROUND_SIZE )
					{
						var pos : Array = value.split( " " )
						_background.width = parseFloat( pos[ 0 ]);
						_background.height = parseFloat( pos[ 1 ]);
					}
					else if ( prop == CSSProperties.BACKGROUND_POSITION )
					{
						var position : Array = value.split( " " )
						_background.x = ( position[ 0 ]);
						_background.y = ( position[ 1 ]);
					}
					else if ( prop == CSSProperties.BACKGROUND_REPEAT )
					{
						_background.repeat = !( value.indexOf( "no-repeat" ) > -1 );
					}
					else if ( prop == CSSProperties.BACKGROUND_SIZE )
					{
						_background.scaleX = parseFloat( value );
						_background.scaleY = parseFloat( value );
					}
					else if ( prop == CSSProperties.BACKGROUND_IMAGE )
					{
						if ( value.indexOf( "gradient(" ) > -1 )
						{
							_background.gradient = gradient( value );
						}
						else if ( value.indexOf( "url(" ) > -1 )
						{
							_background.url = value.match( urlPattern )[ 0 ];
								//substr( value.indexOf( "url(" ) + 4, value.lastIndexOf( ")" ) - 1 ).split( '"' ).join( "" ).split( ")" ).join( "" );
						}
						else
						{
							_background.url = value;
						}
					}
				}
			}

			return _background;
		}

		public static function cleanBorder( styleObject : Object ) : Object
		{
			var _border : Object = { shape: "box", left: 0, right: 0, top: 0, bottom: 0 };

			var propList : Array = CSSProperties.getBorderProps();
			var value : String;

			for each ( var prop : String in propList )
			{
				if ( styleObject.hasOwnProperty( prop ))
				{
					value = styleObject[ prop ];

					if ( prop == CSSProperties.BORDER )
					{
						var parts : Array = value.split( " " );
						_border.weight = parseFloat( parts[ 0 ]);
						_border.type = parts[ 1 ] || "solid";

						var rgbArray : Array = parts[ 2 ].match( getDelemitedNumbers );
						_border.color = HTMLUtils.convertRGB( rgbArray[ 0 ], rgbArray[ 1 ], rgbArray[ 2 ]);

						if ( rgbArray[ 3 ])
						{
							_border.alpha = parseFloat( rgbArray[ 3 ]);
						}
					}
					else if ( prop == CSSProperties.BORDER_TOP_LEFT_RADIUS )
					{
						_border.shape = "RoundRectComplex";
						_border.topLeftRadius = parseFloat( value );
					}
					else if ( prop == CSSProperties.BORDER_TOP_RIGHT_RADIUS )
					{
						_border.shape = "RoundRectComplex";
						_border.topRightRadius = parseFloat( value );
					}
					else if ( prop == CSSProperties.BORDER_BOTTOM_LEFT_RADIUS )
					{
						_border.shape = "RoundRectComplex";
						_border.bottomLeftRadius = parseFloat( value );
					}
					else if ( prop == CSSProperties.BORDER_BOTTOM_RIGHT_RADIUS )
					{
						_border.shape = "RoundRectComplex";
						_border.bottomRightRadius = parseFloat( value );
					}
					else
					{
						_border[ prop ] = value;
					}
				}
			}
			return _border;
		}

		public static function cleanFont( styleObject : Object ) : Object
		{
			var _font : Object = new Object();
			//_font[ prop ] = value;
			return _font;
		}

		public static function cleanMargin( styleObject : Object ) : Object
		{

			var _margin : Object = { left: 0, right: 0, top: 0, bottom: 0 };

			var propList : Array = CSSProperties.getMarginProps();
			var value : String;

			for each ( var prop : String in propList )
			{
				if ( styleObject.hasOwnProperty( prop ))
				{
					value = styleObject[ prop ];

					if ( prop == "margin" )
					{
						var p : Array = value.split( " " );

						if ( p.length == 1 )
						{
							_margin.top = _margin.right = _margin.bottom = _margin.left = TypeUtils.cleanString( value );
						}
						else if ( p.length == 2 )
						{
							_margin.top = _margin.bottom = TypeUtils.cleanString( p[ 0 ]);
							_margin.right = _margin.left = TypeUtils.cleanString( p[ 1 ]);
						}
						else
						{
							_margin.top = TypeUtils.cleanString( p[ 0 ]);
							_margin.right = TypeUtils.cleanString( p[ 1 ]);
							_margin.bottom = TypeUtils.cleanString( p[ 2 ]);
							_margin.left = TypeUtils.cleanString( p[ 3 ]);
						}
					}
					else if ( prop == "marginLeft" )
					{
						_margin.left = TypeUtils.cleanString( value );
					}
					else if ( prop == "marginRight" )
					{
						_margin.right = TypeUtils.cleanString( value );
					}
					else if ( prop == "marginTop" )
					{
						_margin.top = TypeUtils.cleanString( value );
					}
					else if ( prop == "marginBottom" )
					{
						_margin.bottom = TypeUtils.cleanString( value );
					}

				}
			}
			return _margin;
		}

		public static function cleanPadding( styleObject : Object ) : Object
		{

			var _padding : Object = { left: 0, right: 0, top: 0, bottom: 0 };

			var propList : Array = CSSProperties.getPaddingProps();
			var value : String;

			for each ( var prop : String in propList )
			{
				if ( styleObject.hasOwnProperty( prop ))
				{
					value = styleObject[ prop ];

					if ( prop == CSSProperties.PADDING )
					{
						var p : Array = value.split( " " );

						if ( p.length == 1 )
						{
							_padding.top = _padding.right = _padding.bottom = _padding.left = TypeUtils.cleanString( value );
						}
						else
						{
							_padding.top = parseFloat( p[ 0 ]);
							_padding.right = parseFloat( p[ 1 ]);
							_padding.bottom = parseFloat( p[ 2 ]);
							_padding.left = parseFloat( p[ 3 ]);
						}
					}
					else if ( prop == "paddingLeft" )
						_padding.left = TypeUtils.cleanString( value );
					else if ( prop == "paddingRight" )
						_padding.right = TypeUtils.cleanString( value );
					else if ( prop == "paddingTop" )
						_padding.top = TypeUtils.cleanString( value );
					else if ( prop == "paddingBottom" )
						_padding.bottom = TypeUtils.cleanString( value );

				}
			}
			return _padding;
		}

		public static function gradient( value : String ) : Object
		{
			var result : Object = {};

			var directionPattern : RegExp = /(\-?[0-9]{1,3}deg)/g;

			result.direction = parseFloat( value.match( directionPattern )[ 0 ]);

			var colorParser : RegExp = /(((?:rgb)a?\(\d{1,3},\s?\d{1,3},\s?\d{1,3}(?:,\s?[0-9\.]+)?\)|[a-z]+)(?:\s*\d{1,3}(?:%|px)))/g;

			var colors : Array = value.match( colorParser );

			var colorStopPattern : RegExp = /((?:rgb)a?\(\d{1,3},\s?\d{1,3},\s?\d{1,3}(?:,\s?[0-9\.]+)?\)|[a-z]+)|((?:\d{1,3})?(%|px))(?<=[^\s])/g;

			result.colors = new Array();
			result.alphas = new Array();
			result.stops = new Array();

			var colorData : Array;
			var n : Array;
			var color : uint;
			var alpha : Number;

			for each ( var colorString : String in colors )
			{
				colorData = colorString.match( colorStopPattern );

				n = colorData[ 0 ].match( getDelemitedNumbers );

				color = HTMLUtils.convertRGB( n[ 0 ], n[ 1 ], n[ 2 ]);

				alpha = ( n[ 3 ] != null ) ? n[ 3 ] : 1;

				result.colors.push( color );
				result.alphas.push( alpha );
				result.stops.push( parseInt( colorData[ 1 ]) * .01 * 255 );

			}

			return result;
		}

		/**
		 * <p>This uses regex to remove spaces, breaks, "px" and other items
		 * that the F*CSS's parser doesn't know how to handle and returns a clean
		 * string.</p>
		 *
		 * @param cssText
		 * @return
		 */
		public static function tidy( cssText : String ) : String
		{
			return cssText.replace( COMPRESS_CSS, "$1" );
		}

		/**
		 * <p>Make first character of word upper case</p>
		 * @param    word
		 * @return string
		 */
		public static function ucfirst( word : String ) : String
		{
			return word.substr( 0, 1 ).toUpperCase() + word.substr( 1 );
		}

		public function CSSUtil()
		{
		}
	}
}
