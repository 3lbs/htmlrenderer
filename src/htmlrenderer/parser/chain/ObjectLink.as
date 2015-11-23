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
	import htmlrenderer.html.ElementInteractive;
	import htmlrenderer.parser.ParseTreeNode;
	import htmlrenderer.parser.SWFLoadTreeNode;
	import htmlrenderer.parser.loader.AssetManager;
	import htmlrenderer.parser.loader.SWFFileLoader;
	import htmlrenderer.util.HTMLUtils;
	
	import totem.utils.URLUtil;

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

				var element : ElementImage;

				var token : ParseTreeNode;

				var url : String = HTMLUtils.cleanURL( node.@data.toString());

				if ( node.@type == "application/x-shockwave-flash" || URLUtil.getFileExtension( url ) == "swf" )
				{

					element = createElement( treeNode.document, treeNode.element, node, INLINE, ElementInteractive ) as ElementInteractive;
					url = treeNode.document.baseFile.resolvePath( url ).url;

					var assetManager : AssetManager = treeNode.document.assetManager;

					// swf object

					var imageLoader : SWFFileLoader = assetManager.loadAsset( url, SWFFileLoader ) as SWFFileLoader;

					var image : * = imageLoader.data;
					
					var style : Object = element.rawStyle;
					
					if ( !style.width )
					{
						element.rawStyle.width = node.@width.toString() || 0;
					}
					
					if ( !style.height )
					{
						element.rawStyle.height = node.@height.toString() || 0;					
					}

					if ( image )
					{
						if ( image is MovieClip )
						{
							element.image = image.bitmapData;
						//MovieClip( image ).play();
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
			}

			return super.handleRequest( request, treeNode, node );
		}
	}
}
