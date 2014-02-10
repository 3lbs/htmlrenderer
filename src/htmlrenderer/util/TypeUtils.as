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

	public class TypeUtils
	{

		public static function cleanBoolean( value : * ) : Boolean
		{
			if ( value is String )
			{
				if ( value == "true" )
					return true;
				else
					return false;
			}
			else
				return value;
		}

		public static function cleanNumber( val : *, parentSize : Number ) : Number
		{
			if ( val is Number )
				return val as Number;
			else if ( val is String )
			{
				if ( isStringPercent( val as String ))
					return percentToNumber( val as String, parentSize );
				else if ( isStringFloat( val as String ))
					return parseFloat( val as String );
			}
			return Number( cleanString( val as String ));
		}

		public static function cleanString( val : String ) : *
		{
			if ( val == null )
				return null;
			
			if ( isStringHex( val ))
			{
				val = val.split( "#" ).join( "" ).split( "0x" ).join( "" );

				if ( val.length == 3 )
				{ // if 3 characters long handle like a 3 digit color
					var result : String = "";

					for ( var i : int = 0; i < 3; i++ )
					{
						result += val.charAt( i ) + val.charAt( i )
					}
					val = result;
				}
				return parseInt( val, 16 );
			}

			else if ( isStringInt( val ))
				return parseInt( val );

			else if ( isStringFloat( val ))
				return parseFloat( val );

			else if ( isStringBoolean( val ))
				return val.toLowerCase() == "true";

			return val
		}

		public static function isStringBoolean( val : String ) : Boolean
		{
			return ( val != null && ( val.toLowerCase() == "true" || val.toLowerCase() == "false" ))
		}

		public static function isStringFloat( val : String ) : Boolean
		{
			return ( val != null && val.search( /\d+/ ) > -1 && val.indexOf( "%" ) == -1 )
		}

		public static function isStringHex( val : String ) : Boolean
		{
			return ( val != null && ( val.substr( 0, 1 ) == "#" || val.substr( 0, 2 ) == "0x" ))
		}

		public static function isStringInt( val : String ) : Boolean
		{
			return ( val != null && val.search( /\d+/ ) > -1 && val.indexOf( "." ) == -1 && val.indexOf( "%" ) == -1 )
		}

		public static function isStringPercent( val : String ) : Boolean
		{
			return ( val != null && val.search( /\d+/ ) > -1 && val.indexOf( "%" ) != -1 )
		}

		public static function percentToNumber( val : String, parentSize : Number ) : Number
		{
			return parentSize * ( parseFloat( val ) * 0.01 )
		}

		public function TypeUtils()
		{
			super();
		}
	}
}

