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

	import flash.display.DisplayObject;
	import flash.events.Event;

	import htmlrenderer.display.ElementText;
	import htmlrenderer.html.Document;
	import htmlrenderer.html.ElementBase;

	import totem.events.RemovableEventDispatcher;

	public class ParseTreeNode extends RemovableEventDispatcher
	{

		public static const COMPLETE : int = 2;

		public static const EMPTY : int = 0;

		public static const LOADING : int = 1;

		public var document : Document;

		public var element : ElementBase;

		public var node : XML;

		protected var _resources : Vector.<ParseTreeNode> = new Vector.<ParseTreeNode>();

		protected var _status : int = EMPTY;

		private var _id : String;

		private var _requires : Vector.<ParseTreeNode>;

		public function ParseTreeNode( document : Document = null, element : ElementBase = null, node : XML = null )
		{
			setTo( document, element, node );
		}

		public function canStart() : Boolean
		{
			// you dont want to start a loading or complete proxy again
			if ( status != EMPTY )
			{
				return false;
			}

			// test all the dependent proxy are ready
			for each ( var proxy : ParseTreeNode in _requires )
			{
				if ( proxy.isComplete() == false )
				{
					return false;
				}
			}

			return true;
		}

		override public function destroy() : void
		{
			while ( _resources.length > 0 )
				_resources.pop().destroy();

			if ( _requires )
				while ( _requires.length > 0 )
					_requires.pop().destroy();

			document = null;
			element = null;
			node = null;

			super.destroy();
		}

		public function getNodeByID( value : String ) : ParseTreeNode
		{

			for each ( var node : ParseTreeNode in _resources )
			{
				if ( node.id == value )
					return node;
			}
			// serach the array for item with id = value;
			return null;
		}

		public function getRequiredNodeByID( value : * ) : *
		{
			for each ( var node : ParseTreeNode in _requires )
			{
				if ( node.id == value )
					return node;
			}
			// serach the array for item with id = value;
			return null;
		}

		public function get id() : *
		{
			return _id;
		}

		public function set id( value : * ) : void
		{
			_id = value;
		}

		public function isComplete() : Boolean
		{

			if ( status == COMPLETE )
				return true;

			var i : int;

			var proxy : ParseTreeNode;

			for ( i = 0; i < _resources.length; ++i )
			{
				proxy = _resources[ i ];

				if ( proxy.status != COMPLETE )
				{
					return false;
				}
			}

			return true;
		}

		public function requires( ... args ) : void
		{
			_requires ||= new Vector.<ParseTreeNode>();

			for each ( var obj : ParseTreeNode in args )
			{
				if ( obj == null )
					continue;

				_requires.push( obj );
			}
		}

		public function setTo( document : Document = null, element : ElementBase = null, node : XML = null ) : void
		{
			this.document = document;
			this.element = element;
			this.node = node;
		}

		public function start() : void
		{
			_status = LOADING;

			var total : int = ( node ) ? node.children().length() : 0;
			var _childXml : XML;

			for ( var i : int = 0; i < total; ++i )
			{
				_childXml = node.children()[ i ];

				var nodeName : String = _childXml.name();

				if ( _childXml.nodeKind() == Parser.ELEMENT )
				{
					var result : ParseTreeNode = document.parser.tagChain.handleRequest( nodeName, this, _childXml );

					if ( result != null )
					{
						result.addEventListener( Event.COMPLETE, finished );
						_resources.push( result );
					}
				}
				else
				{
					// must be a text node or something we dont know 
					ElementText( element ).addCData( _childXml.toXMLString());
				}
			}

			finished();
		}

		public function get status() : Number
		{
			return _status;
		}

		protected function complete() : void
		{
			_status = COMPLETE;

			for ( var i : int = 0; i < _resources.length; ++i )
			{
				var result : ParseTreeNode = _resources[ i ];

				if ( result.element && result.element != element && result.element is DisplayObject )
				{
					if ( result.element.hasOwnProperty( "index" ))
					{
						result.element.index = i;
					}

					element.addElement( result.element );
				}
			}

			dispatchEvent( new Event( Event.COMPLETE ));
		}

		protected function finished( event : Event = null ) : void
		{
			if ( !doStartResource())
			{
				complete();
			}
		}

		private function doStartResource() : Boolean
		{
			if ( _resources == null || _resources.length == 0 || status == COMPLETE )
				return false;

			var proxy : ParseTreeNode;
			var l : int = _resources.length;
			var i : int;

			var building : Boolean = false;

			for ( i = 0; i < _resources.length; ++i )
			{
				proxy = _resources[ i ];

				if ( proxy.status == COMPLETE )
				{
					continue;
				}
				else
				{
					building = true;

					if ( proxy.status == EMPTY )
					{
						if ( proxy.canStart())
						{
							proxy.start();
						}
					}

				}
			}
			return building;
		}
	}
}
