package logic
{
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	import flash.system.Capabilities;
	import flash.utils.ByteArray;
	
	import org.aswing.AbstractButton;
	import org.aswing.AsWingManager;
	
	import ui.windows.AlertWindow;

	public class ServerFunctions
	{
		
		
		private static var _localPath:String = "http://localhost/WorkSpace/Main/bin-debug/server/"
		private static var _remotePath:String = "www.prepa-inpg.fr/Collaboration/server/";
		private static var _filePath:String = "services/Prez/filesManager.php";
		public static var remoting_connection:NetConnection = new NetConnection()
		private static var statusWindow:AlertWindow;
		private static var mainScript:String = "Prez.MainServer.";
		//private static var successCallback:Function;
		//private static var errorCallback:Function;
			
		public function ServerFunctions()
		{
		}
		
		public static function init():void{
			if(!remoting_connection.hasEventListener(NetStatusEvent.NET_STATUS)){
				remoting_connection.addEventListener(NetStatusEvent.NET_STATUS,ServerFunctions.onNetStatusEvent);
				remoting_connection.addEventListener(IOErrorEvent.IO_ERROR,onRemoting_Failure)
				remoting_connection.addEventListener(AsyncErrorEvent.ASYNC_ERROR,onRemoting_Failure);
				remoting_connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onRemoting_Failure)
				remoting_connection.objectEncoding = ObjectEncoding.AMF3;
				
				//RETIRER GATEWAY.PHP POUR AMFPHP2
				var serverPath:String = ServerFunctions.getServer_Path()+"gateway.php";
				trace("serveur "+serverPath)
				remoting_connection.close()
				remoting_connection.connect(serverPath);
				/*var responder:Responder = new Responder(ServerFunctions.onConnected,ServerFunctions.onRemoting_Failure);
				remoting_connection.call("ExampleService.returnOneParam",responder,"txt");
				*/
			}
			
			
			
		}
		
		public static function getFileScript():String{
			return getServer_Path()+_filePath
		} 
		
		
		public static function getAppPath():String{
			return _localPath;
		}
		
		public static function connect(id:String,password:String):void{
			init()
			trace("called")
			
			if(remoting_connection){
				trace("server reached")
				try
				{	
					var responder:Responder = new Responder(ServerFunctions.onConnected,ServerFunctions.onRemoting_Failure);
					remoting_connection.call(mainScript+"logOn",responder,id,password);
					trace("connection en cours "+ServerFunctions.mainScript+"logOn")
					statusWindow = new AlertWindow("Connexion au serveur",{height:80,paddingTop:165,width:200,message:"Veuillez patienter\nIdentification en cours..."});
					
				}
				catch(e:Error){
					onRemoting_Failure("Erreur connection "+e)
					var msg:String = "Une erreur est survenue lors de la connexion.\nDetails:"+e.toString();
					statusWindow = new AlertWindow("Erreur de connexion",{message:msg});
				}
			}
		}

		private static function onConnected(data:Array):void{
			trace("=>"+data.join("*"))
			if(data[0]){
				trace("success");
				statusWindow.dispose();
				var home:Main = (AsWingManager.getRoot() as Main)
				home.login = data[1];
				home.pass = data[2];
				home.id = data[3]
				home.initHome()
			    
			}
		}
		
		
		public static function getFiles(criteres:Object,successCallback:Function,errorCallback:Function):void{
			try
			{	
				trace("statut "+remoting_connection.connected)
				//init()
				var main:Main = AsWingManager.getRoot() as Main;
				var responder:Responder = new Responder(successCallback,errorCallback);
				trace("get Files")
				//remoting_connection.call(ServerFunctions.mainScript+"Prez.MainServer.getFiles",responder,main.id,main.pass,criteres);
				remoting_connection.call(ServerFunctions.mainScript+"getFiles_ext",responder,main.id,main.pass,criteres.type,criteres.order,criteres.number);
			}
			catch(e:Error){
				errorCallback("Erreur Connexion");
				trace("error files")
			}	
		}
		
		
		private static function filesReceived(files:Array):void{
			trace("num files "+files.length);
		}
		
		public static function addFile(filename:String,data:Object,extension:String,successCallback:Function,errorCallback:Function,type:String="media",byteArray:Boolean=false):void{
			try
			{	
				var main:Main = (AsWingManager.getRoot() as Main)
				var responder:Responder = new Responder(successCallback,errorCallback);
				
				if(byteArray){
					trace("add byteArray")
					remoting_connection.call(ServerFunctions.mainScript+"addFile_byte",responder,main.id,main.pass,filename,type,extension,data);	
				}
				else{
					trace("add Object")
					var obj:Object = {filename:filename,type:type,extension:extension}
					remoting_connection.call(ServerFunctions.mainScript+"addFile_object",responder,main.id,main.pass,filename,type,extension,data);	
				}
			}
			catch(e:Error){
				
			}
		}
		
		public static function getFile(fileId:String,successCallback:Function,errorCallback:Function,progressCallback:Function=null):void{
			try
			{	
				var main:Main = AsWingManager.getRoot() as Main;
				var responder:Responder = new Responder(successCallback,errorCallback);
				trace("Read file");
				remoting_connection.call(ServerFunctions.mainScript+"readFile",responder,main.id,main.pass,fileId);
				/*var loader:URLLoader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY
				var request:URLRequest= new URLRequest();
				request.url = getServer_Path()+_filePath;
				var variables:URLVariables = new URLVariables();
				variables.pass = main.pass;
				variables.id = main.id;
				variables.src = fileId;
				request.data = variables;
				loader.addEventListener(Event.COMPLETE,successCallback);
				loader.addEventListener(IOErrorEvent.IO_ERROR,errorCallback);
				loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,ServerFunctions.securityError)
				if(progressCallback){
					loader.addEventListener(ProgressEvent.PROGRESS,progressCallback)
				}
				loader.load(request)*/
			}
			catch(e:Error){
				errorCallback("Erreur Connexion");
				trace("error file")
			}	
		}
		
		private static function onRemoting_Failure(error:*):void{
			statusWindow.dispose();
			var msg:String = "Une erreur est survenue lors de la connexion.\nDetails:";
			for(var a:String in error){
				msg +="\n"+a+"=>"+error[a];
			}
			statusWindow = new AlertWindow("Erreur de connexion",{message:msg});
			trace(error);
		}
		
		private static function onNetStatusEvent(evt:NetStatusEvent):void{
			trace("net status error "+evt.info.code)
			//trace(evt.
		}
		
	
		public static function getServer_Path():String
		{
			var container:Main  = AsWingManager.getRoot() as Main;
			var path:String = container.loaderInfo.url.substring(container.loaderInfo.url.lastIndexOf("/"),-1) + "/";
			trace("chemin source swf "+path);
			if (path.indexOf("mycpp.hostei") > -1 || Capabilities.playerType == "Desktop")
			{
				return "http://www.dardachat.net/fullchat/chat4d98cd02c77c1/server/";
				
			}
			else if (path.indexOf("prepa-inpg") > -1 || Capabilities.playerType == "Desktop")
			{
				return "http://www.prepa-inpg.fr/Collaboration/server/";
				
			}
			else
			{
				return "http://localhost/server/";
			}
		}
		
		private static function securityError(evt:SecurityErrorEvent):void{
			trace("erreur securite");
		}
	
	}
	
	
}