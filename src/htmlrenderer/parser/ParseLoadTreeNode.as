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

package htmlrenderer.parser
{

	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import htmlrenderer.html.Document;
	import htmlrenderer.html.ElementBase;
	import htmlrenderer.parser.loader.Asset;

	public class ParseLoadTreeNode extends ParseTreeNode
	{

		protected var totalCount : int;

		private var _complete : int;

		private var _index : int;

		private var _list : Vector.<Asset> = new Vector.<Asset>();

		public function ParseLoadTreeNode( document : Document = null, element : ElementBase = null, node : XML = null )
		{
			super( document, element, node );

			_complete = 0;

			_index = -1;
		}

		public function addLoader( loader : Asset, eventType : String = Event.COMPLETE ) : void
		{
			_list.push( loader );
			totalCount += 1;
			loader.addEventListener( eventType, onComplete );
		}

		override public function destroy() : void
		{

			while ( _list.length > 0 )
				_list.pop().destroy();

			_list = null;
			
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
			return ( _index < _list.length - 1 );
		}

		public function next() : Asset
		{
			if ( !( _index < _list.length - 1 ))
			{
				return null;
			}
			return _list[ ++_index ];
		}

		public function reset() : void
		{
			_index = -1;
		}
		override public function isComplete() : Boolean
		{
			
			if ( status == COMPLETE )
				return true;

			return false;
		}

		override public function start() : void
		{
			_status = LOADING;
			
			reset();

			while ( hasNext())
			{
				next().start();
			}
		}

		public function get totalDispatchers() : int
		{
			return _list.length;
		}

		protected function onComplete( eve : Event ) : void
		{
			var loader : IEventDispatcher = eve.target as IEventDispatcher;
			loader.removeEventListener( eve.type, onComplete );

			dispatchEvent( new Event( Event.CHANGE ));

			_complete += 1;

			if ( _list.length > 0 && _complete >= totalCount )
			{

				finished();
			}
		}
	}
}
