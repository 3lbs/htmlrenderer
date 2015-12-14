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
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;

	import htmlrenderer.html.Document;
	import htmlrenderer.html.ElementBase;
	import htmlrenderer.parser.loader.Asset;

	public class ParseLoadTreeNode extends ParseTreeNode
	{

		protected var totalCount : int;

		private var _complete : int;

		private var _index : int;

		private var _loaders : Vector.<Asset> = new Vector.<Asset>();

		public function ParseLoadTreeNode( document : Document = null, element : ElementBase = null, node : XML = null )
		{
			super( document, element, node );

			_complete = 0;

			_index = -1;
		}

		public function addLoader( loader : Asset, eventType : String = Event.COMPLETE ) : void
		{
			_loaders.push( loader );
			totalCount += 1;
			loader.addEventListener( eventType, onComplete );
			loader.addEventListener( IOErrorEvent.IO_ERROR, handleOnFailed );
		}

		override public function destroy() : void
		{

			//while ( _loaders.length > 0 )
			//_loaders.pop(); //.destroy();

			_loaders.length = 0;
			_loaders = null;

			super.destroy();
		}

		public function hasLoaderByID( id : String ) : Boolean
		{
			reset();

			while ( hasNext())
			{
				if ( next().id == id )
				{
					return true;
				}
			}
			return false;
		}

		public function hasNext() : Boolean
		{
			return ( _index < _loaders.length - 1 );
		}

		override public function isComplete() : Boolean
		{

			if ( status == COMPLETE )
				return true;

			return false;
		}

		public function next() : Asset
		{
			if ( !( _index < _loaders.length - 1 ))
			{
				return null;
			}
			return _loaders[ ++_index ];
		}

		public function reset() : void
		{
			_index = -1;
		}

		override public function start() : void
		{
			_status = LOADING;

			var l : int = _loaders.length;
			var asset : Asset;

			for ( var i : int = 0; i < l; ++i )
			{
				asset = _loaders[ i ];

				if ( asset.isComplete())
				{
					_complete += 1;
				}
			}

			/*var l : int = _loaders.length;
			var asset : Asset;

			for ( var i : int = 0; i < l; ++i )
			{
				asset = _loaders[ i ];

				if ( asset.isComplete())
				{
					wait( 3, onComplete );
				}
				else
				{
					asset.start();
				}
			}
		reset();

		// this starts all loaders
		while ( hasNext())
		{
			next().start();
		}*/

			if ( _loaders.length > 0 && _complete >= totalCount )
			{
				finished();
			}
			else
			{
				doStart();
			}
		}

		public function get totalDispatchers() : int
		{
			return _loaders.length;
		}

		override protected function complete() : void
		{
			super.complete();

		}

		protected function handleOnFailed( event : Event ) : void
		{
			var loader : Asset = event.target as Asset;
			trace( "failed to load:", loader.getURL());
			complete();
		}

		protected function onComplete( eve : Event = null ) : void
		{
			if ( eve )
			{
				var loader : IEventDispatcher = eve.target as IEventDispatcher;
				loader.removeEventListener( eve.type, onComplete );
				loader.removeEventListener( IOErrorEvent.IO_ERROR, handleOnFailed );
			}

			_complete += 1;

			if ( _loaders.length > 0 && _complete >= totalCount && status != EMPTY )
			{
				finished();
			}
			else
			{
				doStart();
			}
		}

		private function doStart() : Boolean
		{
			var l : int = _loaders.length;
			var asset : Asset;

			var building : Boolean = false;
			var i : int;

			for ( i = 0; i < l; ++i )
			{
				asset = _loaders[ i ];

				if ( asset.isComplete())
				{
					//wait( 3, onComplete );
					continue;
				}
				else
				{
					building = true;

					if ( asset.status == EMPTY )
					{
						if ( asset.canStart())
						{
							asset.start();
						}
					}
				}
			}

			return building;
		}
	}
}
