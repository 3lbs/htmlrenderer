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

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.text.StyleSheet;
	import flash.text.engine.FontLookup;
	import flash.text.engine.FontPosture;
	import flash.text.engine.GroupElement;
	import flash.text.engine.Kerning;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.container.ContainerController;
	import flashx.textLayout.container.ScrollPolicy;
	import flashx.textLayout.conversion.TextConverter;
	import flashx.textLayout.elements.TextFlow;
	import flashx.textLayout.events.CompositionCompleteEvent;
	import flashx.textLayout.events.UpdateCompleteEvent;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextJustify;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	import htmlrenderer.util.ElementUtil;
	import htmlrenderer.util.FontUtil;
	import htmlrenderer.util.HTMLUtils;
	
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

		private var textBitmap : Bitmap;

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

			textBitmap = new Bitmap();
			
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
				// dont do this! worse thing ever.  all fonts arent title cases!!!!
				// CSS return font name with quotes too. 
				//computedStyles.fontFamily = StringUtil.toTitleCase( computedStyles.fontFamily.split( "-" ).join( " " ));

				var FontLibrary : Class;
				var fontName : String = FontUtil.cleanFontName( computedStyles.fontFamily );

				//trace("fontname after cleaned: " + fontName );
				var fonts : Array = Font.enumerateFonts();

				for ( var i : int = 0; i < fonts.length; i++ )
				{

					//trace( "Embedded font: " + fonts[ i ].fontName );

					if ( String( fonts[ i ].fontName ).toLowerCase() == fontName.toLowerCase())
					{
						fontName = fonts[ i ].fontName;
					}
				}

				computedStyles.fontFamily = fontName;
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

		override protected function draw() : Boolean
		{
			removeChildren();

			if ( _computedStyles.hasOwnProperty( "display" ))
			{
				var display : String = _computedStyles.display;

				if ( display == "none" )
				{
					return super.draw();
				}
			}

			parse();

			if ( _computedStyles.hasOwnProperty( "textShadow" ))
			{
				var boxShadow : String = _computedStyles.textShadow;
				ElementUtil.drawShadow( boxShadow, textSprite );
			}

			return super.draw();
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
			//var impleText : String = _text;
			textFlow = TextConverter.importToFlow( impleText, TextConverter.TEXT_FIELD_HTML_FORMAT );

			hContainerFormat = new TextLayoutFormat();

			// wipe out the default inherits - format take precendence over CSS - this simplifies the example
			textFlow.format = null;

			
			textFlow.renderingMode = RenderingMode.CFF;
			textFlow.paddingTop = computedStyles.padding.top;
			textFlow.paddingBottom = computedStyles.padding.bottom;
			textFlow.paddingRight = computedStyles.padding.right;
			textFlow.paddingLeft = computedStyles.padding.left;
			textFlow.kerning = Kerning.ON;
			textFlow.fontSize = computedStyles.fontSize;
			textFlow.fontFamily = computedStyles.fontFamily;
			textFlow.fontLookup = FontLookup.EMBEDDED_CFF;
			textFlow.fontStyle = computedStyles.fontStyle;
			textFlow.fontWeight = computedStyles.fontWeight;
			textFlow.color = computedStyles.color;

			textFlow.textAlign = computedStyles.textAlign;
			textFlow.textAlignLast = TextAlign.LEFT;
			textFlow.textJustify = TextJustify.DISTRIBUTE;

			//hContainerFormat.textAlign = TextAlign.JUSTIFY;
			//hContainerFormat.textAlignLast = TextAlign.LEFT;
			//hContainerFormat.textJustify = TextJustify.INTER_WORD;

			//hContainerFormat.fontStyle = FontPosture.ITALIC;
			
			textFlow.addEventListener( CompositionCompleteEvent.COMPOSITION_COMPLETE, handleBuildComplete );
			textFlow.addEventListener( UpdateCompleteEvent.UPDATE_COMPLETE, handleUpdateComplete );

			textSprite = new Sprite();

			containerController = new ContainerController( textSprite, computedStyles.width, 800 );
			containerController.verticalScrollPolicy = ScrollPolicy.OFF;

			
			textSprite.mouseEnabled = false;
			textSprite.mouseChildren = false;
			
			// want to create a bitmapimage of it
			addChild( textSprite );

			containerController.format = hContainerFormat;
			// set it into the editor
			textFlow.flowComposer.addController( containerController );
			textFlow.flowComposer.updateAllControllers();

			//
			// lets try to use the elements and fuck the flow composer!
			//  print to bitmap
			//

			// not a bad idea
			/*var rect : Rectangle = containerController.getContentBounds();

			var bitmapData : BitmapData = new BitmapData( rect.width, rect.height, true, 0x0 );
			
			bitmapData.draw( textSprite );

			textBitmap.bitmapData = bitmapData;
			
			addChild( textBitmap );*/
			
			
			
			/*var fontDescription : FontDescription = new FontDescription();
			//fontDescription. = computedStyles.fontSize;
			fontDescription.fontName = computedStyles.fontFamily;
			fontDescription.fontLookup = FontLookup.EMBEDDED_CFF;
			fontDescription.fontWeight = computedStyles.fontWeight;
			//fontDescription.color = computedStyles.color;

			var elementFormat : ElementFormat = new ElementFormat( fontDescription );
			elementFormat.fontSize = computedStyles.fontSize;
			elementFormat.color = computedStyles.color;

			var paragraphElement : ParagraphElement = new ParagraphElement();
			var textLine : TextElement = new TextElement( _text, elementFormat );
			textLine.*/
			sizeHandler();

		}

		private function sizeHandler() : void
		{
			var rect : Rectangle = containerController.getContentBounds();
			computedStyles.height = rect.height;
		}
	}
}
