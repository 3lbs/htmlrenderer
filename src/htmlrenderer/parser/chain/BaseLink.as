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

package htmlrenderer.parser.chain
{

	import htmlrenderer.html.Document;
	import htmlrenderer.html.Element;
	import htmlrenderer.html.ElementBase;
	import htmlrenderer.parser.ParseTreeNode;

	public class BaseLink
	{

		public static const BLOCK : String = "block";

		public static const INLINE : String = "inline";

		public static const TABLE : String = "table";

		public static const TABLE_CELL : String = "table-cell";

		public static const TABLE_ROW : String = "table-row";

		public static function createElement( document : Document = null, target : ElementBase = null, xml : XML = null, display : String = null, elementType : Class = null ) : ElementBase
		{

			var style : Object = document.window.css.getElementStyles( xml, target as Element ).style;

			elementType ||= Element;

			var element : ElementBase = new elementType( document, target, xml, style );

			//var element : Element = Element.create( document, target as Element, xml, style );

			return element;
		}

		protected var successor : BaseLink;

		public function BaseLink( successor : BaseLink = null )
		{
			this.successor = successor;
		}

		public function destroy() : void
		{
			successor = null;
		}

		public function handleRequest( request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{
			if ( successor != null )
			{
				return successor.handleRequest( request, treeNode, node );
			}
			return null;
		}

		public function setSuccessor( successor : BaseLink ) : void
		{
			this.successor = successor;
		}
	}
}
