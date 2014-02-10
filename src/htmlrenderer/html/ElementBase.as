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

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import htmlrenderer.parser.loader.AssetManager;
	import htmlrenderer.parser.loader.ImageLoader;
	import htmlrenderer.util.ElementUtil;
	import htmlrenderer.util.HTMLUtils;
	import htmlrenderer.util.TypeUtils;
	
	import totem.display.layout.TSprite;
	import totem.math.MathUtils;

	public class ElementBase extends TSprite
	{

		public static const BOTTOM : String = "bottom";

		public static const DEFAULT : String = "default";

		public static const HEIGHT : String = "height";

		public static const LEFT : String = "left";

		public static const MIDDLE : String = "middle";

		public static const RIGHT : String = "right";

		public static const TOP : String = "top";

		public static const WIDTH : String = "width";

		public var _currentState : String = DEFAULT;

		public var document : Document

		public var floatedLeft : Vector.<ElementBase> = new Vector.<ElementBase>();

		public var floatedNone : Vector.<ElementBase> = new Vector.<ElementBase>();

		public var floatedRight : Vector.<ElementBase> = new Vector.<ElementBase>();

		// ,"height", "width" // it should be draw the width and height so you dont need to define this
		public var index : int;

		public var parentElement : ElementBase;

		protected var _computedStyles : Object;

		protected var style : Object;

		private const BASE_PROPERTIES : Array = [ LEFT, TOP, WIDTH, HEIGHT ];

		private var _allStyles : Object = null;

		private var _childrenElementList : Vector.<ElementBase>;

		private var _defaultStyleObject : Object = { "default": { left: 0, top: 0, width: "100%", height: 0, position: "auto", background: { type: "none", alpha: 1 }, border: { type: "none", shape: "box",
						left: 0, right: 0, top: 0, bottom: 0 }, margin: { left: 0, right: 0, top: 0, bottom: 0 }, padding: { left: 0, right: 0, top: 0, bottom: 0 }}};

		private var _elementRect : Rectangle = new Rectangle();

		private var dirty : Boolean;

		private var displayDirty : Boolean;

		private var imageMask : Sprite;

		private var images : Array = new Array();

		public function ElementBase( styles : Object = null, events : Object = null )
		{
			super();

			_allStyles = styles || _defaultStyleObject;

			style = _allStyles[ _currentState ];
		}

		public function addElement( child : ElementBase ) : ElementBase
		{
			if ( child.computedStyles.hasOwnProperty( "float" ))
			{
				if ( child.computedStyles.float == "left" )
				{
					floatedLeft.push( child );
				}
				else if ( child.computedStyles.float == "right" )
				{
					floatedRight.push( child );
				}
				else
				{
					// else not floated
					floatedNone.push( child );
				}
			}
			else
			{
				floatedNone.push( child );
			}

			child.parentElement = this;
			dirty = true;
			addChild( child );
			return child;
		}

		public function calculateSize( val : String, parentSize : Number ) : Number
		{

			if ( val == "auto" )
			{
				return 0;
			}
			else if ( val == "inherit" )
			{
				return parentSize;
			}

			return TypeUtils.cleanNumber( val, parentSize )
		}

		public function get childrenElements() : Vector.<ElementBase>
		{
			if ( !_childrenElementList || dirty )
			{
				_childrenElementList = floatedRight.concat( floatedLeft ).concat( floatedNone );
				_childrenElementList.sort( sortingFunction );
				dirty = false;
			}
			return _childrenElementList;
		}

		public function get computedStyles() : Object
		{
			if ( _computedStyles == null )
			{
				_computedStyles = HTMLUtils.cloneObject( _allStyles[ _currentState ]);
			}
			return _computedStyles;
		}

		public function get currentState() : String
		{
			return _currentState;
		}

		public function set currentState( value : String ) : void
		{
			if ( _currentState !== value )
			{
				_currentState = value;
			}
		}

		override public function destroy() : void
		{
			parentElement = null;

			document = null;

			_allStyles = null;

			_currentState = DEFAULT;

			_computedStyles = null;

			style = null;

			while ( images.length )
				images.pop();

			while ( _childrenElementList.length )
				_childrenElementList.pop().destroy();

			super.destroy();
		}

		public function draw() : void
		{
			graphics.clear();

			if ( _computedStyles.hasOwnProperty( "mask" ))
			{
				mask = parent.getChildByName( _computedStyles.mask );
			}

			if ( _computedStyles.hasOwnProperty( "hitArea" ))
			{
				hitArea = parent.getChildByName( _computedStyles.hitArea ) as Sprite;
			}
			// Draw eveything
			drawBorder();
			graphics.endFill();

			if ( _computedStyles.hasOwnProperty( "boxShadow" ))
			{
				var boxShadow : String = _computedStyles.boxShadow;
				ElementUtil.drawShadow( boxShadow, this );
			}

			if ( _computedStyles.hasOwnProperty( "scrollRect" ))
			{
				var scrollArr : Array = _computedStyles.scrollRect.split( "," );
				scrollRect = new Rectangle( parseFloat( scrollArr[ 0 ]), parseFloat( scrollArr[ 1 ]), parseFloat( scrollArr[ 2 ]), parseFloat( scrollArr[ 3 ]));
			}

			if ( _computedStyles.hasOwnProperty( "scale9Grid" ))
			{
				var scaleArr : Array = _computedStyles.scale9Grid.split( "," );
				scale9Grid = new Rectangle( parseFloat( scaleArr[ 0 ]), parseFloat( scaleArr[ 1 ]), parseFloat( scaleArr[ 2 ]), parseFloat( scaleArr[ 3 ]));
			}

			if ( _computedStyles.hasOwnProperty( "overflow" ) && _computedStyles.overflow != "visible" && _computedStyles.overflow != "auto" )
			{
				scrollRect = new Rectangle( 0, 0, _computedStyles.width, _computedStyles.height );
			}

			if ( _computedStyles.visibility == "hidden" )
			{
				this.visible = false;
			}

			if ( _computedStyles.opacity )
			{
				this.alpha = parseFloat( _computedStyles.opacity );
			}
		}

		public function get elementRect() : Rectangle
		{
			return _elementRect;
		}

		public function placeRect() : void
		{
			this.x = _elementRect.x = _computedStyles.left;
			this.y = _elementRect.y = _computedStyles.top;

			_elementRect.width = _computedStyles.width;
			_elementRect.height = _computedStyles.height;
		}

		public function get rawStyle() : Object
		{
			return style;
		}

		public function updateDisplay() : void
		{
			cleanStyle();

			draw();

			// sort and position children
			for each ( var childElement : ElementBase in childrenElements )
			{
				if ( childElement is ElementBase )
				{
					childElement.updateDisplay();
				}
			}

			document.layoutPosition.handleRequest( this );
			// draw again?

			render();
		}

		protected function cleanStyle( state : String = "default" ) : void
		{
			_computedStyles = HTMLUtils.cloneObject( _allStyles[ _currentState ]);

			for each ( var prop : String in BASE_PROPERTIES )
			{

				if ( _computedStyles[ prop ] is String && isNaN( _computedStyles[ prop ]))
				{
					var w : *;
					var h : *;

					if ( parentElement )
					{
						w = parentElement.computedStyles.width;
						h = parentElement.computedStyles.height;
					}
					else
					{
						// this is frame level 
						w = parent.parent.width;
						h = parent.parent.height;
					}

					if ( prop == "x" || prop == WIDTH )
					{
						_computedStyles[ prop ] = calculateSize( _computedStyles[ prop ], w );
					}
					else
					{
						_computedStyles[ prop ] = calculateSize( _computedStyles[ prop ], h );
					}

				}
				else if ( _computedStyles[ prop ] == null )
				{
					_computedStyles[ prop ] = 0;
				}
			}
		}

		protected function handleBackgroundLoaded( event : Event ) : void
		{
			IEventDispatcher( event.target ).removeEventListener( Event.COMPLETE, handleBackgroundLoaded );

			graphics.clear();
			drawBorder();
			graphics.endFill();

			addMask();

		}

		private function addMask() : void
		{

			if ( images.length )
			{

				imageMask ||= new Sprite();
				imageMask.graphics.clear();
				imageMask.graphics.copyFrom( this.graphics );

				for each ( var image : DisplayObject in images )
				{
					image.mask = imageMask;
				}

				addChildAt( imageMask, 1 );
			}
		}

		private function drawBackground() : void
		{
			if ( _computedStyles.background == null )
				_computedStyles.background = {};

			if ( _computedStyles.background.gradient )
			{
				gradient();
			}
			else if ( _computedStyles.background.color )
			{
				solid();
			}

			if ( _computedStyles.background.url )
			{
				image();
			}

		}

		private function drawBorder() : void
		{
			// left right top bottom
			var border : Object = _computedStyles.border;

			if ( border != null )
			{
				// This only supports solid borders for now
				if ( border.weight && border.weight > 0 )
				{
					graphics.lineStyle( border.weight, border.color || 0x000000, border.alpha || 1 );
				}

				graphics.beginFill( border.color || 0, border.alpha );

				if ( border.top && border.right && border.bottom && border.left )
				{
					drawShape( 0, 0, _computedStyles.width, _computedStyles.height );
				}
				// shape
				drawBackground();
				drawShape( border.left, border.top, _computedStyles.width - border.left - border.right, _computedStyles.height - border.top - border.bottom );
			}
		}

		private function drawShape( x : Number, y : Number, width : Number, height : Number ) : void
		{
			if ( _computedStyles.border.shape == null || _computedStyles.border.shape == "box" || _computedStyles.border.shape == "Rect" )
			{
				graphics.drawRect( x, y, width, height );
			}
			else if ( _computedStyles.border.shape == "Ellipse" )
			{
				graphics.drawEllipse( x, y, width, height );
			}
			else if ( _computedStyles.border.shape == "RoundRect" )
			{
				graphics.drawRoundRect( x, y, width, height, _computedStyles.border.radius, _computedStyles.border.radius );
			}
			else if ( _computedStyles.border.shape == "RoundRectComplex" )
			{
				graphics.drawRoundRectComplex( x, y, width, height, _computedStyles.border.topLeftRadius, _computedStyles.border.topRightRadius, _computedStyles.border.bottomLeftRadius, _computedStyles.border.bottomRightRadius );
			}
		}

		private function gradient() : void
		{
			var _gradient : Object = _computedStyles.background.gradient;

			var matrix : Matrix = new Matrix();
			matrix.createGradientBox( _computedStyles.width, _computedStyles.height, _gradient.direction * MathUtils.DEG_TO_RAD );

			graphics.beginGradientFill( GradientType.LINEAR, _gradient.colors, _gradient.alphas, _gradient.stops, matrix );
		}

		private function image() : void
		{
			var url : String = _computedStyles.background.url;

			if ( _computedStyles.height == "auto" || _computedStyles.height == 0 )
				return;

			var assetLoader : AssetManager = document.assetManager;
			var bitmapLoader : ImageLoader = assetLoader.getAsset( url ) as ImageLoader;
			var bitmapData : BitmapData;

			if ( bitmapLoader )
			{

				bitmapData = bitmapLoader.bitmapData;
				var matrix : Matrix = getImageMatrix( _computedStyles.background, bitmapData.width, bitmapData.height );

				if ( _computedStyles.background.repeat == false )
				{
					var bitmap : Bitmap = new Bitmap( bitmapData );
					bitmap.transform.matrix = matrix;

					images.push( bitmap );
					addChildAt( bitmap, 0 );
				}
				else
				{
					graphics.beginBitmapFill( bitmapData, matrix, _computedStyles.background.repeat );
				}
			}
			else
			{
				bitmapLoader = assetLoader.loadAsset( url, ImageLoader ) as ImageLoader;
				bitmapLoader.addEventListener( Event.COMPLETE, handleBackgroundLoaded );
				bitmapLoader.start();
			}

		}

		private function getImageMatrix( background : Object, imageWidth : Number, imageHeight : Number ) : Matrix
		{
			var matrix : Matrix = new Matrix();
			
			var tw : Number = _computedStyles.width - imageWidth;
			var th : Number = _computedStyles.height - imageHeight; 
			matrix.tx = TypeUtils.cleanNumber( background.x || 0, tw );
			matrix.ty = TypeUtils.cleanNumber( background.y || 0, th );

			var scale : Number = 1;

			if ( background.hasOwnProperty( "width" ) && !isNaN( background.width ) )
			{
				scale = background.width / imageWidth;
			}
			matrix.scale( scale, scale );

			return matrix;
		}

		private function render() : void
		{
			if ( _computedStyles.height == 0 || _computedStyles.height == "auto" )
			{
				_computedStyles.height = Math.max( this.height, parentElement.computedStyles.height );
				draw();
			}

			addMask();
		}

		private function solid() : void
		{
			if ( _computedStyles.background.color == null )
			{
				_computedStyles.background.color = uint( Math.random() * 0xFFFFFF )
			}

			graphics.beginFill( _computedStyles.background.color, _computedStyles.background.alpha || 1 );
		}

		private function sortingFunction( itemA : ElementBase, itemB : ElementBase ) : Number
		{
			if ( itemA.index < itemB.index )
				return -1; //ITEM A is before ITEM B
			else if ( itemA.index > itemB.index )
				return 1; //ITEM A is after ITEM B
			else
				return 0; //ITEM A and ITEM B have same date
		}
	}
}
