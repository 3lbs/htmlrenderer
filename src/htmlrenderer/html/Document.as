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

package htmlrenderer.html
{

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	import htmlrenderer.event.HTMLEvent;
	import htmlrenderer.html.css.CSS;
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

		public var css : CSS;

		public var fontURLFiles : Array;

		public var layoutPosition : PositionBaseLink;

		public var parser : Parser;

		private var _baseFont : int = 16;

		private var _html : XML;

		private var _title : String;

		private var documentBaseElement : Node;

		public function Document( w : int, h : int, assetManager : AssetManager )
		{
			super();

			this.name = "document";

			this.assetManager = assetManager;

			// width and hight
			graphics.beginFill( 0xDDDDDD, 1 );
			graphics.drawRect( 0, 0, w, h );
			graphics.endFill();

			var style : Object = ElementBase._defaultStyleObject;
			style[ "default" ].width = "100%";
			style[ "default" ].height = "100%";
			documentBaseElement = new Node( this, null, null, style );
			documentBaseElement.name = "_documentBaseElement";
			addChild( documentBaseElement );

			css = new CSS( w );

			parser = new Parser();

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

			loop( this );

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

			loop( documentBaseElement );

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

			loop( documentBaseElement );

			return results;
		}

		public function get html() : XML
		{
			return _html;
		}

		public function parseHTML( document : Document, target : Node, node : XML ) : void
		{
			_html = node;
			parser.addEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, handleParseComplete );
			parser.parseHTML( document, target, _html );
		}

		public function render( value : String ) : void
		{
			documentBaseElement.innerHTML = value;
		}

		public function resizeTo( width : int, height : int ) : void
		{
			graphics.beginFill( 0xDDDDDD, 1 );
			graphics.drawRect( 0, 0, width, height );
			graphics.endFill();

			documentBaseElement.updateDisplay();
		}

		public function get title() : String
		{
			return _title;
		}

		public function set title( value : String ) : void
		{
			if ( value != _title )
			{
				_title = value;
			}
		}

		protected function handleParseComplete( event : HTMLEvent ) : void
		{
			parser.removeEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, handleParseComplete );

			documentBaseElement.updateDisplay();

			dispatchEvent( event.clone());
		}
	}
}
