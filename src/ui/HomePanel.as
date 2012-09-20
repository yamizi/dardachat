package ui
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import logic.Serialization;
	import logic.ServerFunctions;
	
	import org.aswing.ASColor;
	import org.aswing.ASFont;
	import org.aswing.AbstractButton;
	import org.aswing.AsWingConstants;
	import org.aswing.AsWingManager;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JLoadPane;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.LoadIcon;
	import org.aswing.border.LineBorder;
	import org.aswing.geom.IntDimension;
	import ui.windows.AlertWindow;
	import ui.buttons.FileButton;
	import ui.buttons.IconButton;
	
	public class HomePanel extends JPanel
	{
		private var listFav_Txt:Array = ["Présentation","Dessin","Questionnaire"," Salons de\nDiscussion","Importer","Reglages"]
		private var listFav_Icon:Array = ["gnome_x_office_presentation.png","applications_graphics.png","applications_education.png","chat_64.png","upload.png","gnome_preferences_other.png"]
		private var listFav_Functions:Array=["initPresentation",null,null,null,null,null]
		private var _favPanel:JPanel
		private var _lastPanel:JPanel
		private var _sharedPanel:JPanel
		public function HomePanel()
		{
			super(new FlowLayout());
			setPreferredSize(new IntDimension(850,550));
			setLocationXY(20,10);
			
			var button:IconButton
			var i:uint
			
			_favPanel = new JPanel();
			_favPanel.setPreferredSize(new IntDimension(765,170));
			_favPanel.setBorder(new LineBorder(null,new ASColor(0x0084ad),2,5))
			this.append(_favPanel);
			var label0:JLabel = new JLabel("Créer:")
			label0.setFont(new ASFont("Tahoma",13,true))
			label0.setHorizontalAlignment(AsWingConstants.LEFT)
			label0.setPreferredSize(new IntDimension(765,30));
			_favPanel.append(label0);
			for(i=0;i<6;i++){
				if(listFav_Icon[i]){
				button = new IconButton("",new LoadIcon("assets/ui/"+listFav_Icon[i]),120,120);
				}
				else{
					button = new IconButton(listFav_Txt[i],null,120,120);	
				}
				if(listFav_Functions[i]){
					var funct:Function = (AsWingManager.getRoot() as Main)[listFav_Functions[i]]
					trace("function "+listFav_Functions[i])
					button.addEventListener(MouseEvent.CLICK,funct);
				}
				else{
					//button.setEnabled(false)
				}
				_favPanel.append(button)
			}
			
			
			_lastPanel = new JPanel();
			_lastPanel.setPreferredSize(new IntDimension(765,170));
			_lastPanel.setBorder(new LineBorder(null,new ASColor(0x0084ad),2,5))
			this.append(_lastPanel);
			
			var label1:JLabel = new JLabel("Derniers documents ouverts:")
			label1.setHorizontalAlignment(AsWingConstants.LEFT)
			label1.setPreferredSize(new IntDimension(765,30));
			label1.setFont(new ASFont("Tahoma",13,true))
			_lastPanel.append(label1);
			getLastOpenedFiles()
			
			_sharedPanel = new JPanel();
			_sharedPanel.setPreferredSize(new IntDimension(765,170));
			_sharedPanel.setBorder(new LineBorder(null,new ASColor(0x0084ad),2,5))
			this.append(_sharedPanel);
			var label2:JLabel = new JLabel("Derniers documents partagés:")
			label2.setPreferredSize(new IntDimension(800,30));
			label2.setFont(new ASFont("Tahoma",13,true))
			label2.setHorizontalAlignment(AsWingConstants.LEFT)
			_sharedPanel.append(label2);
			getLastSharedFiles()
			
		}
		
		private function getLastOpenedFiles():void{
			var button:IconButton = new IconButton("Chargement...",new ProgressIcon());
			_lastPanel.append(button)
			ServerFunctions.getFiles({order:"desc",number:5,type:"private"},onGet_LastOpenedFiles,onFailure_LastOpenedFiles)	
		}
		
		private function getLastSharedFiles():void{
			var button:IconButton = new IconButton("Chargement...",new ProgressIcon());
			_sharedPanel.append(button)
			ServerFunctions.getFiles({order:"desc",number:5,type:"shared"},onGet_LastSharedFiles,onFailure_LastSharedFiles)	
		}
		
		public function onGet_LastOpenedFiles(list:Array):void{
			_lastPanel.removeAt(1)
			trace("success last files "+list[1])	
			if(!list.length|| list[0]==false||list[1].length==0){
				var button:IconButton = new IconButton("Aucun fichier",new LoadIcon("assets/ui/notFound.png"));
				_lastPanel.append(button)
			}
			else{
				var elements:Array = list[1];
				for(var i:uint=0;i<elements.length;i++){
					var fileName:String = elements[i].filename;
					//var extension:String = elements[i].filename;
					//var thumbnail
					var element:FileButton = new FileButton(fileName,new LoadIcon("assets/ui/logoS.png"),100,120,loadFile);
					_lastPanel.append(element);
					element.setId(elements[i].id);
				}
			}
		}
		
		public function onGet_LastSharedFiles(list:Array):void{
			_sharedPanel.removeAt(1)
			trace("success shared files")
			if(!list.length || list[0]==false||list[1].length==0){
				var button:IconButton = new IconButton("Aucun fichier\npartagé",new LoadIcon("assets/ui/notFound.png"));
				_sharedPanel.append(button)
			}
			
			else{
				var elements:Array = list[1];
				for(var i:uint=0;i<elements.length;i++){
					var fileName:String = elements[i].filename;
					//var extension:String = elements[i].filename;
					//var thumbnail
					var element:IconButton = new IconButton(fileName,new LoadIcon("assets/ui/logoS.png"),100,120,loadFile);
					_sharedPanel.append(element);
					element.setId(elements[i].id);
				}
			}
			
		}
				
		public function onFailure_LastOpenedFiles(msg:Object):void{
			trace("erreur last files")
			for(var a:String in msg){
				trace(msg[a])
			}
			_lastPanel.removeAt(1)
			var button:IconButton = new IconButton("Serveur\ninacessible;)\nVeuillez\nvérifier votre\nconnnexion\nou réessayer\nplus tard",null);
			_lastPanel.append(button)
			
		}
		
		public function onFailure_LastSharedFiles(msg:Object):void{
			trace("erreur shared files")
			for(var a:String in msg){
				trace(msg[a])
			}
			_sharedPanel.removeAt(1)
			var button:IconButton = new IconButton("Serveur\ninacessible;)\nVeuillez\nvérifier votre\nconnnexion\nou réessayer\nplus tard",null);
			_sharedPanel.append(button)
				
		}
		
		private function loadFile(evt:Event= null):void{
			var element:IconButton = evt.target as IconButton;
			trace("test "+element.getId());
			ServerFunctions.getFile(element.getId(),onSuccessFile_Load,onFailureFile,onProgressFile_Load);
			new AlertWindow("Chargement du fichier...",{progress:true,width:320,height:100})
		}
		
		private function onFailureFile(error:*):void{
			//trace("error loading file "+error.toString())
			for(var a:String in error){
				trace(error[a])
			}
			var window:AlertWindow = AlertWindow.getLast()
			window.dispose()
			
		}
		
		private function onSuccessFile_Load(tbl:Array):void{
			trace("result "+tbl.join("*"))
			if(tbl && tbl.length && tbl[0]){
			
				var window:AlertWindow = AlertWindow.getLast()
				window.dispose();
				
				var workspace:Vector.<Object> = Vector.<Object>(tbl[1][0] as Array);
				var animation:Array = (tbl[1][1] as Array);
				if(workspace){
					trace("Byte "+tbl[1].length+"--"+workspace.length)
					var main:Main = AsWingManager.getRoot() as Main
					main.initPresentation(null,workspace,animation,tbl[2]);
				}
				else{
					trace("erreur")
				}
			}
		}
			
		/*private function onFailureFile(error:IOErrorEvent):void{
			trace("error loading file "+error.toString())
			for(var a:String in error){
				trace(error[a])
			}
			var window:AlertWindow = AlertWindow.getLast()
			window.dispose()
			
		}
		
		private function onSuccessFile_Load(evt:Event):void{
			var urlLoader:URLLoader = evt.target as URLLoader;
			trace(urlLoader.data)
			
			var result:ByteArray = urlLoader.data as ByteArray
			var window:AlertWindow = AlertWindow.getLast()
			window.dispose();
			trace("success")
			if(result){
				trace("Byte "+result.length)
				
				result.position = 0;
				//(AsWingManager.getRoot() as Main).initPresentation(null,Serialization.unserializeDocument(result));
			}
			else{
				trace("erreur")
			}
		}*/
		
		private function onProgressFile_Load(evt:ProgressEvent):void{
			var window:AlertWindow = AlertWindow.getLast();
			trace("progression" +evt.bytesLoaded);
			window.setProgress(evt.bytesLoaded/evt.bytesTotal*100,"Chargement")
		}
		
	}
}