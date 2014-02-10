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

package htmlrenderer.html.position
{

	import flash.geom.Rectangle;

	import htmlrenderer.html.ElementBase;
	import htmlrenderer.util.ElementUtil;
	import htmlrenderer.util.TypeUtils;

	public class Static2PositionLink extends PositionBaseLink
	{
		public function Static2PositionLink( successor : PositionBaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest( parentElement : ElementBase ) : Boolean
		{
			if ( true )
			{
				var parentStyle : Object;
				var parentWidth : Number;
				var parentHeight : Number;
				var parentPadding : Object

				//trace( "parent element name", parentElement.name );

				if ( parentElement is ElementBase )
				{
					parentStyle = parentElement.computedStyles;
					parentWidth = parentStyle.width;
					parentHeight = parentStyle.height;
					parentPadding = parentStyle.padding || { top: 0, right: 0, bottom: 0, left: 0 };
				}
				else
				{
					return false;
				}

				var center : Number = ( parentWidth - parentPadding.left - parentPadding.right ) / 2;
				var middle : Number = ( parentHeight - parentPadding.top - parentPadding.bottom ) / 2;

				ElementUtil.sortElementDepth( parentElement )

				var childrenElements : Vector.<ElementBase> = parentElement.childrenElements;

				var lastFloatIndex : Number;
				var lastFloatElement : ElementBase;
				var lastFloatRect : Rectangle;

				// need
				var clearRight : Boolean;
				var clearLeft : Boolean;

				for ( var count : int; count < childrenElements.length; ++count )
				{
					var element : ElementBase = childrenElements[ count ];

					var style : Object = element.computedStyles;

					var x : Number = style.left;
					var y : Number = style.top;
					var width : Number = style.width;
					var height : Number = style.height;

					// display:none;
					if ( style.display == "none" )
					{
						style.width = 0;
						style.height = 0;
						element.visible = false;
					}

					if ( style.display == "inline" || style.display == "inline-block" )
					{
						//
						// lets wait to do this
						// i dont think a static layout can have an inline.  
						// thing dont wrap in static
					}
					else
					{
						if ( style.float == "right" )
						{
							lastFloatElement = findLastElementOfFloat( element, childrenElements );

							if ( !lastFloatElement || style.clear == "both" ||style.clear == "right")
							{
								style.left = parentElement.computedStyles.width - parentElement.computedStyles.padding.right - TypeUtils.cleanNumber( style.width, parentWidth ) - TypeUtils.cleanNumber( style.margin.right, parentWidth );
							}
							else
							{
								lastFloatRect = lastFloatElement.elementRect;
								style.left = lastFloatRect.left - TypeUtils.cleanNumber( style.width, parentWidth ) - TypeUtils.cleanNumber( style.margin.right, parentWidth ); // + n.base.x
							}
						
							style.top = calculateFloatRightTop( element, style, childrenElements );
						}
						else if ( style.float == "left" )
						{
							// lefts dont but against none
							// lowest div that is less then this

							lastFloatElement = findLastElementOfFloat( element, childrenElements );

							if ( !lastFloatElement || style.clear == "both" ||style.clear == "left")
							{
								style.left = parentElement.computedStyles.padding.left + TypeUtils.cleanNumber( style.margin.left, parentWidth );
							}
							else
							{
								lastFloatRect = lastFloatElement.elementRect;
								style.left = lastFloatRect.right + TypeUtils.cleanNumber( style.margin.left, parentWidth ); // + n.base.x
							}

							style.top = calculateFloatLeftTop( element, style, childrenElements );

						}
						else if ( style.float == "none" )
						{
							// float none left always wall

							// always take the previous float none div as top

							if ( style.margin.left == "auto" || style.margin.right == "auto" )
							{
								style.left = center - style.width / 2;
							}
							else
							{
								style.left = parentElement.computedStyles.padding.left + TypeUtils.cleanNumber( style.margin.left, parentWidth );
							}

							if ( style.margin.top == "auto" || style.margin.bottom == "auto" )
							{
								style.top = middle - style.height / 2;
							}
							else
							{
								style.top = calculateFloatNoneTop( element, style, childrenElements );
							}

						}
					}

					element.placeRect();
				}
			}

			return super.handleRequest( parentElement );
		}
		
		private function calculateFloatRightTop( element : ElementBase, style : Object, childrenElements : Vector.<ElementBase> ) : Number
		{
			var top : Number = element.parentElement.computedStyles.padding.top + style.margin.top;
			
			var lowestElement : ElementBase = findLowestElementOfFloat( element, childrenElements, "left" );
			
			if ( !lowestElement )
			{
				return top;
			}
			
			top = lowestElement.elementRect.bottom + TypeUtils.cleanNumber( style.margin.top, 0 );
			
			return top;
		}
		private function calculateFloatLeftTop( element : ElementBase, style : Object, childrenElements : Vector.<ElementBase> ) : Number
		{
			var top : Number = element.parentElement.computedStyles.padding.top + style.margin.top;
			
			var lowestElement : ElementBase = findLowestElementOfFloat( element, childrenElements );
			
			if ( !lowestElement )
			{
				return top;
			}
			
			top = lowestElement.elementRect.bottom + TypeUtils.cleanNumber( style.margin.top, 0 );
			
			return top;
		}

		
		private function calculateFloatNoneTop( element : ElementBase, style : Object, childrenElements : Vector.<ElementBase> ) : Number
		{
			var lowestElement : ElementBase = findLastElementOfFloat( element, childrenElements );

			var top : Number = element.parentElement.computedStyles.padding.top + style.margin.top;

			if ( !lowestElement )
			{
				return top;
			}

			top = lowestElement.elementRect.bottom + TypeUtils.cleanNumber( style.margin.top, 0 );

			return top;
		}

		private function findLastElementOfFloat( targetElement : ElementBase, childrenElements : Vector.<ElementBase> ) : ElementBase
		{
			var currentElement : ElementBase;

			var length : int = childrenElements.indexOf( targetElement ) - 1;

			while ( length >= 0 )
			{
				currentElement = childrenElements[ length ];

				if (( currentElement.computedStyles.float == targetElement.computedStyles.float ) && currentElement != targetElement )
				{
					return currentElement;
				}
				--length;
			}

			return null;
		}
		
		private function findLowestElementOfFloat( targetElement : ElementBase, childrenElements : Vector.<ElementBase>, exludeFloat : String = "right" ) : ElementBase
		{
			
			var currentElement : ElementBase;
			
			var element : ElementBase;
			
			var bottom : Number = 0;
			
			var clearAllOnce : Boolean = false;
			
			
			var length : int = childrenElements.indexOf( targetElement );
			
			while ( length >= 0 )
			{
				currentElement = childrenElements[ length ];
				
				// grabs first float none itemd
				if ( clearAllOnce == false && currentElement.computedStyles.float == "none" )
				{
					// you have a fount a float none that is in the same row.  exit and send back
					if ( !clearAllOnce )
						return element;
				}

				// start to grab after clear both or page return
				if (( clearAllOnce == false && ( currentElement.computedStyles.clear == "both"  ) ) || ( clearAllOnce == false && length == 0 ))
				{
					clearAllOnce = true
					
					element = null;
					bottom = 0;
				}
				else if ( currentElement.elementRect.bottom > bottom  && currentElement.computedStyles.float != exludeFloat && currentElement != element )
				{
					element = currentElement;
					bottom = currentElement.elementRect.bottom;
				}
				--length;
			}
			
			return element;
		}
	}
}
