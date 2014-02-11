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

	public class BodyLink extends BaseLink
	{
		public function BodyLink( successor : BaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest( request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{

			if ( request == "body" )
			{
				var element : Node = createElement( treeNode.document, treeNode.element, node, BLOCK );
				element.rawStyle.width = element.rawStyle.height = "100%";
				element.rawStyle.background.alpha = 0;

				var headNode : ParseTreeNode = treeNode.getNodeByID( HeadLink.HEAD_ID );
				
				var token : ParseTreeNode = new ParseTreeNode( treeNode.document, element, node  );
				token.requires( headNode );

				return token;

			}
			return super.handleRequest( request, treeNode, node );
		}
	}
}
