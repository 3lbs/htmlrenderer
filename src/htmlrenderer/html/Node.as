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

	import flash.system.System;

	import htmlrenderer.event.HTMLEvent;

	public class Node extends ElementBase
	{
		public var appliedStyles : Array;

		private var _element : Node

		private var _innerHTML : String;

		private var _innerXML : XML;

		public function Node( document : Document = null, element : Node = null, xml : XML = null, pStyle : Object = null )
		{
			super( pStyle );

			this.document = document;
			_element = element;
			_innerXML = xml

			if ( _element && _innerXML )
			{
				if ( _innerXML.@name.toString())
				{
					name = _innerXML.@name.toString();
				}
				else if ( _innerXML.@id.toString())
				{
					name = _innerXML.@id.toString();
				}
				else
				{
					name = _innerXML.name() + name.split( "instance" ).join( "" );
					_innerXML.@id = name; // set the name back on in the id of the xml
				}
			}

		}

		override public function destroy() : void
		{
			document = null;

			_element = null;

			System.disposeXML( _innerXML );
			_innerXML = null;

			super.destroy();
		}

		public function get innerHTML() : String
		{
			return _innerHTML;
		}

		public function set innerHTML( value : String ) : void
		{
			if ( value !== _innerHTML )
			{
				_innerHTML = value;

				innerXML = document.parser.cleanHTML( _innerHTML );
			}
		}

		public function get innerXML() : XML
		{
			return _innerXML;
		}

		public function set innerXML( value : XML ) : void
		{
			if ( value !== _innerXML )
			{
				_innerXML = value;

				document.addEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, handleParseComplete );
				document.parseHTML( document, this, _innerXML );
			}
		}

		public function get nodeXML() : XML
		{
			return _innerXML;
		}

		protected function handleParseComplete( event : HTMLEvent ) : void
		{
			document.removeEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, handleParseComplete );

			dispatchEvent( event.clone());
		}
	}
}
