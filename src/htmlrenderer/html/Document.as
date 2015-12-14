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
	import flash.filesystem.File;

	import htmlrenderer.event.HTMLEvent;
	import htmlrenderer.html.css.CSS;
	import htmlrenderer.html.position.AutoPositionLink;
	import htmlrenderer.html.position.PositionBaseLink;
	import htmlrenderer.html.position.Static2PositionLink;
	import htmlrenderer.parser.Parser;
	import htmlrenderer.parser.loader.AssetManager;
	import htmlrenderer.util.HTMLUtils;

	import totem.display.layout.TSprite;
	import totem.monitors.promise.wait;

	/**
	 *
	 * @author eddie
	 *
	 */
	public class Document extends TSprite
	{

		public var assetManager : AssetManager;

		public var baseFile : File;

		public var contentHeight : int;

		public var contentWidth : int;

		public var css : CSS;

		public var fontURLFiles : Array;

		public var layoutPosition : PositionBaseLink;

		public var onload : String;

		public var parser : Parser;

		public var properties : Object = new Object();

		public var scriptLoc : String = "";

		private var _baseFont : int = 10;

		private var _html : XML;

		private var _interactive : Boolean;

		private var _title : String;

		private var documentBaseElement : Node;

		private var scripts : Vector.<ScriptBase> = new Vector.<ScriptBase>();

		public function Document( w : int, h : int, assetManager : AssetManager )
		{
			super();

			this.name = "document";

			this.assetManager = assetManager;

			// width and hight
			graphics.beginFill( 0xDDDDDD, 1 );
			graphics.drawRect( 0, 0, w, h );
			graphics.endFill();

			contentWidth = w;
			contentHeight = h;

			var style : Object = HTMLUtils.cloneObject( ElementBase._defaultStyleObject );
			style[ "default" ].width = "100%";
			style[ "default" ].height = "100%";
			documentBaseElement = new Node( this, null, null, style );
			documentBaseElement.name = "_documentBaseElement";
			addChild( documentBaseElement );

			documentBaseElement.addEventListener( HTMLEvent.DRAW_COMPLETE_EVENT, handleDrawCompleteEvent );

			css = new CSS( w );

			parser = new Parser();

			var autoPosition : AutoPositionLink = new AutoPositionLink();
			var staticPostion : Static2PositionLink = new Static2PositionLink( autoPosition );
			layoutPosition = staticPostion;

		}

		public function addScript( script : ScriptBase ) : void
		{
			scripts.push( script );
		}

		public function get baseFont() : int
		{
			return _baseFont;
		}

		public function set baseFont( value : int ) : void
		{
			_baseFont = value;
		}

		override public function destroy() : void
		{
			parser.destroy();
			parser = null;

			_html = null;

			while ( scripts.length )
				scripts.pop().destroy();

			scripts = null;

			documentBaseElement.destroy();
			documentBaseElement = null;
			super.destroy();
		}

		public function set display( value : Boolean ) : void
		{
			documentBaseElement.display = value;
		}

		public function getElementById( id : String ) : ElementBase
		{
			var result : ElementBase;
			function loop( target : DisplayObjectContainer ) : void
			{
				var length : int = target.numChildren;
				var i : uint;
				var child : *;

				for ( i = 0; i < length; i++ )
				{
					child = target.getChildAt( i );

					if ( child is DisplayObjectContainer && child is ElementBase )
					{
						var check : DisplayObject = child.getChildByName( id );

						if ( check != null )
						{
							result = check as ElementBase;
							break;
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

		public function get interactive() : Boolean
		{
			return _interactive;
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

		public function update() : void
		{
			documentBaseElement.updateDisplay();
		}

		protected function handleDrawCompleteEvent( event : HTMLEvent ) : void
		{
			wait( 10, handleDelay, event );
		}

		protected function handleParseComplete( event : HTMLEvent ) : void
		{
			parser.removeEventListener( HTMLEvent.PARSE_COMPLETE_EVENT, handleParseComplete );

			if ( onload )
			{
				var i : int = scripts.length;

				while ( i-- )
				{
					var sc : ScriptBase = scripts[ i ];

					var func : String = onload.match( /\w+/g )[ 0 ];

					if ( sc.hasOwnProperty( func ))
					{
						sc[ func ].call();
					}
				}
			}
			//onload();

			trace( "parsed all content!!!" );

			documentBaseElement.updateDisplay();

			wait( 10, handleDelay, event );
		}

		private function handleDelay( event : HTMLEvent ) : void
		{
			dispatchEvent( event.clone());
		}
	}
}
