package ui.buttons
{
	import org.aswing.Icon;
	
	public class FileButton extends IconButton
	{
		private var supportedExtensions:Vector.<String> = new Vector.<String>(["avi","bmp","jpg","mp3","flv","png","pdf","ppt","doc","swf"])
		public function FileButton(text:String="", icon:Icon=null, w:uint=100, h:uint=120, clicFunction:Function=null)
		{
			super(text, icon, w, h, clicFunction);
		}
		
		public function setIconExtension(extention:String):void{
			//var 
			//switch
		}
	}
}