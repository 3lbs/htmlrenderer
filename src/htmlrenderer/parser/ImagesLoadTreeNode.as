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

	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.filesystem.File;
	
	import htmlrenderer.html.ElementImage;
	import htmlrenderer.html.Document;
	import htmlrenderer.html.ElementBase;
	import htmlrenderer.parser.loader.ImageLoader;

	public class ImagesLoadTreeNode extends ParseLoadTreeNode
	{

		private var _fileURL : File;
		
		public function ImagesLoadTreeNode( document : Document = null, element : ElementBase = null, node : XML = null )
		{
			super( document, element, node );
		}

		override protected function finished( event : Event = null ) : void
		{
			reset();

			while ( hasNext())
			{
				var loader : ImageLoader = next() as ImageLoader;

				var image : * = loader.data;
				var url : String = loader.id;

				element.rawStyle.width = node.@width.toString() || image.width;
				element.rawStyle.height = node.@height.toString() || image.height;

				if ( image is Bitmap )
				{
					ElementImage( element ).image = new Bitmap( loader.bitmapData );
				}
				else
				{
					ElementImage( element ).image = image;
					MovieClip( image ).play();
				}
			}

			super.finished( event );
		}
		
		
	}
}
