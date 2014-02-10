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

package htmlrenderer.display
{

	import flash.display.DisplayObject;

	import htmlrenderer.html.Document;
	import htmlrenderer.html.Node;
	import htmlrenderer.util.TypeUtils;

	public class ElementImage extends Node
	{
		private var _image : DisplayObject;

		public function ElementImage( document : Document = null, element : Node = null, xml : XML = null, pStyle : Object = null )
		{
			super( document, element, xml, pStyle );
		}

		override public function draw() : void
		{
			super.draw();

			if ( _image && _computedStyles.hasOwnProperty( "maxWidth" ))
			{

				var maxWidth : * = _computedStyles.maxWidth;

				if ( maxWidth != "100%" )
				{
					maxWidth = TypeUtils.cleanNumber( maxWidth, parentElement.computedStyles.width );
					var scale : Number = maxWidth / image.width;
					image.scaleX = scale;
					image.scaleY = scale;

					_computedStyles.width = image.width;
					_computedStyles.height = image.height;
				}
			}

			_image.visible = true;

		}

		public function get image() : DisplayObject
		{
			return _image;
		}

		public function set image( value : DisplayObject ) : void
		{

			_image = value;
			_image.visible = false;
			addChild( _image );
		}
	}
}