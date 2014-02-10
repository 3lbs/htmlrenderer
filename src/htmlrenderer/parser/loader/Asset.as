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

package htmlrenderer.parser.loader
{

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import totem.events.RemovableEventDispatcher;

	public class Asset extends RemovableEventDispatcher
	{

		protected static const COMPLETE : int = 2;

		protected static const EMPTY : int = 0;

		protected static const LOADING : int = 1;

		protected var url : String;

		private var _id : String;

		protected var _status : int = EMPTY;

		public function Asset( url : String )
		{
			this.url = url;
		}

		override public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );

			if ( _status == COMPLETE && type == Event.COMPLETE )
			{
				complete();
			}
		}

		public function get data() : *
		{
			return null;
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

		public function start() : void
		{
			if ( _status == COMPLETE )
			{
				complete();
			}
		}

		protected function finished () : void
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
