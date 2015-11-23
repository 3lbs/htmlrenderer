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
			//_image.visible = false;
			
			//rawStyle.width = _image.width;
		//	rawStyle.height = _image.height;
		}

		override protected function draw() : Boolean
		{
			removeChildren();


			if ( _computedStyles.hasOwnProperty( "display" ) || parentElement.computedStyles.hasOwnProperty( "display" ) )
			{
				var display : String = _computedStyles.display;

				var parentDisplay : String = parentElement.computedStyles.display;
				
				if ( display == "none" || parentDisplay == "none" )
				{
					
					_computedStyles.width = 0;
					_computedStyles.height = 0;
					_computedStyles.display = "none";
					
					if ( _image )
					{
						//_image.visible = false;

						if ( _image.parent )
						{
							_image.parent.removeChild( _image );
						}
					}

					
					return super.draw();
				}
			}

			scaleImage();
			
			if ( _image )
			{
				_image.visible = true;
				addChild( _image );
			}

			return super.draw();
		}

		protected function scaleImage() : void
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
