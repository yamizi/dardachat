package logic
{
	import Components.Element;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	import org.aswing.AsWingManager;
	
	import ui.windows.AlertWindow;
	import ui.windows.InputWindow;
	
	public class Serialization
	{
		
		private static var filename:String;
		private static var _data:Object;
		private static var _byteArray:Boolean
		private var fileRef:FileReference = new FileReference();
		
		
		public function Serialization()
		{

		}
	
	
		public static function serializeDocument(workSpace:Workspace,byteArray:Boolean = false):void{
			var serializedDocument:Array = new Array();
			var content:Sprite = workSpace.getChildAt(0) as Sprite;
			var serializedWorkspace:Array = new Array();
			//registerClassAlias("Vector", Vector);
			for (var i:int = content.numChildren-1;i>=0;i--){
				var element:Element = content.getChildAt(i) as Element;
				if(element.visible){
					serializedWorkspace.push(element.getProperties());	
				}
				
			} 
			
			
			trace("sauvegarde d'éléments")
			trace("nombres d'éléments du workspace: "+serializedWorkspace.length);
		
			serializedDocument.push(serializedWorkspace);
			
			var serializedAnimation:Array = AnimationManager.getElementsId().toArray()
			trace("sauvegarde des animations")
			trace("nombres d'éléments de l'animation: "+serializedAnimation.length);
			serializedDocument.push(serializedAnimation);
			
			_byteArray = byteArray;
			
			if(_byteArray){
				var ba:ByteArray = new ByteArray();
				ba.writeObject(serializedDocument);
				ba.compress();
				_data =ba
			}
			else{
				_data =serializedDocument
					
			}
			/*var fileRef:FileReference = new FileReference();
			fileRef.save(ba,"projet1.prj");
			
			var fileRef1:FileReference = new FileReference();
			var tileSet:ByteArray = PNGEncoder.encode(bmpData);
			fileRef1.save(tileSet,"tileSet.png");*/
			var main:Main = AsWingManager.getRoot() as Main;
			new InputWindow("Nommer le fichier",{submitMessage:"Nom du fichier:",submitFunction:Serialization.save,submitText:main.fileName});
		}
		
		public static function save(txt:String):void{
			var main:Main = AsWingManager.getRoot() as Main;
			main.fileName = txt+" [Sauvegardé]";
			ServerFunctions.addFile(txt,_data,"prez",Serialization.onSaved,Serialization.onError,"private",_byteArray);
			var window:AlertWindow = AlertWindow.getLast()
			window.dispose()
			new AlertWindow("Enregistrement du fichier...",{progress:true,width:320,height:100})
		}
		
		public static function onSaved(tbl:Array):void{
			trace("onSAVED "+tbl.join("\n")); 
			if(tbl && tbl[0]){
				trace("save success")
				//_message.setText("Message Enregitré sur le serveur");
				var window:AlertWindow = AlertWindow.getLast()
				window.dispose()
			}
		}
		
		public static function onError(error:Object):void{
			trace("serialization error");
			for(var a:String in error){
				trace(error[a])
			}
			//_message.setText("Erreur:");
			var window:AlertWindow = AlertWindow.getLast()
			window.dispose()
			
		}
		
		public function loadFile():void{
			
			fileRef.addEventListener(Event.SELECT,onFile_Selected);
			fileRef.browse([new FileFilter("Projet Collab","*.prj"),new FileFilter("Tous les fichiers","*.*")]);
				
		}
		
		private function onFile_Selected(evt:Event):void{
			//var fileRef:FileReference = evt.target as FileReference;
			fileRef.addEventListener(Event.COMPLETE,onFile_Loaded);
			fileRef.removeEventListener(Event.SELECT,onFile_Selected);
			//fileRef.addEventListener(HTTPStatusEvent.HTTP_RESPONSE_STATUS,eve);
			fileRef.addEventListener(HTTPStatusEvent.HTTP_STATUS,eve);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR,eve);
			fileRef.addEventListener(ProgressEvent.PROGRESS,eve)
			trace("selected "+fileRef.name)
			fileRef.load()
		}
		
		private  function onFile_Loaded(evt:Event):void{
			//var fileRef:FileReference = evt.target as FileReference;
			fileRef.removeEventListener(Event.COMPLETE,onFile_Loaded);
			trace("loaded")
			(AsWingManager.getRoot() as Main).loadContent(unserializeDocument(fileRef.data));
		}
		
		public static function unserializeDocument(ba:ByteArray):Vector.<Object>{
			//ba.uncompress();
			ba.position = 0;
			var unserializedWorkspace:Vector.<Object> = ba.readObject() as Vector.<Object>;
			trace("num element "+unserializedWorkspace[0]);
			//(AsWingManager.getRoot() as Main).loadContent(unserializedWorkspace);
			return unserializedWorkspace ;
		}
		
		public static function eve(evt:*):void{
			trace("--"+evt);
		}
	}
}