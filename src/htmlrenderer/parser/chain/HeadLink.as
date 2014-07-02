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

package htmlrenderer.parser.chain
{

	import flash.utils.getDefinitionByName;

	import htmlrenderer.html.ScriptBase;
	import htmlrenderer.parser.CSSLoadTreeNode;
	import htmlrenderer.parser.ParseTreeNode;
	import htmlrenderer.parser.loader.Asset;
	import htmlrenderer.parser.loader.AssetManager;
	import htmlrenderer.parser.loader.FontLoader;
	import htmlrenderer.parser.loader.SingleFileLoader;
	import htmlrenderer.util.FontUtil;
	import htmlrenderer.util.HTMLUtils;

	public class HeadLink extends BaseLink
	{

		public static var HEAD_ID : String = "headID";

		public function HeadLink( successor : BaseLink = null )
		{
			super( successor );
		}

		override public function handleRequest( request : String, treeNode : ParseTreeNode, node : XML = null ) : ParseTreeNode
		{

			if ( request == "head" )
			{
				var parseToken : CSSLoadTreeNode = new CSSLoadTreeNode( treeNode.document, treeNode.element, null );
				parseToken.id = HEAD_ID;

				var unloadedFonts : Array = [];

				var assetManager : AssetManager = treeNode.document.assetManager;
				var url : String;

				for each ( var xml : XML in node.children())
				{
					if ( xml.localName() == "link" )
					{
						url = HTMLUtils.cleanURL( xml.@href.toString());
						//var linkLoader : SingleFileLoader = new SingleFileLoader( url );
						url = treeNode.document.baseFile.resolvePath( url ).url;

						var cssLoader : Asset = assetManager.loadAsset( url, SingleFileLoader );

						parseToken.addLoader( cssLoader );
					}
					else if ( xml.localName() == "title" )
					{
						treeNode.document.title = xml.text();
					}
					else if ( xml.localName() == "script" )
					{
						var src : String = xml.@src.toString();

						if ( src.indexOf( FontUtil.FONT_TYPE_ADOBE ) > -1 )
						{
							var fontArray : Vector.<String> = getAdobeEdgeFontArray( src );

							for each ( var fontName : String in fontArray )
							{
								if ( !FontUtil.hasFont( fontName ))
								{
									unloadedFonts.push( fontName );
								}
							}
						}

						var asClass : String = xml.@asclass.toString();

						if ( asClass )
						{
							var clazz : Class = getDefinitionByName( asClass ) as Class;

							var script : ScriptBase = new clazz( treeNode.document );

							treeNode.document.addScript( script );

						}
					}
				}

				if ( unloadedFonts.length > 0 )
				{
					var fontFiles : Array = treeNode.document.fontURLFiles;

					for each ( url in fontFiles )
					{
						if ( !assetManager.hasAsset( url ))
						{
							var fontLoader : FontLoader = assetManager.loadAsset( url, FontLoader ) as FontLoader;
							fontLoader.fontNames = unloadedFonts;
							parseToken.addLoader( fontLoader );
								//fontLoader.start();
						}
					}
				}

				return parseToken;

			}

			return super.handleRequest( request, treeNode, node );
		}

		private function getAdobeEdgeFontArray( src : String ) : Vector.<String>
		{

			var fontArray : Array = src.slice( src.lastIndexOf( "/" ) + 1 ).split( ";" );

			var result : Vector.<String> = new Vector.<String>();

			for each ( var fontName : String in fontArray )
			{
				result.push( FontUtil.cleanFontName( fontName.slice( 0, fontName.indexOf( ":" ))));
			}

			return result;
		}
	}
}
