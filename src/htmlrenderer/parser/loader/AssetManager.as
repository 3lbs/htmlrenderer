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

package htmlrenderer.parser.loader
{

	import flash.filesystem.File;
	import flash.utils.Dictionary;

	import totem.core.Destroyable;
	import totem.core.IDestroyable;

	public class AssetManager extends Destroyable
	{

		public var attribute : Array = [ "backgroundImage", "src", "data" ];

		public var resourceMap : Dictionary = new Dictionary();

		public var tags : Array = [ "img", "object" ];

		private var enque : Vector.<Asset> = new Vector.<Asset>();

		private var totalQue : int = 3;

		private var types : Array = [ ".png", ".gif", ".swf", ".jpg", ".css" ];

		public function AssetManager()
		{
		}

		override public function destroy() : void
		{

			for ( var key : String in resourceMap )
			{
				if ( resourceMap[ key ] is IDestroyable )
				{
					IDestroyable( resourceMap[ key ]).destroy();
				}

				resourceMap[ key ] = null;
				delete resourceMap[ key ];
			}

			super.destroy();
		}

		public function getAsset( id : String ) : Asset
		{
			return resourceMap[ id ];
		}

		public function hasAsset( id : String ) : Boolean
		{
			return resourceMap[ id ] != null;
		}

		public function loadAsset( url : String, assetClassType : Class ) : Asset
		{
			var asset : Asset;

			if ( hasAsset( url ))
			{
				trace( "already exsist this file in asset" )
				return getAsset( url );
			}
			else
			{

				var assetFile : File = new File( url );

				if ( assetFile.exists == true )
				{
					if ( types.indexOf( assetFile.type.toLowerCase()) > -1 )
					{
						asset = new assetClassType( assetFile.url );
						asset.id = url;
						resourceMap[ url ] = asset;

					}
					else
					{
						trace( "cant load file of type: " + assetFile.type );
					}
				}
				else
				{
					throw new Error( "File doesnt exsist" );
				}

			}

			return asset;
		}

		public function unload( loader : Asset ) : AssetManager
		{

			if ( hasAsset( loader.id ))
			{
				resourceMap[ loader.id ] = null;
				delete resourceMap[ loader.id ];
			}

			if ( !loader.destroyed )
				loader.destroy();

			return null;
		}
	}
}
