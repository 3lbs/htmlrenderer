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

	import flash.display.Bitmap;
	import flash.display.MovieClip;

	import htmlrenderer.display.ElementImage;
	import htmlrenderer.parser.ImagesLoadTreeNode;
	import htmlrenderer.parser.ParseTreeNode;
	import htmlrenderer.parser.loader.AssetManager;
	import htmlrenderer.parser.loader.ImageLoader;

	public class ImgLink extends BaseLink
	{

		public function ImgLink( successor : BaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest( request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{
			if ( request == "img" )
			{

				//var obj : Object = element( document, target, xml, INLINE );

				var element : ElementImage = createElement( treeNode.document, treeNode.element, node, INLINE, ElementImage ) as ElementImage;

				var token : ParseTreeNode;
				var url : String = node.@src.toString();

				var assetManager : AssetManager = treeNode.document.assetManager;

				var imageLoader : ImageLoader = assetManager.loadAsset( url, ImageLoader ) as ImageLoader;

				var image : * = imageLoader.data;
				element.rawStyle.width = node.@width.toString() || 0;
				element.rawStyle.height = node.@height.toString() || 0;

				if ( image )
				{
					if ( image is Bitmap )
					{
						element.image = new Bitmap( image.bitmapData );
					}
					else
					{
						element.image = image.bitmapData;
						MovieClip( image ).play();
					}

					token = new ParseTreeNode( treeNode.document, element );
				}
				else
				{
					token = new ImagesLoadTreeNode( treeNode.document, element, node );

					//imageLoader.load( assetUrl.nativePath );
					ImagesLoadTreeNode( token ).addLoader( imageLoader );
				}

				return token;
			}

			return super.handleRequest( request, treeNode, node );
		}
	}
}
