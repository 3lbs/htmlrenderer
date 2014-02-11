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

	import htmlrenderer.html.ElementText;
	import htmlrenderer.parser.ParseTreeNode;

	public class CDATALink extends BaseLink
	{
		public function CDATALink( successor : BaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest( request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{

			if ( request == "cdata" )
			{
				ElementText( treeNode.element ).addCData( node.toXMLString());
				return null;
			}

			return super.handleRequest( request, treeNode, node );
		}
	}
}
