package ui
{
	import flash.events.Event;
	
	import logic.ServerFunctions;
	import logic.UploadFile;
	
	import org.aswing.ASColor;
	import org.aswing.AbstractButton;
	import org.aswing.AsWingConstants;
	import org.aswing.FlowLayout;
	import org.aswing.FlowWrapLayout;
	import org.aswing.JButton;
	import org.aswing.JCheckBox;
	import org.aswing.JCheckBoxMenuItem;
	import org.aswing.JLabel;
	import org.aswing.JLabelButton;
	import org.aswing.JList;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JSeparator;
	import org.aswing.JViewport;
	import org.aswing.LayoutManager;
	import org.aswing.LoadIcon;
	import org.aswing.border.LineBorder;
	import org.aswing.geom.IntDimension;
	
	import ui.buttons.IconButton;
	import ui.windows.AlertWindow;
	import ui.windows.ContentWindow;
	
	public class MediaPanel extends JPanel
	{
		private var _filePanel:JPanel
		private var _selectFunction:Function
		
		public function MediaPanel(SelectFunction:Function = null)
		{
			super(new FlowLayout(AsWingConstants.LEFT,5,10));
			
			_selectFunction = SelectFunction;
			setPreferredSize(new IntDimension(850,550));
			setLocationXY(20,20);
			
			var insertPanel:JPanel = new JPanel(new FlowLayout());
			//insertPanel.setBorder(new LineBorder(null,new ASColor(0x0084ad),2,5))
			this.append(insertPanel);
			
			var uploadButton:IconButton =new IconButton("Uploader",new LoadIcon("assets/ui/"+"upload.png",64,64,true),80,100,upload);
			var googleButton:IconButton =new IconButton("Google Docs",new LoadIcon("assets/ui/"+"googleDoc.png",64,64,true),85,100);
			var dropboxButton:IconButton =new IconButton("Dropbox",new LoadIcon("assets/ui/"+"dropbox.png",64,64,true),80,100);
			var cameraButton:IconButton =new IconButton("Camera",new LoadIcon("assets/ui/"+"camera.png",64,64,true),80,100);
			var micButton:IconButton =new IconButton("Microphone",new LoadIcon("assets/ui/"+"mic.png",64,64,true),80,100,recordAudio);
			
			insertPanel.appendAll(new JLabel("Ajouter:"),uploadButton,cameraButton,micButton,googleButton,dropboxButton);
			
			var separator:JSeparator = new JSeparator()
				separator.setPreferredWidth(750);
			this.append(separator)
			var displayPanel:JPanel = new JPanel(new FlowLayout());
			displayPanel.setBorder(new LineBorder(null,new ASColor(0x0084ad),2,5))
			this.append(displayPanel);
			var checkBox1:JCheckBoxMenuItem = new JCheckBoxMenuItem("Documents");
			checkBox1.setSelected(true);
			var checkBox2:JCheckBoxMenuItem = new JCheckBoxMenuItem("Images");
			checkBox2.setSelected(true);
			var checkBox3:JCheckBoxMenuItem = new JCheckBoxMenuItem("Vidoes");
			checkBox3.setSelected(true);
			var checkBox4:JCheckBoxMenuItem = new JCheckBoxMenuItem("Plugins");
			checkBox4.setSelected(true);
			displayPanel.appendAll(new JLabel("Afficher:   "),checkBox1,checkBox2,checkBox3,checkBox4);
			displayPanel.setEnabled(false)
			_filePanel = new JPanel(new FlowWrapLayout(700))
			
			var scrollPane:JScrollPane = new JScrollPane();
			var viewport:JViewport = new JViewport(_filePanel, true, false);
			viewport.setVerticalAlignment(AsWingConstants.TOP);
			viewport.setHorizontalAlignment(AsWingConstants.LEFT);
			scrollPane.setViewport(viewport);
			scrollPane.setPreferredSize(new IntDimension(750,350));
		
			
			this.append(scrollPane);
			
			refreshFiles()
			
		}
		
		private function refreshFiles():void{
			var button:IconButton = new IconButton("Chargement...",new ProgressIcon());
			_filePanel.append(button)
			ServerFunctions.getFiles({order:"desc",number:50,type:"media"},onGet_LastFiles,onFailure_LastFiles)				
		}
		
		
		public function onGet_LastFiles(list:Array):void{
			_filePanel.removeAll()
			trace(list.join("*"))
			if(!list.length || list[0]==false||list[1].length==0){
				var button:IconButton = new IconButton("Aucun fichier",new LoadIcon("assets/ui/notFound.png"));
				_filePanel.append(button)
			}
				
			else{
				var elements:Array = list[1];
				for(var i:uint=0;i<elements.length;i++){
					var fileName:String = elements[i].filename;
					var extension:String = elements[i].extension;
					//var thumbnail
					var src:String = "assets/filetype/"+extension+".png";
					trace("retrieve "+src);
					var element:IconButton = new IconButton(fileName,new LoadIcon(src),100,120,fileDetails);
					element.setName(elements[i].id);
					_filePanel.append(element)
				}
			}
			
		}
		
		public function fileDetails(evt:Event):void{
			var target:IconButton = evt.currentTarget as IconButton;
			var t:AlertWindow = AlertWindow.getLast()
			if(t){
				t.dispose();
			}
			new ContentWindow("Details sur",new FileDetailsPanel(target.getName(),new IntDimension(300,200)),"Annuler")
			
		}
		
		public function onFailure_LastFiles(msg:String):void{
			for(var a:String in msg){
				trace(msg[a])
			}
			_filePanel.removeAt(0)
			var button:IconButton = new IconButton("Serveur\ninacessible;)\nVeuillez\nvérifier votre\nconnnexion\nou réessayer\nplus tard",null);
			_filePanel.append(button)
		}
		
		private function upload(evt:Event):void{
			new UploadFile(refreshFiles)
			//evt.target["setnabled"](false)
		}
		
		private function recordAudio(evt:Event):void{
			new RecordAudioWindow(refreshFiles);
			//evt.target["setnabled"](false)
		}
	}
}