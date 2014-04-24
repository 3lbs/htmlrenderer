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

	import flash.display.MovieClip;
	
	import htmlrenderer.html.ElementImage;
	import htmlrenderer.parser.ParseTreeNode;
	import htmlrenderer.parser.SWFLoadTreeNode;
	import htmlrenderer.parser.loader.AssetManager;
	import htmlrenderer.parser.loader.SWFFileLoader;
	import htmlrenderer.util.HTMLUtils;

	public class ObjectLink extends BaseLink
	{
		public function ObjectLink( successor : BaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest( request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{

			if ( request == "object" )
			{

				var element : ElementImage = createElement( treeNode.document, treeNode.element, node, INLINE, ElementImage ) as ElementImage;

				var token : ParseTreeNode;

				if ( node.@type == "application/x-shockwave-flash" )
				{
					var url : String =  HTMLUtils.cleanURL( node.@data.toString() );

					url = treeNode.document.baseFile.resolvePath( url ).url;
					
					var assetManager : AssetManager = treeNode.document.assetManager;

					// swf object

					var imageLoader : SWFFileLoader = assetManager.loadAsset( url, SWFFileLoader ) as SWFFileLoader;

					var image : * = imageLoader.data;
					element.rawStyle.width = node.@width.toString() || 0;
					element.rawStyle.height = node.@height.toString() || 0;

					if ( image )
					{
						if ( image is MovieClip )
						{
							element.image = image.bitmapData;
							MovieClip( image ).play();
						}

						token = new ParseTreeNode( treeNode.document, element );
					}
					else
					{
						
						token = new SWFLoadTreeNode( treeNode.document, element, node );

						//imageLoader.load( assetUrl.nativePath );
						SWFLoadTreeNode( token ).addLoader( imageLoader );
					}
				}

				return token;
				trace( "catch" );
			}

			return super.handleRequest( request, treeNode, node );
		}
	}
}
