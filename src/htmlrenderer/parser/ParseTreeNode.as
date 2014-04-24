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

	import flash.display.DisplayObject;
	import flash.events.Event;

	import htmlrenderer.html.Document;
	import htmlrenderer.html.ElementText;
	import htmlrenderer.html.Node;

	import totem.events.RemovableEventDispatcher;

	public class ParseTreeNode extends RemovableEventDispatcher
	{

		public static const COMPLETE : int = 2;

		public static const EMPTY : int = 0;

		public static const LOADING : int = 1;

		public var document : Document;

		public var element : Node;

		public var node : XML;

		protected var _parseNodes : Vector.<ParseTreeNode> = new Vector.<ParseTreeNode>();

		protected var _status : int = EMPTY;

		private var _id : String;

		private var _requires : Vector.<ParseTreeNode>;

		public function ParseTreeNode( document : Document = null, element : Node = null, node : XML = null )
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
			while ( _parseNodes.length > 0 )
				_parseNodes.pop().destroy();

			_parseNodes = null;
			
			if ( _requires )
				_requires.length = 0;
			
			_requires = null;
			document = null;
			element = null;
			node = null;

			super.destroy();
		}

		public function getNodeByID( value : String ) : ParseTreeNode
		{

			for each ( var node : ParseTreeNode in _parseNodes )
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

			for ( i = 0; i < _parseNodes.length; ++i )
			{
				proxy = _parseNodes[ i ];

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

		public function setTo( document : Document = null, element : Node = null, node : XML = null ) : void
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
						_parseNodes.push( result );
					}
				}
				else
				{
					// must be a text node or something we dont know 
					ElementText( element ).addCData( _childXml.toXMLString());
				}
			}

			if ( !doStartParseNodes())
			{
				complete();
			}
		}

		public function get status() : Number
		{
			return _status;
		}

		protected function complete() : void
		{
			_status = COMPLETE;

			for ( var i : int = 0; i < _parseNodes.length; ++i )
			{
				var result : ParseTreeNode = _parseNodes[ i ];

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
			if ( !doStartParseNodes())
			{
				complete();
			}
		}

		private function doStartParseNodes() : Boolean
		{
			if ( _parseNodes == null || _parseNodes.length == 0 || status == COMPLETE )
				return false;

			var tnode : ParseTreeNode;
			var l : int = _parseNodes.length;
			var i : int;

			var building : Boolean = false;

			for ( i = 0; i < _parseNodes.length; ++i )
			{
				tnode = _parseNodes[ i ];

				if ( tnode.status == COMPLETE )
				{
					continue;
				}
				else
				{
					building = true;

					if ( tnode.status == EMPTY )
					{
						if ( tnode.canStart())
						{
							tnode.start();
						}
					}

				}
			}
			return building;
		}
	}
}
