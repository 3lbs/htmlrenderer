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

package htmlrenderer.parser
{

	import flash.events.Event;
	
	import htmlrenderer.html.Document;
	import htmlrenderer.html.ElementBase;
	import htmlrenderer.html.ElementImage;
	import htmlrenderer.parser.loader.AssetManager;
	import htmlrenderer.parser.loader.SWFFileLoader;

	public class SWFLoadTreeNode extends ParseLoadTreeNode
	{
		public function SWFLoadTreeNode( document : Document = null, element : ElementBase = null, node : XML = null )
		{
			super( document, element, node );
		}

		override protected function finished( event : Event = null ) : void
		{
			reset();

			while ( hasNext())
			{
				var loader : SWFFileLoader = next() as SWFFileLoader;

				var image : * = loader.loader.content;
				var url : String = loader.id;

				
				var style : Object = element.rawStyle;
				
				if ( !style.width )
				{
					element.rawStyle.width = node.@width.toString() || 0;
				}
				
				if ( !style.height )
				{
					element.rawStyle.height = node.@height.toString() || 0;					
				}
				
				//element.rawStyle.width = node.@width.toString() || image.width;
				//element.rawStyle.height = node.@height.toString() || image.height;

				loader.destroy();
				
				ElementImage( element ).image = image;
				
				var assetManager : AssetManager = document.assetManager.unload( loader );
				
			}

			super.finished( event );
		}
	}
}
