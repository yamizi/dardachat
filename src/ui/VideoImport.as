package ui
{
	import Components.Video;
	import Components.VideoContainer;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	import org.aswing.ASColor;
	import org.aswing.EmptyLayout;
	import org.aswing.FlowLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JTextField;
	import org.aswing.border.EmptyBorder;
	import org.aswing.event.AWEvent;
	import org.aswing.geom.IntDimension;
	
	public class VideoImport extends JFrame
	{
		
		private var _target:Video;
		[Embed(source = "/assets/ui/youtube-icon.png")]
		private static const YOUTUBE_BUTTON:Class;
		[Embed(source = "/assets/ui/vimeo-icon.png")]
		private static const VIMEO_BUTTON:Class;
		[Embed(source = "/assets/ui/facebook-icon.png")]
		private static const FACEBOOK_BUTTON:Class;
		
		private var _adress:JTextField;
		private var _container:VideoContainer;
		private var _id:String = "";
		private var _type:String = ""
		public var submitButton:JButton 
		
		public function VideoImport(target:Video)
		{
			super(target.stage, "Ajouter une video", true);
			_target = target;
			this.setMideground(new ASColor(0xF2F2F2))
			setSize(new IntDimension( 500, 400 ) );
			setLocationXY(250,160);
			setClosable(false)
			setResizable(false);
			
			var pane : JPanel = new JPanel(new EmptyLayout());
			pane.setBorder(new EmptyBorder(null, new Insets(10,5,10,5)));
			getContentPane().append(pane);
			
			var label:JLabel = new JLabel("Videos supportées:");
			label.setSizeWH(120,25);
			label.setLocationXY(20,20);
			pane.appendAll(label);
			
			var youtube:Bitmap = new YOUTUBE_BUTTON();
			youtube.x = 150;
			youtube.y = 10
			pane.addChild(youtube)
				
			var vimeo:Bitmap = new VIMEO_BUTTON();
			vimeo.x = 200;
			vimeo.y = 10
			pane.addChild(vimeo)
				
			/*var facebook:Bitmap = new FACEBOOK_BUTTON();
			facebook.x = 250;
			facebook.y = 10
			pane.addChild(facebook)
			*/
				
			var label1:JLabel = new JLabel("Adresse de la video:");
			label1.setSizeWH(120,25);
			label1.setLocationXY(20,70);
			
			_adress = new JTextField();
			_adress.setSizeWH(320,25);
			_adress.setLocationXY(150,70);
			this.addEventListener(Event.ENTER_FRAME,update);
			
			var label2:JLabel = new JLabel("Aperçu:");
			label2.setSizeWH(120,25);
			label2.setLocationXY(55,100);
			
			_container = new VideoContainer(320,240);
			_container.x = 150;
			_container.y = 100;
			
			var uploadButton:JButton = new JButton("Uploader");
			uploadButton.setEnabled(false);
			uploadButton.setSizeWH(100,25);
			uploadButton.setLocationXY(25,150);
			
			var captureButton:JButton = new JButton("Capture camera");
			captureButton.setEnabled(false);
			captureButton.setSizeWH(100,25);
			captureButton.setLocationXY(25,180);
			
			submitButton= new JButton("Ajouter cette video");
			submitButton.addActionListener(submit);
			submitButton.setEnabled(false);
			submitButton.setSizeWH(120,25);
			submitButton.setLocationXY(15,270);
			
			var cancelButton:JButton = new JButton("Annuler");
			cancelButton.addActionListener(close);
			cancelButton.setSizeWH(80,25);
			cancelButton.setLocationXY(35,300);
			
			pane.appendAll(label1,_adress,label2,uploadButton,captureButton,submitButton,cancelButton);
			pane.addChild(_container)
			this.show()
		}
		
		private function submit(evt:AWEvent):void{
			
			_target.load(_id,_type);
			close();
		}
		
		private function close(evt:Event=null):void{
			_container.unload();
			if(evt){
				_target.destroy()
			}
			this.dispose();
			
		}
		
		private function update(evt:Event):void{
			var txt:String = _adress.getText();
			var id:String;
			
			if(txt.indexOf("http://")==0){
				txt = txt.substr(7)
			}
			if(txt.indexOf("www.")==0){
				txt = txt.substr(4)
			}
			if(txt.indexOf("youtube")>-1){
				id= txt.substr(20);
				if(id.length==11){
					if( id!=_id){
						_id = id;
						_container.loadYoutube(_id)
						submitButton.setEnabled(true);
						_type = "youtube";
					}
				}
			}
			
			else if(txt.indexOf("vimeo")>-1){
				id= txt.substr(10);
				if(id.length==8){
					if( id!=_id){
						_id = id;
						_container.loadVimeo(_id)
						submitButton.setEnabled(true);
						_type = "vimeo";
					}
				}
			}
			
		}
	}
}