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

	import htmlrenderer.parser.ParseTreeNode;

	public class HtmlLink extends BaseLink
	{
		public function HtmlLink( successor : BaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest( request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{

			if ( request == "html" )
			{
				var token : ParseTreeNode = new ParseTreeNode( treeNode.document, treeNode.element, node  );

				return token;
			}

			return super.handleRequest( request, treeNode, node );
		}
	}
}
