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

	public class StaticPositionLink extends PositionBaseLink
	{
		public function StaticPositionLink( successor : PositionBaseLink = null )
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

				trace( "parent element name", parentElement.name );

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

				trace(" start loop");
				for ( var count : int; count < childrenElements.length; ++count )
				{
					var element : ElementBase = childrenElements[ count ];

					var style : Object = element.computedStyles;

					var x : Number = style.left;
					var y : Number = style.top;
					var width : Number = style.width;
					var height : Number = style.height;

					trace("");
					trace( "-----------------------------------------");
					trace( "element name", element.name );

					// display:none;
					
					element.visible = true;
					
					if ( style.display == "none" )
					{
						style.width = 0;
						style.height = 0;
						//element.visible = false;
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
							// wait to do right
						}
						else if ( style.float == "left" )
						{
							// else we have to find the other elements that have relation to this one

							lastFloatElement = findLastElementOfFloat( element, childrenElements );

							trace( "lastFloatElement", lastFloatElement.name );
							if ( !lastFloatElement )
							{
								style.left = parentElement.computedStyles.padding.left + TypeUtils.cleanNumber( style.margin.left, parentWidth );
								style.top = calculateFloatLeftTop( element, style, childrenElements );
							}
							else
							{
								lastFloatRect = lastFloatElement.elementRect;

								if ( style.clear == "both" || lastFloatElement.computedStyles.float == "none" )
								{
									style.left = parentElement.computedStyles.padding.left + TypeUtils.cleanNumber( style.margin.left, parentWidth );
								}
								else
								{
									style.left = lastFloatRect.right + TypeUtils.cleanNumber( style.margin.left, parentWidth ); // + n.base.x
								}

								style.top = calculateFloatLeftTop( element, style, childrenElements );
							}
						}
						else if ( style.float == "none" )
						{
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

		private function calculateFloatLeftTop( element : ElementBase, style : Object, childrenElements : Vector.<ElementBase> ) : Number
		{
			var top : Number = element.parentElement.computedStyles.padding.top + style.margin.top;

			var lowestElement : ElementBase = findLowestElementOfFloatLeft( element, childrenElements );

			if ( !lowestElement )
			{
				return top;
			}

			if ( style.clear == "none" )
			{
				top = lowestElement.elementRect.bottom + TypeUtils.cleanNumber( style.margin.top, 0 );
			}
			else if ( style.clear == "both" )
			{
				top = lowestElement.elementRect.bottom + TypeUtils.cleanNumber( style.margin.top, 0 );
			}

			return top;
		}

		private function calculateFloatNoneTop( element : ElementBase, style : Object, childrenElements : Vector.<ElementBase> ) : Number
		{
			var top : Number = element.parentElement.computedStyles.padding.top + style.margin.top;
			var lowestElement : ElementBase = findLastElementOfFloat( element, childrenElements );
			
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

				if ( ( currentElement.computedStyles.float == targetElement.computedStyles.float || currentElement.computedStyles.float == "none" ) && currentElement != targetElement )
				{
					return currentElement;
				}
				--length;
			}

			return null;
		}

		private function findLowestElementOfFloatLeft( targetElement : ElementBase, childrenElements : Vector.<ElementBase>, catchFirst: Boolean = false ) : ElementBase
		{

			var currentElement : ElementBase;

			var element : ElementBase;

			var bottom : Number = 0;

			var clearAllOnce : Boolean = catchFirst;
			
			var clearedBoth : Boolean = false;

			var length : int = childrenElements.indexOf( targetElement );

			while ( length >= 0 )
			{
				currentElement = childrenElements[ length ];

				
				// grabs first float none item
				if ( clearAllOnce == false && clearedBoth == false && currentElement.elementRect.bottom > bottom  && currentElement.computedStyles.float == "none" )
				{
					element = currentElement;
					clearAllOnce = true;
					bottom = currentElement.elementRect.bottom;
					// if false then return first none,  if true we are trying to grab all the elements below
					if ( clearedBoth == false )
					{
						return element;
					}
				}
				
				// start to grab after clear both or page return
				if (( clearAllOnce == false && ( currentElement.computedStyles.clear == "both"  ) ) || ( clearAllOnce == false && length == 0 ))
				{
					clearAllOnce = true
						
					clearedBoth = true;
					element = null;
					bottom = 0;
				}
				else if ( currentElement.elementRect.bottom > bottom  && currentElement.computedStyles.float != "right" && currentElement != element )
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
