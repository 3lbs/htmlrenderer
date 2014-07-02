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


	import totem.core.Destroyable;

	public class ScriptBase extends Destroyable
	{
		protected var document : Document;

		public function ScriptBase( d : Document )
		{
			document = d;
		}

		override public function destroy() : void
		{
			super.destroy();

			document = null;
		}

		public function onLoad() : void
		{

		}
	}
}
