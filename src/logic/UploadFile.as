package logic
{
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.FileReferenceList;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import org.aswing.AsWingManager;
	
	import ui.windows.AlertWindow;

	public class UploadFile
	{
		private static var _strUploadScript:String = "http://localhost/server2/fileUpload.php"
		//private static var _arrUploadFiles:DataProvider;
		
		private var _refAddFiles:FileReferenceList;
		private var _refUploadFile:FileReference;
		private var _currentFile:uint;
		public var dp:Array;
		private var _closeFunction:Function
		
		//private static
		
		public function UploadFile(closeFunction:Function,browseFile:Boolean=true):void
		{
			_closeFunction  = closeFunction;
			if(browseFile){
				_refAddFiles = new FileReferenceList();
				_refAddFiles.addEventListener(Event.SELECT, onSelectFile);
				_refAddFiles.browse([new FileFilter("Fichiers autorisés","*.PDF;*.pdf;*.jpg;*.JPG;*.png;*.PNG;*.gif;*.GIF;*.doc;*.docx;*.xls;*.xlsx;*.ppt;*.pptx;*.flv;*.txt")]);	
			}
			
		}
		
		private function onSelectFile(event:Event):void
		{
			dp = new Array();
			
			for (var i:uint = 0; i<_refAddFiles.fileList.length; i++)
			{
				var element:FileReference = _refAddFiles.fileList[i];
				var myPattern1:RegExp = /_/gi;
				var myPattern2:RegExp = / /gi;
				var tags:String = element.name.substring(0,element.name.lastIndexOf(".")).replace(myPattern2," | ").replace(myPattern1," | ");
				dp.push({name:element.name,target:element.name,data:element,Nom:element.name,Taille:Math.ceil(element.size/1024)+" Ko",Tags:tags,Statut:"En attente"});
				
			}
			trace("start upload "+dp.length);
			new AlertWindow("Upload de fichiers",{progress:true,width:320,height:100})
			startUpload(true)
		}

		private function startUpload(start:Boolean):void
		{
			
			if (start)
			{
				_currentFile = 0
				
			}
			_currentFile++;
			AlertWindow.listAlerts[AlertWindow.listAlerts.length-1].setProgress(0,"Chargement du fichier "+_currentFile+" sur "+dp.length);
			trace("start "+_currentFile)
			_refUploadFile = dp[0].data;
			var sendVars:URLVariables = new URLVariables();
			sendVars.id = (AsWingManager.getRoot() as Main).id
			sendVars.pass = (AsWingManager.getRoot() as Main).pass
			sendVars.type = "media"
			var request:URLRequest = new URLRequest();
			request.data = sendVars;
			request.url = ServerFunctions.getFileScript();
			request.method = URLRequestMethod.POST;
			request.contentType = "multipart/form-data";

			_refUploadFile.addEventListener(ProgressEvent.PROGRESS, onUploadProgress);
			_refUploadFile.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onUploadComplete)
			_refUploadFile.addEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
			_refUploadFile.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
			_refUploadFile.upload(request,"file");
		}
		
		
		// Get upload progress
		private function onUploadProgress(event:ProgressEvent):void
		{
			var numPerc:uint = Math.round((Number(event.bytesLoaded) / Number(event.bytesTotal)) * 100);
			AlertWindow.listAlerts[AlertWindow.listAlerts.length-1].setProgress(numPerc);
			
			
		}
		
		// Called on upload complete
		private function onUploadComplete(evt:DataEvent):void
		{
			trace("complete "+_currentFile+" "+evt.data)
			dp.shift();
			if (dp.length > 0)
			{
				startUpload(false);
			}
			else
			{
				var window:AlertWindow = AlertWindow.getLast()
				window.setProgress(100,"Chargement des fichiers terminé, clic pour fermer");
				window.addEventListener(MouseEvent.CLICK,close);
				clearUpload();
				
			}
		}
		
		private function close(evt:Event):void{
			var window:AlertWindow = evt.currentTarget as AlertWindow;
			window.removeEventListener(MouseEvent.CLICK,close);
			window.dispose()
			_closeFunction()
		}
		
		// Called on upload io error
		private function onUploadIoError(event:IOErrorEvent):void
		{
			trace("IOError "+event.toString())
			//_refUploadFile.cancel();
			clearUpload();
		}
		
		// Called on upload security error
		private function onUploadSecurityError(event:SecurityErrorEvent):void
		{
			trace("SecurityError")
			_refUploadFile.cancel();
			clearUpload();
		}
		
		private function clearUpload():void
		{
			_refUploadFile.removeEventListener(ProgressEvent.PROGRESS, onUploadProgress);
			_refUploadFile.removeEventListener(DataEvent.UPLOAD_COMPLETE_DATA, onUploadComplete);
			_refUploadFile.removeEventListener(IOErrorEvent.IO_ERROR, onUploadIoError);
			_refUploadFile.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onUploadSecurityError);
			//_refUploadFile.cancel();
		}
	}
}