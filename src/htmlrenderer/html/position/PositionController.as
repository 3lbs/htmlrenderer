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

	public class PositionController
	{
		private var layoutPosition : PositionBaseLink;

		public function PositionController()
		{

			var autoPosition : AutoPositionLink = new AutoPositionLink();
			var staticPostion : Static2PositionLink = new Static2PositionLink( autoPosition );
			layoutPosition = staticPostion;
		}

		public function positionElement( parentElement : ElementBase ) : void
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
				return;
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

			trace( " start loop" );

			for ( var count : int; count < childrenElements.length; ++count )
			{
				var element : ElementBase = childrenElements[ count ];

				var style : Object = element.computedStyles;

				var x : Number = style.left;
				var y : Number = style.top;
				var width : Number = style.width;
				var height : Number = style.height;

				trace( "" );
				trace( "-----------------------------------------" );
				trace( "element name", element.name );

				// display:none;
				if ( style.display == "none" )
				{
					style.width = 0;
					style.height = 0;
					element.visible = false;
				}
				else
				{
					layoutPosition.handleRequest( element );
				}

				element.placeRect();

			}
		}
	}
}
