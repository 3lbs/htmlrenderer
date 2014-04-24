package htmlrenderer.html.css
{
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	
	/**
	 *  StylesBase is just an extenstion of StyleSheet, it transforms any needed html elements into the actionscript equivalents
	 *	and saves the cleaned, processed and raw versions of itself.
	 */
	public class StylesBase extends StyleSheet
	{
		
		private static function hashSuffixOf( styleName : String ) : String
		{
			
			if ( styleName.lastIndexOf( CSS.SEPARATOR + ":" ) != -1 )
				styleName = styleName.substr( 0, styleName.lastIndexOf( CSS.SEPARATOR + ":" ));
			
			if ( styleName.lastIndexOf( ":" ) != -1 )
				styleName = styleName.substr( 0, styleName.lastIndexOf( ":" ));
			
			styleName = styleName.substr( styleName.lastIndexOf( CSS.SEPARATOR ) + 1 );
			
			var lastPound : int = styleName.lastIndexOf( "#" );
			var lastDot : int = styleName.lastIndexOf( "." );
			
			if ( lastPound > -1 && lastPound > lastDot )
				styleName = styleName.substr( lastPound );
			else if ( lastDot > -1 && lastDot > lastPound )
				styleName = styleName.substr( lastDot );
			
			return styleName;
		}
		
		public var tailSortedStyles : Object = {};
		
		override public function clear() : void
		{
			super.clear();
			
			for ( var index : String in tailSortedStyles )
			{
				tailSortedStyles[ index ] = undefined;
			}
		}
		
		/**
		 *	This method is overridden so that we can append new styles to the tailIndexedStyle object.
		 *	@inheritDoc
		 */
		override public function parseCSS( cssText : String ) : void
		{
			
			super.parseCSS( cssText );
			
			var tempSheet : StyleSheet = new StyleSheet();
			
			// if (TAIL_SEARCH_ENABLED ) { //  && cssText.indexOf("inline{")
			// grab the style names from cssText
			tempSheet.parseCSS( cssText );
			var names : Array = tempSheet.styleNames;
			var styleName : String, suffix : String;
			
			for ( var i : int = 0; i < names.length; i++ )
			{
				
				styleName = names[ i ];
				
				// add each new style to the tail-sorted style list
				
				suffix = hashSuffixOf( styleName );
				
				if ( tailSortedStyles[ suffix ] == null )
				{
					tailSortedStyles[ suffix ] = [ styleName ];
				}
				else if ( tailSortedStyles[ suffix ].indexOf( styleName ) == -1 )
				{
					tailSortedStyles[ suffix ].push( styleName );
				}
			}
			
			// wipe clean the temp style sheet
			tempSheet.clear();
			tempSheet = null;
		}
		
		override public function setStyle( styleName : String, styleObject : Object ) : void
		{
			super.setStyle( styleName, styleObject );
			
			var suffix : String = hashSuffixOf( styleName );
			
			if ( styleObject )
			{
				// add in the style name to the hash
				if ( tailSortedStyles[ suffix ] == null )
				{
					tailSortedStyles[ suffix ] = [ styleName ];
				}
				else if ( tailSortedStyles[ suffix ].indexOf( styleName ) == -1 )
				{
					tailSortedStyles[ suffix ].push( styleName );
				}
			}
			else if ( tailSortedStyles[ suffix ] != null )
			{ 
				// remove the style name from the hash
				if ( tailSortedStyles[ suffix ].length == 1 )
				{
					tailSortedStyles[ suffix ].pop();
					tailSortedStyles[ suffix ] = null;
				}
				else
				{
					var index2 : int = tailSortedStyles[ suffix ].indexOf( styleName );
					
					if ( index2 > -1 )
					{
						tailSortedStyles[ suffix ].splice( index2, 1 );
					}
				}
			}
		}
		
		/**
		 *	This method is overridden so that we can extend css's functionality
		 *	@inheritDoc
		 */
		override public function transform( s : Object ) : TextFormat
		{
			var f : TextFormat = super.transform( s );
			
			for ( var p : String in s )
			{
				switch ( p )
				{
					case "lineHeight":
						f.leading = parseFloat( s[ p ]);
						break;
					case "blockIndent":
						f.blockIndent = parseFloat( s[ p ]);
						break;
					case "indent":
						f.indent = parseFloat( s[ p ]);
						break;
					case "leftMargin":
						f.leftMargin = parseFloat( s[ p ]);
						break;
					case "rightMargin":
						f.rightMargin = parseFloat( s[ p ]);
						break;
					case "tabStops": // tab-stops: 0,15,30,45;
						f.tabStops = String( s[ p ]).split( "," );
						break;
					case "bullet":
						f.bullet = ( s[ p ] == "true" );
						break;
					case "letterSpacing":
						f.letterSpacing = parseFloat( s[ p ]);
						break;
					case "target":
						f.target = s[ p ];
						break;
					case "url":
						f.url = s[ p ];
						break;
				}
			}
			return f;
		}
	}
}