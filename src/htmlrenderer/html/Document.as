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

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.system.System;

	import htmlrenderer.event.HTMLEvent;
	import htmlrenderer.html.position.AutoPositionLink;
	import htmlrenderer.html.position.PositionBaseLink;
	import htmlrenderer.html.position.Static2PositionLink;
	import htmlrenderer.parser.Parser;
	import htmlrenderer.parser.loader.AssetManager;

	import totem.display.layout.TSprite;

	/**
	 *
	 * @author eddie
	 *
	 */
	public class Document extends TSprite
	{

		public var assetManager : AssetManager;

		public var layoutPosition : PositionBaseLink;

		public var parser : Parser;

		public var window : Window;

		private var _baseFont : int = 16;

		private var _html : XML;

		private var _title : String;

		private var documentElement : ElementBase;

		public function Document( window : Window, assetManager : AssetManager )
		{
			this.window = window;
			this.assetManager = assetManager;
			parser = new Parser();
			super();
			graphics.clear();

			var autoPosition : AutoPositionLink = new AutoPositionLink();
			var staticPostion : Static2PositionLink = new Static2PositionLink( autoPosition );
			layoutPosition = staticPostion;

		}

		public function get baseFont() : int
		{
			return _baseFont;
		}

		override public function destroy() : void
		{
			parser.destroy();
			parser = null;

			_html = null;

			window = null;

			super.destroy();
		}

		public function getElementById( id : String ) : ElementBase
		{
			var result : ElementBase;
			function loop( target : DisplayObjectContainer ) : void
			{
				var length : int = target.numChildren;

				for ( var i : uint = 0; i < length; i++ )
				{
					var child : * = target.getChildAt( i );

					if ( child is DisplayObjectContainer )
					{
						var check : DisplayObject = child.getChildByName( id );

						if ( check != null )
						{
							result = check as ElementBase;
						}
						else
						{
							loop( child );
						}
					}
				}
			}

			loop( window );

			return result;
		}

		public function getElementsByClassName( name : String ) : Array
		{
			var results : Array = new Array();

			function loop( target : ElementBase ) : void
			{

				var childrenElement : Vector.<ElementBase> = target.childrenElements;

				for ( var i : uint = 0; i < childrenElement.length; i++ )
				{
					var child : ElementBase = childrenElement[ i ];

					if ( child is Node && ( child as Node ).innerXML )
					{
						var classes : String = ( child as Node ).innerXML.@[ "class" ].toString();

						if ( classes )
						{
							for each ( var clazz : String in classes.split( " " ))
							{
								if ( clazz == name )
								{
									results.push( child )
								}
							}
						}
					}

					if ( child is ElementBase )
					{
						loop( child );
					}
				}
			}

			loop( documentElement );

			return results;
		}

		public function getElementsByTagName( name : String ) : Array
		{
			var results : Array = new Array();

			function loop( target : ElementBase ) : void
			{

				var childrenElement : Vector.<ElementBase> = target.childrenElements;

				for ( var i : uint = 0; i < childrenElement.length; i++ )
				{
					var child : ElementBase = childrenElement[ i ];

					if ( child is Node && ( child as Node ).innerXML )
					{
						var nodeName : String = ( child as Node ).innerXML.localName();

						if ( nodeName == name )
						{
							results.push( child );
						}
					}

					if ( child is ElementBase )
					{
						loop( child );
					}
				}
			}

			loop( documentElement );

			return results;
		}

		public function get html() : XML
		{
			return _html;
		}

		public function parseHTML( document : Document, target : ElementBase, node : XML ) : void
		{
			_html = node;
			parser.addEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, handleParseComplete );
			parser.parseHTML( document, target, node );
		}

		public function get title() : String
		{
			return _title;
		}

		public function set title( value : String ) : void
		{
			if ( value !== _title )
			{
				_title = value;
			}
		}

		public function get url() : String
		{
			return window.windowURL;
		}

		protected function handleParseComplete( event : HTMLEvent ) : void
		{
			parser.removeEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, handleParseComplete );

			documentElement = event.element;

			documentElement.updateDisplay();

			dispatchEvent( event.clone());
		}
	}
}
