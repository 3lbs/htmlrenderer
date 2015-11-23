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

package htmlrenderer.parser.loader
{

	import flash.errors.IOError;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class FileStreamLoader extends Asset
	{
		private var fileStream : FileStream;

		private var str : String = "";
		
		public function FileStreamLoader( url : String )
		{
			super( url );
		}

		override public function get data() : *
		{
			return str;
		}

		override public function destroy() : void
		{

			super.destroy();
		}

		override public function start() : void
		{
			super.start();

			var file : File = new File ( url );
			
			try
			{
				fileStream = new FileStream();
				fileStream.open( file, FileMode.READ );

				str = fileStream.readUTFBytes( fileStream.bytesAvailable );
				fileStream.close();
			}
			catch ( error : IOError )
			{
				ioErrorHandler( file );
			}

			finished();
		}

		private function ioErrorHandler( file : File ) : void
		{
			// TODO Auto Generated method stub
			trace( "IoError: " + file.name + ", " + file.nativePath );
		}
	}
}
