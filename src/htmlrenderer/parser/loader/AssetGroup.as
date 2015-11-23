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

	import flash.events.Event;

	public class AssetGroup extends Asset
	{

		private var _loadedCount : int = 0;

		private var _loaders : Vector.<Asset> = new Vector.<Asset>();

		public function AssetGroup( url : String )
		{
			super( url );
		}

		public function addLoader( asset : Asset ) : Asset
		{

			_loaders.push( asset );

			asset.addEventListener( Event.COMPLETE, handleAssetComplete );
			return asset;
		}

		override public function destroy() : void
		{
			super.destroy();

			_loaders.length = 0;
			_loaders = null;

		}

		override public function start() : void
		{

			_loadedCount = 0;
			var l : int = _loaders.length;

			if ( l > 0 )
			{
				_status = LOADING;

				while ( l-- )
					_loaders[ l ].start();
			}
			else
			{
				finished();
			}

		}

		protected function handleAssetComplete( event : Event ) : void
		{

			var asset : Asset = event.target as Asset;
			asset.removeEventListener( Event.COMPLETE, handleAssetComplete );

			_loadedCount++;

			if ( _loadedCount >= _loaders.length )
			{
				finished();
			}
		}
	}
}
