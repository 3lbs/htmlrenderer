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

	import htmlrenderer.html.Node;
	import htmlrenderer.parser.ParseTreeNode;

	public class DivLink extends BaseLink
	{
		protected var ID : String = "div";

		public function DivLink( successor : BaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest(  request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{
			if ( request == ID )
			{
				
				var element : Node = createElement( treeNode.document, treeNode.element, node, BaseLink.INLINE );

				if ( element.rawStyle.display == null )
					element.rawStyle.display = BaseLink.INLINE;

				var token : ParseTreeNode = new ParseTreeNode( treeNode.document, element, node  );
				return token;
			}

			return super.handleRequest( request, treeNode, node );

		}
	}
}
