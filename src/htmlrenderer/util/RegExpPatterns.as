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

package htmlrenderer.util
{

	public class RegExpPatterns
	{

		public static const getDelemitedNumbers : RegExp = /-?\d+(\.\d+)?/g;

		//number = /^-?[0-9]*\.?[0-9]+$/
		/**
		 * Test for the following color patterns
		 * rgba(153,248,204,0.65098)
		 * rgb(68, 199, 239)
		 * argb(3233, 432423, 32.343, 4323)
		 *
		 */
		public static const isRGBandA : RegExp = /^a?(?:rgb|hsl)a?/;

		public function RegExpPatterns()
		{
		}
	}
}
