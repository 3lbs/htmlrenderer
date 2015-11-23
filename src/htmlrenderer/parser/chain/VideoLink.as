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

package htmlrenderer.parser.chain
{

	import htmlrenderer.html.ElementVideo;
	import htmlrenderer.parser.ParseTreeNode;

	public class VideoLink extends BaseLink
	{
		public function VideoLink( successor : BaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest( request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{

			if ( request == "video" )
			{

				var element : ElementVideo;

				var token : ParseTreeNode;

				var url : String;

				var tags : XMLList = node..source.( @type == "video/flv" );
				
				if ( tags.length() > 0 )
				{
					url = tags[ 0 ].@src;
				}

				url = treeNode.document.baseFile.resolvePath( url ).url;
				
				element = createElement( treeNode.document, treeNode.element, node, INLINE, ElementVideo ) as ElementVideo;

				//element.rawStyle.width = node.@width.toString() || 0;
				//element.rawStyle.height = node.@height.toString() || 0;
				
				element.initialize ( url );
				

				token = new ParseTreeNode( treeNode.document, element );

				return token;
			}

			return super.handleRequest( request, treeNode, node );
		}
	}
}
