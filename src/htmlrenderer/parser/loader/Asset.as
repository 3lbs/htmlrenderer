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
	import flash.events.IOErrorEvent;

	import totem.events.RemovableEventDispatcher;

	public class Asset extends RemovableEventDispatcher
	{

		protected static const COMPLETE : int = 2;

		protected static const EMPTY : int = 0;

		protected static const FAILED : int = 5;

		protected static const LOADING : int = 1;

		protected var _status : int = EMPTY;

		protected var url : String;

		private var _id : String;

		private var _requires : Vector.<Asset> = new Vector.<Asset>();

		public function Asset( url : String )
		{
			this.url = url;
			super();
		}

		public function canStart() : Boolean
		{
			// you dont want to start a loading or complete proxy again
			if ( status != EMPTY )
			{
				return false;
			}

			// test all the dependent proxy are ready
			for each ( var proxy : Asset in _requires )
			{
				if ( proxy.isComplete() == false )
				{
					return false;
				}
			}

			return true;
		}

		public function get data() : *
		{
			return null;
		}

		override public function destroy() : void
		{
			_requires.length = 0;
			_requires = null;
			super.destroy();
		}

		public function getURL() : String
		{
			return url;
		}

		public function get id() : String
		{
			return _id;
		}

		public function set id( value : String ) : void
		{
			_id = value;
		}

		public function isComplete() : Boolean
		{
			return _status == COMPLETE;
		}

		public function isFailed() : Boolean
		{
			return _status == FAILED;
		}

		public function required( list : Vector.<Asset> ) : void
		{
			_requires ||= new Vector.<Asset>();

			_requires.concat( list );
		}

		public function start() : void
		{
			if ( _status == COMPLETE )
			{
				complete();
			}
		}

		public function get status() : int
		{
			return _status;
		}

		protected function failed() : void
		{
			_status = FAILED;

			throw new Error( "failed to load" );
			dispatchEvent( new IOErrorEvent( IOErrorEvent.IO_ERROR ));
		}

		protected function finished() : void
		{
			removeEvents();

			if ( _status != COMPLETE )
			{
				complete();
			}
		}

		protected function removeEvents() : void
		{
		}

		private function complete() : void
		{
			_status = COMPLETE;

			dispatchEvent( new Event( Event.COMPLETE ));
		}
	}
}
