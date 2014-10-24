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

package htmlrenderer.html
{

	import flash.display.DisplayObject;

	import htmlrenderer.util.TypeUtils;

	public class ElementImage extends Node
	{
		private var _image : DisplayObject;

		public function ElementImage( document : Document = null, element : Node = null, xml : XML = null, pStyle : Object = null )
		{
			super( document, element, xml, pStyle );
		}

		override public function destroy() : void
		{

			if ( _image.hasOwnProperty( "destroy" ))
			{
				_image[ "destroy" ].call();
			}

			_image = null;

			super.destroy();
		}

		public function get image() : DisplayObject
		{
			return _image;
		}

		public function set image( value : DisplayObject ) : void
		{
			_image = value;
			_image.visible = false;
		}

		override protected function draw() : void
		{
			removeChildren();


			if ( _computedStyles.hasOwnProperty( "display" ))
			{
				var display : String = _computedStyles.display;

				if ( display == "none" )
				{
					if ( _image )
					{
						_image.visible = false;

						if ( _image.parent )
						{
							_image.parent.removeChild( _image );
						}
					}

					super.draw();
					return;
				}
			}

			scaleImage();
			
			if ( _image )
			{
				_image.visible = true;
				addChild( _image );
				
				
			}

			super.draw();
		}

		private function scaleImage() : void
		{
			
			//&& _computedStyles.hasOwnProperty( "maxWidth" )
			if ( _image )
			{

				var maxWidth : * = _computedStyles.maxWidth;

				if ( maxWidth != null  && maxWidth != "100%" )
				{
					maxWidth = TypeUtils.cleanNumber( maxWidth, parentElement.computedStyles.width );
					var scale : Number = maxWidth / image.width;

					image.scaleX = scale;
					image.scaleY = scale;
				}

				_computedStyles.width = image.width;
				_computedStyles.height = image.height;
			}
		}
	}
}
