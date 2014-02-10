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

package htmlrenderer.html.css
{

	import totem.core.Destroyable;

	public class MediaBlockStyle extends Destroyable
	{

		public var max_width : Number;

		public var name : String;

		private var styleSheet : StylesBase;

		public function MediaBlockStyle()
		{
		}

		override public function destroy() : void
		{
			super.destroy();

			styleSheet.clear();
			styleSheet = null;
		}

		public function getStyle( styleName : String ) : Object
		{
			return styleSheet.getStyle( styleName );
		}

		public function hasStyle( styleName : String ) : Boolean
		{
			return styleSheet.styleNames.indexOf( styleName ) > -1;
		}

		public function parseCSS( css : String ) : void
		{
			styleSheet = new StylesBase();

			try
			{
				styleSheet.parseCSS( css );
			}
			catch ( er : Error )
			{
				throw new Error( er.message, er.errorID );
			}
		}
	}
}
