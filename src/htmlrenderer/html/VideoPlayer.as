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

	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.MouseEvent;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	import totem.ui.layout.ElementUI;
	import totem.ui.layout.layouts.CanvasUI;

	public class VideoPlayer extends CanvasUI
	{
		public static const PLAY_BUTTON_ALIGN_BOTTOM_LEFT : String = "playButtonAlignBottomLeft";

		public static const PLAY_BUTTON_ALIGN_BOTTOM_RIGHT : String = "playButtonAlignBottomRIght";

		public static const PLAY_BUTTON_ALIGN_MIDDLE : String = "playButtonAlignMiddle";

		public static const PLAY_BUTTON_ALIGN_UP_RIGHT : String = "playButtonAlignUpRight";

		private var _buttonAlign : String = PLAY_BUTTON_ALIGN_MIDDLE;

		private var _buttonClass : Class;

		private var _url : String;

		private var _video : Video;

		private var button : SimpleButton;

		private var netStream : NetStream;

		public function VideoPlayer( reference : DisplayObjectContainer, clazz : Class = null, width : Number = 100, height : Number = 10 )
		{
			_buttonClass = clazz || assets.videoplayer.VideoPlayButton;

			super( reference, width, height );

		}

		public function get buttonAlign() : String
		{
			return _buttonAlign;
		}

		public function set buttonAlign( value : String ) : void
		{
			_buttonAlign = value;
		}

		public function set buttonClass( value : Class ) : void
		{
			_buttonClass = value;
		}

		override public function dispose() : void
		{
			button.removeEventListener( MouseEvent.CLICK, handlePlayVideo );
			remove( button );

			netStream.removeEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			netStream.close();
			netStream.dispose();

			video.clear();
			remove( video );

			super.dispose();
		}

		public function loadURL( u : String ) : void
		{
			_url = u;

			_video = new Video( width, height );
			add( video );

			button = new _buttonClass();

			button.addEventListener( MouseEvent.CLICK, handlePlayVideo );
			var buttonElement : ElementUI = add( button );

			switch ( _buttonAlign )
			{
				case PLAY_BUTTON_ALIGN_BOTTOM_LEFT:
				{
					buttonElement.alignX = ElementUI.ALIGN_LEFT;
					buttonElement.alignY = ElementUI.ALIGN_BOTTOM;
					buttonElement.left = 5;
					buttonElement.bottom = 5;

					break;
				}
				case PLAY_BUTTON_ALIGN_BOTTOM_RIGHT:
				{
					buttonElement.alignX = ElementUI.ALIGN_RIGHT;
					buttonElement.alignY = ElementUI.ALIGN_BOTTOM;
					buttonElement.right = 5;
					buttonElement.bottom = 5;

					break;
				}
				case PLAY_BUTTON_ALIGN_MIDDLE:
				{
					buttonElement.alignX = ElementUI.ALIGN_CENTER;
					buttonElement.alignY = ElementUI.ALIGN_CENTER;
					buttonElement.horizontalCenter = 0;
					buttonElement.verticalCenter = 0;
					break;
				}
				case PLAY_BUTTON_ALIGN_UP_RIGHT:
				{
					buttonElement.alignX = ElementUI.ALIGN_RIGHT;
					buttonElement.alignY = ElementUI.ALIGN_TOP;
					buttonElement.right = 5;
					buttonElement.top = 5;
					break;
				}

				default:
				{
					break;
				}
			}

			var customClient : Object = new Object();

			var nc : NetConnection = new NetConnection();
			nc.connect( null );

			netStream = new NetStream( nc );
			netStream.client = customClient;

			netStream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			_video.attachNetStream( netStream );

			netStream.play( _url );
			netStream.togglePause();

			refresh();

		}

		public function get video() : Video
		{
			return _video;
		}

		protected function handlePlayVideo( event : MouseEvent ) : void
		{
			netStream.play( _url );

			button.visible = false;

		}

		private function netStatusHandler( evt : NetStatusEvent ) : void
		{

			switch ( evt.info.code )
			{
				case "NetStream.Play.Start":
					//trace("Start [" + ns.time.toFixed(3) + " seconds]"); 
					break;
				case "NetStream.Play.Stop":
					//trace("Stop [" + ns.time.toFixed(3) + " seconds]");
					button.visible = true;
					break;
			}

		}
	}
}
