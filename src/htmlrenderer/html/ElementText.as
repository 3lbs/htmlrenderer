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

	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.engine.FontLookup;
	import flash.text.engine.GroupElement;
	import flash.text.engine.Kerning;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.UpdateCompleteEvent;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import htmlrenderer.util.ElementUtil;
	import htmlrenderer.util.FontUtil;
	import htmlrenderer.util.HTMLUtils;
	
	import org.casalib.util.StringUtil;
	
	import totem.events.RemovableEventDispatcher;

	public class ElementText extends Node
	{

		public var totalLines : int;

		protected var _dispatcher : RemovableEventDispatcher = new RemovableEventDispatcher();

		protected var _groupElement : GroupElement

		protected var _text : String;

		private var _leading : Number = 1.25;

		private var _styleSheet : StyleSheet;

		private var containerController : ContainerController;

		private var hContainerFormat : TextLayoutFormat;

		private var textFlow : TextFlow;

		private var textSprite : Sprite;

		/**
		 *
		 *	@constructor
		 *	@param	txt	 	A String of text that is going twafg to be rendered
		 */
		public function ElementText( document : Document = null, element : Node = null, xml : XML = null, pStyle : Object = null )
		{
			super( document, element, xml, pStyle );

			_styleSheet = document.css.styleSheet;
			
		}

		// need to make this a system that can accept more than one block of text.
		public function addCData( text : String ) : void
		{
			this.text = text;
		}

		override public function destroy() : void
		{
			
			_styleSheet.clear();
			_styleSheet = null;

			
			textFlow = null;

			_groupElement = null;

			_dispatcher.destroy();
			_dispatcher = null;

			textSprite = null;

			super.destroy();
		}

		/**
		 *	@return	Returns the text applied to the Text object
		 */
		public function get text() : String
		{
			return _text;
		}

		/**
		 *	@param	value	Sets the text value of the Text object
		 */
		public function set text( value : String ) : void
		{
			if ( value !== _text && _rawStyle != null )
			{
				_text = value;
			}
		}

		override protected function cleanStyle( state : String = "default" ) : void
		{
			super.cleanStyle( state );

			computedStyles.fontSize = ( computedStyles.fontSize ) ? FontUtil.getFontSize( computedStyles.fontSize, document.baseFont ) : document.baseFont;

			if ( computedStyles.fontFamily != null )
			{
				computedStyles.fontFamily = StringUtil.toTitleCase( computedStyles.fontFamily.split( "-" ).join( " " ));
			}
			

			if ( computedStyles.fontWeight != null )
			{
				computedStyles.fontWeight = FontUtil.getFontWeight( computedStyles.fontWeight );
			}

			if ( computedStyles.lineHeight != null )
			{
				_leading = 1; //(  FontUtil.getFontSize( computedStyles.lineHeight, document.baseFont ) - ( computedStyles.fontSize || 12 ));
			}

			if ( computedStyles.color is String )
			{
				computedStyles.color = HTMLUtils.convertCSS_RGBColor( computedStyles.color );
			}

		}

		override protected function draw() : void
		{
			removeChildren();

			
			if ( _computedStyles.hasOwnProperty( "display" ))
			{
				var display : String = _computedStyles.display;
				if ( display == "none" )
				{
					super.draw();
					return;
				}
			}
			
			parse();

			if ( _computedStyles.hasOwnProperty( "textShadow" ))
			{
				var boxShadow : String = _computedStyles.textShadow;
				ElementUtil.drawShadow( boxShadow, textSprite );
			}

			super.draw();
		}

		protected function handleBuildComplete( event : CompositionCompleteEvent ) : void
		{

		}

		protected function handleUpdateComplete( event : UpdateCompleteEvent ) : void
		{

		}

		protected function parse() : void
		{

			var impleText : String = "<TextFlow xmlns='http://ns.adobe.com/textLayout/2008'>" + _text + "</TextFlow>"
			textFlow = TextConverter.importToFlow( impleText, TextConverter.TEXT_LAYOUT_FORMAT );

			hContainerFormat = new TextLayoutFormat();

			// wipe out the default inherits - format take precendence over CSS - this simplifies the example
			//textFlow.format = null;

			textFlow.renderingMode = RenderingMode.CFF;
			textFlow.paddingTop = computedStyles.padding.top;
			textFlow.paddingBottom = computedStyles.padding.bottom;
			textFlow.paddingRight = computedStyles.padding.right;
			textFlow.paddingLeft = computedStyles.padding.left;
			textFlow.kerning = Kerning.ON;
			textFlow.fontSize = computedStyles.fontSize;
			textFlow.fontFamily = computedStyles.fontFamily;
			textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
			textFlow.fontWeight = computedStyles.fontWeight;
			textFlow.color = computedStyles.color;

			textFlow.addEventListener( CompositionCompleteEvent.COMPOSITION_COMPLETE, handleBuildComplete );
			textFlow.addEventListener( UpdateCompleteEvent.UPDATE_COMPLETE, handleUpdateComplete );

			textSprite = new Sprite();

			containerController = new ContainerController( textSprite, computedStyles.width, 800 );
			containerController.verticalScrollPolicy = ScrollPolicy.OFF;

			addChild( textSprite );

			containerController.format = hContainerFormat;
			// set it into the editor
			textFlow.flowComposer.addController( containerController );
			textFlow.flowComposer.updateAllControllers();

			sizeHandler();

		}

		private function sizeHandler() : void
		{
			var rect : Rectangle = containerController.getContentBounds();
			computedStyles.height = rect.height;
		}
	}
}
