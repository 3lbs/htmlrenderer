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

package htmlrenderer.html
{

	/*
	features
		left=pixels	The left position of the window
		top=pixels	The top position of the window
		width=pixels	The width of the window. Min. value is 100
		height=pixels	The height of the window. Min. value is 100
		scrollbars=yes|no|1|0	Whether or not to display scroll bars. Default is yes
	*/
	public class Frame extends Node
	{
		private var _features : Object;

		private var _layers : Array = [];

		private var _url : String;

		public function Frame( document : Document, url : String = null, name : String = null, features : Object = null )
		{
			super( document );
			style.width = "100%";
			style.height = "100%";

			if ( name )
				this.name = "_layer" + name;
			else
				this.name = "_layer";

			if ( url )
				this.url = url;
			_features = features;
			document.window.addChild( this );
			addLayer( 0 );
		}

		public function addLayer( zIndex : uint ) : Layer
		{
			var result : Layer = getLayer( zIndex );

			if ( !result )
				result = new Layer( document, zIndex );

			_layers.push( result );

			addChild( result );

			return result
		}

		public function get features() : Object
		{
			return _features;
		}

		public function getLayer( zIndex : uint ) : Layer
		{
			var result : Layer

			for each ( var layer : Layer in layers )
			{
				if ( layer.zIndex == zIndex )
				{
					result = layer;
					break;
				}
			}
			return result
		}

		public function get layers() : Array
		{
			return _layers;
		}

		public function set layers( value : Array ) : void
		{
			if ( value !== _layers )
			{
				_layers = value;
			}
		}

		public function get url() : String
		{
			return _url;
		}

		public function set url( value : String ) : void
		{
			if ( value !== _url )
			{
				_url = value;
			}
		}
	}
}
