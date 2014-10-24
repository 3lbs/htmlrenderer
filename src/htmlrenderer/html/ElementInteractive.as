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

	import totem.display.ISWFObject;

	public class ElementInteractive extends ElementImage implements ISWFObject
	{
		public function ElementInteractive( document : Document = null, element : Node = null, xml : XML = null, pStyle : Object = null )
		{
			super( document, element, xml, pStyle );
		}

		override public function addEventListener( type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false ) : void
		{
			super.addEventListener( type, listener, useCapture, priority, useWeakReference );

			image.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}

		override public function set display( value : Boolean ) : void
		{
			ISWFObject( image ).display = value;
		}

		public function loadURL( value : String ) : void
		{
			ISWFObject( image ).loadURL( value );
		}

		override public function removeEventListener( type : String, listener : Function, useCapture : Boolean = false ) : void
		{
			super.removeEventListener( type, listener, useCapture );

			//image.removeEventListener( type, listener, useCapture );
		}

		public function unload() : void
		{
			ISWFObject( image ).unload();
		}
	}
}
