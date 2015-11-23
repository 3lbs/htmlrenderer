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

	import assets.videoplayer.VideoPlayButton;
	import assets.videoplayer.VideoPlayButtonHD;

	import htmlrenderer.util.TypeUtils;

	import totem.utils.MobileUtil;

	public class ElementVideo extends Node
	{
		private var _url : String;

		private var videoPlayer : VideoPlayer;

		public function ElementVideo( document : Document = null, element : Node = null, xml : XML = null, pStyle : Object = null )
		{
			super( document, element, xml, pStyle );
		}

		override public function destroy() : void
		{

			videoPlayer.dispose();

			super.destroy();
		}

		public function initialize( url : String ) : void
		{

			var buttonClass : Class = MobileUtil.isHD() ? VideoPlayButtonHD : VideoPlayButton;
			videoPlayer = new VideoPlayer( this, buttonClass );
			videoPlayer.backgroundColor = 0;
			videoPlayer.backgroundAlpha = 1;
			videoPlayer.height = TypeUtils.cleanString( rawStyle.height );
			videoPlayer.width = TypeUtils.cleanString( rawStyle.width );

			addChild( videoPlayer );

			videoPlayer.loadURL( url );

		}

		override protected function draw() : Boolean
		{
			removeChildren();

			if ( _computedStyles.hasOwnProperty( "display" ) || parentElement.computedStyles.hasOwnProperty( "display" ))
			{
				var display : String = _computedStyles.display;

				var parentDisplay : String = parentElement.computedStyles.display;

				if ( display == "none" || parentDisplay == "none" )
				{
					_computedStyles.width = 0;
					_computedStyles.height = 0;
					_computedStyles.display = "none";

					if ( videoPlayer )
					{
						//videoPlayer.visible = false;
						videoPlayer.height = TypeUtils.cleanString( rawStyle.height );
						videoPlayer.width = TypeUtils.cleanString( rawStyle.width );

						videoPlayer.refresh();
					}

					return super.draw();
				}
			}

			if ( videoPlayer )
			{

				videoPlayer.height = TypeUtils.cleanString( rawStyle.height );
				videoPlayer.width = TypeUtils.cleanString( rawStyle.width );
				//videoPlayer.visible = true;
				addChild( videoPlayer );

				videoPlayer.refresh();
			}

			return super.draw();
		}
	}
}
