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

package htmlrenderer.parser
{

	import flash.events.Event;

	import htmlrenderer.html.Document;
	import htmlrenderer.html.ElementBase;
	import htmlrenderer.html.Window;
	import htmlrenderer.html.css.StylesBase;

	public class CSSLoadTreeNode extends ParseLoadTreeNode
	{
		public var attribute : Array = [ "backgroundImage", "src", "data" ];

		public function CSSLoadTreeNode( document : Document = null, element : ElementBase = null, node : XML = null )
		{
			super( document, element, node );
		}

		override protected function finished( event : Event = null ) : void
		{
			var styles : String = "";

			var _window : Window = document.window;
			var text : String;

			reset();

			while ( hasNext())
			{
				if ( styles == null )
				{
					document = _window.document;
				}

				text = next().data;
				styles += text;
			}

			var _cssStle : StylesBase = _window.css.parseCSS( styles );

			super.finished( event );
		}
	}
}
