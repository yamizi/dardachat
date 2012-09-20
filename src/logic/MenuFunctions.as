package logic
{
	import flash.events.Event;
	
	import org.aswing.AsWingManager;

	public class MenuFunctions
	{
		public function MenuFunctions()
		{
		}
		
		public static function insertText(evt:Event):void{
			var workspace:Workspace = (AsWingManager.getRoot() as Main).getWorkspace()
				workspace.addElement("text",{position:null,size:null});
		}
		
		public static function insertFormula(evt:Event):void{
			var workspace:Workspace = (AsWingManager.getRoot() as Main).getWorkspace()
			//workspace.addElement("text",{position:null,size:null});
		}
		
		public static function insertVideo(evt:Event):void{
			var workspace:Workspace = (AsWingManager.getRoot() as Main).getWorkspace()
			workspace.addElement("video",{position:null,size:null});
		}
		
		public static function insertImage(evt:Event):void{
			var workspace:Workspace = (AsWingManager.getRoot() as Main).getWorkspace()
			workspace.addElement("image",{position:null,size:null});
		}
		
		public static function insertSwf(evt:Event):void{
			var workspace:Workspace = (AsWingManager.getRoot() as Main).getWorkspace()
			workspace.addElement("swf",{position:null,size:null});
		}
		
		/*public static function insertText(evt:Event):void{
			var workspace:Workspace = (AsWingManager.getRoot() as Main).getWorkspace()
			workspace.addElement("text",{position:null,size:null});
		}*/
		
		public static function saveDocument(evt:Event):void{
			Serialization.serializeDocument((AsWingManager.getRoot() as Main).getWorkspace());
		}
		
		public static function openDocument(evt:Event):void{
			var serialization:Serialization = new Serialization() 
			serialization.loadFile()
			//Serialization.unserializeDocument((AsWingManager.getRoot() as Main).getWorkspace());
		}
	}
}