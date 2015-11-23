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

	import htmlrenderer.html.ElementBase;
	import htmlrenderer.html.Node;

	public class CSS
	{

		public static const SEPARATOR : String = "|";

		protected static const CSS_BLOCKS : RegExp = /[^{]*\{([^}]*)*}/g;

		protected static const CSS_MEDIA_BLOCKS : RegExp = /@media[^\{]+\{([^\{\}]+\{[^\}\{]+\})+/g;

		protected static const CSS_VAR_PATTERN : RegExp = /var\(([\w'-]+)\)/g;

		protected static const FIND_A_HREF_CLASS : RegExp = /a\.([^\:]+)/gi;

		// object constants
		private static const INHERITED_STYLES : Array = [ "alignContent", "color", "cursor", "direction", "fontFamily", "fontSize", "fontStyle", "fontVariant", "fontWeight", "font", "letter", "spacing",
			"lineHeight", "listStyleImage", "listStylePosition", "listStyleType", "listStyle", "textAlign", "textIndent", "textTransform", "visibility", "whiteSpace", "wordSpacing" ];

		private const CLASS : String = "class";

		// string constantsad
		private const DEFAULT : String = "default";

		private const DEFAULT_CSS : String = "div{display:block;width:100%;height:0}body{display:block;width:100%;height:100%;}";

		private var _styleSheet : StylesBase;

		private var mediaStyles : MediaStyles;

		private var windowSize : Number;

		public function CSS( windowSize : Number )
		{
			super();

			this.windowSize = windowSize;
			_styleSheet = new StylesBase();
		}

		public function duplicateStyle( style : Object ) : Object
		{ // duplicate style to save clean values. This loop only goes two layers deep ( might be important later but fine now )
			var clean : Object = new Object();

			for ( var prop : String in style )
			{
				if ( typeof( style[ prop ]) == "object" )
				{
					if ( style[ prop ] is Array )
					{
						clean[ prop ] = style[ prop ];
					}
					else
					{
						clean[ prop ] = new Object();

						for ( var objProp : String in style[ prop ])
						{
							clean[ prop ][ objProp ] = style[ prop ][ objProp ];
						}
					}
				}
				else
				{
					clean[ prop ] = style[ prop ];
				}
			}
			return clean;
		}

		public function getElementStyles( node : XML, parent : Node = null, width : int = 0 ) : Object
		{
			var size : int = width || windowSize;

			var parentStyle : Object = {};
			var prop : String;
			var states : Object;
			var classArray : Array = [];
			var matchingStyles : Array = [];
			var currentParentWithinLoop : Node = parent;
			var currentParentDepth : int = 0;
			var candidates : Array = [];
			var lastClass : String
			var tailCandidates : Array;
			var scrap : String = node.@[ CLASS ].toString();
			var tag : String = node.localName();

			// Not all properties are inherited.
			if ( parent )
			{
				for ( prop in parent.rawStyle )
				{
					var saveProp : Boolean = false;

					if ( INHERITED_STYLES.indexOf( prop ) > -1 )
					{
						parentStyle[ prop ] = parent.rawStyle[ prop ];
					}
				}
			}

			states = { "default": parentStyle };

			if ( scrap.length )
			{
				classArray = scrap.split( " " );
				tailCandidates = scrap.split( " " );
				tailCandidates.unshift( "" );
				tailCandidates = tailCandidates.join( " ." ).split( " " );
				tailCandidates.shift();
				tailCandidates.reverse();
			}
			else
			{
				tailCandidates = [];
			}

			// this is for class?
			for ( var i : int = 0; i < tailCandidates.length; i++ )
			{
				lastClass = String( tailCandidates[ i ]).toLowerCase();

				if ( _styleSheet.tailSortedStyles[ lastClass ])
				{
					candidates.push.apply( null, _styleSheet.tailSortedStyles[ lastClass ]);
				}
			}

			scrap = node.@id.toString();

			// is this an ID
			if ( scrap.length )
			{
				var id : String = "#" + scrap;

				if ( _styleSheet.tailSortedStyles[ id ])
				{

					// is this where u add it ?
					candidates.push.apply( null, _styleSheet.tailSortedStyles[ id ]);
				}
			}

			if ( _styleSheet.tailSortedStyles[ tag ])
			{
				candidates.push.apply( null, _styleSheet.tailSortedStyles[ tag ]);
			}

			// this matches styles in the stylesheet to the node xml
			//styleLoop : for each( var styleName:String in _styleSheetstyleNames ) {
			styleLoop: for each ( var styleName : String in candidates )
			{

				var styleNameArray : Array = styleName.split( SEPARATOR );
				var styleMatch : Boolean = false;
				var score : int = 0;
				var currentNode : XML = node;
				var currentParentElement : ElementBase = parent;
				var hasState : Boolean = false;
				var matchingSections : int = 0;
				var firstNodeMatch : Boolean = false;

				styleSectionLoop: for ( i = styleNameArray.length - 1; i >= 0; i-- )
				{

					var sectionMatch : Boolean = false;
					var styleNameSection : String = styleNameArray[ i ];

					if ( styleNameSection.charAt( 0 ) == ":" && i == styleNameArray.length - 1 )
					{

						hasState = true;
						matchingSections++
						continue;
					}
					else
					{
						if (( hasState && i == styleNameArray.length - 2 ) || i == styleNameArray.length - 1 )
						{

							var isMatch : Object = nodeHasStyles( currentParentElement, styleNameSection, currentNode, foundMatch, breakNoMatch );

							currentParentWithinLoop = isMatch.parentElement
							currentParentDepth = isMatch.parentDepth

							if ( isMatch.matching )
							{
								var styleNameSectionArray : Array = styleNameSection.split( "." ).join( " ." ).split( "#" ).join( " #" ).split( " " );
								var lastStylePart : String = styleNameSectionArray[ styleNameSectionArray.length - 1 ];
								var bonusPoints : uint = styleName.split( " " ).join( "." ).split( "#" ).join( "." ).split( "." ).length;

								if ( lastStylePart.charAt( 0 ) == "#" )
								{
									score += 3 + bonusPoints;
								}
								else if ( lastStylePart.charAt( 0 ) == "." )
								{
									score += 2 + bonusPoints;
								}
								else
								{ // node style
									score += 1 + bonusPoints;
								}
								matchingSections++
								sectionMatch = true;
								firstNodeMatch = true;
							}
							else
							{
								if ( currentParentWithinLoop && !( currentParentWithinLoop.parent is ElementBase ))
									break styleSectionLoop;
							}
						}
					}

					if ( firstNodeMatch )
					{
						if ( score != 0 && matchingSections == styleNameArray.length )
						{
							styleMatch = true
							matchingStyles.push({ score: score, styleName: styleName })
							break styleSectionLoop
						}
						else if ( currentParentWithinLoop && currentParentWithinLoop.parent && currentParentElement && currentParentElement.parent is ElementBase )
						{
							if ( sectionMatch == true )
							{
								matchingSections++
								continue
							}
							else
							{

								var doesParentsHaveThisStyle : Object = nodeHasStyles( currentParentWithinLoop, styleNameSection, currentParentWithinLoop.nodeXML, foundMatch, loopThroughParentsForMatch );
								currentParentElement = currentParentWithinLoop.parent as ElementBase;
								currentNode = currentParentWithinLoop.nodeXML;

								if ( doesParentsHaveThisStyle.matching )
								{
									if ( i == 0 )
									{
										matchingStyles.push({ score: score, styleName: styleName })
									}
									else
									{
										matchingSections++
										continue
									}
								}
								else
								{ // not a match
									break styleSectionLoop
								}
							}
						}
						else
						{ // not a match
							break styleSectionLoop
						}
					}
				}
			}

			// sort matched styles by there score
			var sorted : Array = matchingStyles.sortOn( "score" ) //Array.DESCENDING

			// add inline styles to stylesheet after cleaning them
			if ( node.@style.toString())
			{
				_styleSheet.setStyle( "inline", cleanCSS( node.@style ))
				sorted.push({ depth: 1, score: 100, styleName: "inline" })
			}

			// condense into one style and apply as default style
			for each ( var defaultItems : Object in sorted )
			{
				var defaultStateName : Array = defaultItems.styleName.split( ":" ).join( SEPARATOR + ":" ).split( ":" );

				if ( defaultStateName.length < 2 )
				{

					// here is where u need to get the differnt style for file size
					var defaultObj : Object = getStyle( defaultItems.styleName ); //_styleSheet.getStyle( defaultItems.styleName )

					cleanStyle( defaultObj );

					for ( var defaultProps : String in defaultObj )
					{
						if ( typeof( defaultObj[ defaultProps ]) == "object" )
						{
							if ( states[ DEFAULT ][ defaultProps ] == null )
							{
								states[ DEFAULT ][ defaultProps ] = {};
							}

							for ( var objOrgProp : String in defaultObj[ defaultProps ])
							{
								states[ DEFAULT ][ defaultProps ][ objOrgProp ] = defaultObj[ defaultProps ][ objOrgProp ];
							}
						}
						else
						{ //  if( defaultObj[ defaultProps ] is String && defaultObj[ defaultProps ] != "[object Object]" )
							if ( defaultObj[ defaultProps ] is String )
								states[ DEFAULT ][ defaultProps ] = defaultObj[ defaultProps ].split(( SEPARATOR + "#" )).join( "#" ).split(( SEPARATOR + "." )).join( "." );
							else
								states[ DEFAULT ][ defaultProps ] = defaultObj[ defaultProps ];
						}
					}
				}
				else
				{
					// create other states
					states[ defaultStateName[ 1 ]] = {}
				}
			}

			// default styles
			var objs : Object = { left: 0, top: 0, width: "100%", height: 0, position: "auto", background: { type: "none", alpha: 1 }, border: { type: "none", shape: "box", left: 0, right: 0, top: 0, bottom: 0 },
					margin: { left: 0, right: 0, top: 0, bottom: 0 }, padding: { left: 0, right: 0, top: 0, bottom: 0 }};

			for ( prop in objs )
			{
				if ( states[ DEFAULT ][ prop ] == null )
				{
					states[ DEFAULT ][ prop ] = objs[ prop ];
					continue;
				}

				if ( typeof( objs[ prop ]) == "object" )
				{
					for ( var baseObjProp : String in objs[ prop ])
					{
						if ( !states[ DEFAULT ][ prop ])
						{
							states[ DEFAULT ][ prop ] = objs[ prop ];
							continue;
						}

						if ( !states[ DEFAULT ][ prop ][ baseObjProp ])
							states[ DEFAULT ][ prop ][ baseObjProp ] = objs[ prop ][ baseObjProp ];
					}
				}
			}

			for each ( var sortedItems1 : Object in sorted )
			{
				var orgStateName1 : Array = sortedItems1.styleName.split( SEPARATOR + ":" ).join( ":" ).split( ":" );

				if ( orgStateName1[ 1 ])
					states[ orgStateName1[ 1 ]] = duplicateStyle( states[ DEFAULT ]);
			}

			// Create other states objects based on defaults
			for each ( var sortedItems : Object in sorted )
			{
				var orgStateName : Array = sortedItems.styleName.split( SEPARATOR + ":" ).join( ":" ).split( ":" );

				if ( orgStateName.length > 1 )
				{
					var baseObj : Object = _styleSheet.getStyle( sortedItems.styleName )

					for ( var sortedProp : String in baseObj )
					{
						if ( typeof( baseObj[ sortedProp ]) == "object" )
						{
							if ( !states[ orgStateName[ 1 ]][ sortedProp ])
							{
								states[ orgStateName[ 1 ]][ sortedProp ] = {};
							}

							for ( var objProp : String in baseObj[ sortedProp ])
							{
								states[ orgStateName[ 1 ]][ sortedProp ][ objProp ] = baseObj[ sortedProp ][ objProp ];
							}
						}
						else
						{
							states[ orgStateName[ 1 ]][ sortedProp ] = baseObj[ sortedProp ].split( SEPARATOR + "#" ).join( "#" ).split( SEPARATOR + "." ).join( "." )
						}
					}
				}
			}

			return { style: states, appliedStyles: sorted };
		}

		public function getStyle( styleName : String ) : Object
		{
			var defaultStyleObject : Object = _styleSheet.getStyle( styleName );

			if ( defaultStyleObject && mediaStyles && mediaStyles.hasMediaBlock( styleName, windowSize ))
			{
				var styleBlock : Object = mediaStyles.getMediaStyle( styleName, windowSize );

				for ( var propName : String in styleBlock )
				{
					defaultStyleObject[ propName ] = styleBlock[ propName ];
				}
			}

			return defaultStyleObject;
		}

		public function parseCSS( css : String ) : StylesBase
		{
			css = CSSUtil.tidy( css );

			// extract media stylesheets

			// watch this because u get a @ sign ur doomed
			var cssPattern : RegExp = /[^@]*/g;

			var defaultCSS : String = css.match( cssPattern )[ 0 ];

			// get all media blocks
			var parsedMediaBlocks : Array = css.match( CSS_MEDIA_BLOCKS );

			var length : int = parsedMediaBlocks.length;

			if ( parsedMediaBlocks.length > 0 )
			{
				mediaStyles ||= new MediaStyles();

				//var sizePattern : RegExp = /\(max\-width:[\s]*([\s]*[0-9]+)px[\s]*\)/g;
				//var mediaPatten : RegExp = /@media\s*([^\{]+)\{([\S\s]+?)$/g;
				for ( var i : int = 0; i < length; ++i )
				{
					mediaStyles.parseMediaCSS( parsedMediaBlocks[ i ]);
				}
			}

			_styleSheet = new StylesBase();

			try
			{
				_styleSheet.parseCSS( DEFAULT_CSS + defaultCSS );
			}
			catch ( er : Error )
			{
				throw new Error( er.message, er.errorID );
			}
			return _styleSheet;
		}

		public function get styleSheet() : StylesBase
		{
			return _styleSheet;
		}

		private function breakNoMatch( parentElement : ElementBase, stylePart : String, parentDepth : int ) : Object
		{
			return { matching: false, parentElement: parentElement, parentDepth: parentDepth }
		}

		private function cleanCSS( style : String ) : Object
		{
			var css : CSS = new CSS( windowSize );
			css.parseCSS( "inline{" + style + "}" );
			return css.styleSheet.getStyle( "inline" );
		}

		private function cleanStyle( defaultObj : Object ) : void
		{
			defaultObj.border = CSSUtil.cleanBorder( defaultObj );
			
			var background : Object = CSSUtil.cleanBackground( defaultObj );
			
			if ( background != null )
			{
				defaultObj.background = background; 
			}
			
			var margin : Object = CSSUtil.cleanMargin( defaultObj );
			
			if ( margin != null )
			{
				defaultObj.margin = margin; 
			}
			
			defaultObj.font = CSSUtil.cleanFont( defaultObj );
			
			var padding : Object = CSSUtil.cleanPadding( defaultObj );
			if ( padding != null )
			{
				defaultObj.padding = padding;
			}
		}

		private function doNodesClassStylesMatch( styleNameSection : String, classes : String = null ) : Boolean
		{
			if ( classes )
			{
				for each ( var className : String in classes.split( " " ))
				{
					if ( styleNameSection == ( "." + className.toLowerCase()))
					{
						return true
					}
				}
			}
			return false
		}

		private function foundMatch( parentElement : ElementBase, stylePart : String, parentDepth : int ) : Object
		{
			return { matching: true, parentElement: parentElement, parentDepth: parentDepth }
		}

		private function loopThroughParentsForMatch( parentElement : Node, stylePart : String, parentDepth : int ) : Object
		{
			if ( parentElement.parent is ElementBase )
			{

				parentElement = parentElement.parent as Node;
				parentDepth++
				var result : Object = nodeHasStyles( parentElement, stylePart, parentElement.nodeXML, foundMatch, loopThroughParentsForMatch, parentDepth );
				return { matching: result.matching, parentElement: result.parentElement, parentDepth: result.parentDepth }
			}
			return { matching: false, parentElement: parentElement, parentDepth: parentDepth }
		}

		private function nodeHasStyles( parentElement : ElementBase, styleNameSection : String, node : XML, onMatch : Function, onNoMatch : Function, parentDepth : int = 0 ) : Object
		{
			var nodeId : String = node.@id.toString();
			var nodeClass : String = node.@[ CLASS ].toString();
			var nodeName : String = node.localName();

			var styleNameArray : Array = styleNameSection.split( "." ).join( " ." ).split( "#" ).join( " #" ).split( " " );

			var matchedParts : int = 0;
			var matchType : String = "none";

			if ( styleNameArray[ 0 ] == "" )
				styleNameArray.shift()

			for each ( var stylePart : String in styleNameArray )
			{

				if ( stylePart == ".primarycontainer" )
					trace( "break" );

				if ( stylePart != null && stylePart != "" )
				{
					if ( node.@id.toString() && stylePart.charAt( 0 ) == "#" && stylePart == "#" + nodeId )
					{
						matchType = "id";
						matchedParts++;
					}
					else if ( node.@[ "class" ].toString() && stylePart.charAt( 0 ) == "." && doNodesClassStylesMatch( stylePart, nodeClass ))
					{
						matchType = CLASS;
						matchedParts++;
					}
					else if ( stylePart == node.localName())
					{
						matchType = "node";
						matchedParts++;
					}
				}
			}

			if ( matchedParts > 0 && matchedParts >= styleNameArray.length )
			{
				return onMatch( parentElement, styleNameSection, parentDepth )
			}
			else
			{
				return onNoMatch( parentElement, styleNameSection, parentDepth )
			}

			return { matching: false, parentElement: parentElement, parentDepth: parentDepth }
		}
	}
}

