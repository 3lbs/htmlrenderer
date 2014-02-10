package htmlrenderer.parser.chain
{
	import htmlrenderer.parser.ParseTreeNode;

	public class HLink extends BaseLink
	{
		private var tags : Array = [ "h1", "h2", "h3", "h4", "h5", "h6" ];
		
		public function HLink(successor:BaseLink=null)
		{
			super(successor);
		}
		
		override public function handleRequest(request:String, treeNode:ParseTreeNode, node:XML=null):ParseTreeNode
		{
			
			if ( tags.indexOf( request ) > -1 )
			{
				trace("");
				
			}
			return super.handleRequest( request, treeNode, node );
		}
		
		/*
		// FORM TAG IS INSIDE OF FormTags.as
		
		//&lt;h1&gt;	 Specifies a heading level 1	 
		//http://www.w3schools.com/tags/html5_h1.asp
		public function h1( document : Document, target : Element, xml : XML ) : Object
		{
			var obj : Object = element( document, target, xml, BLOCK );
			obj.element.style.fontSize = 22;
			obj.element.style.fontWeight = "bold";
			return obj;
		}
		
		//&lt;h2&gt;	 Specifies a heading level 2	 
		//http://www.w3schools.com/tags/html5_h2.asp
		public function h2( document : Document, target : Element, xml : XML ) : Object
		{
			var obj : Object = element( document, target, xml, BLOCK );
			obj.element.style.fontSize = 20;
			obj.element.style.fontWeight = "bold";
			return obj;
		}
		
		//&lt;h3&gt;	 Specifies a heading level 3	 
		//http://www.w3schools.com/tags/html5_h3.asp
		public function h3( document : Document, target : Element, xml : XML ) : Object
		{
			var obj : Object = element( document, target, xml, BLOCK );
			obj.element.style.fontSize = 18;
			obj.element.style.fontWeight = "bold";
			return obj;
		}
		
		//&lt;h4&gt;	 Specifies a heading level 4	 
		//http://www.w3schools.com/tags/html5_h4.asp
		public function h4( document : Document, target : Element, xml : XML ) : Object
		{
			var obj : Object = element( document, target, xml, BLOCK );
			obj.element.style.fontSize = 16;
			obj.element.style.fontWeight = "bold";
			return obj;
		}
		
		//&lt;h5&gt;	 Specifies a heading level 5	 
		//http://www.w3schools.com/tags/html5_h5.asp
		public function h5( document : Document, target : Element, xml : XML ) : Object
		{
			var obj : Object = element( document, target, xml, BLOCK );
			obj.element.style.fontSize = 14;
			obj.element.style.fontWeight = "bold";
			return obj;
		}
		
		//&lt;h6&gt;	 Specifies a heading level 6	 
		//http://www.w3schools.com/tags/html5_h6.asp
		public function h6( document : Document, target : Element, xml : XML ) : Object
		{
			var obj : Object = element( document, target, xml, BLOCK );
			obj.element.style.fontSize = 12;
			obj.element.style.fontWeight = "bold";
			return obj;
		}
		*/
	}
}