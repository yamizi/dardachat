package ui
{
	import Components.Picture;
	import Components.PictureContainer;
	import Components.Video;
	import Components.VideoContainer;
	
	import flash.display.Bitmap;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	import logic.ServerFunctions;
	
	import org.aswing.ASColor;
	import org.aswing.AsWingConstants;
	import org.aswing.EmptyLayout;
	import org.aswing.FlowLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JProgressBar;
	import org.aswing.JTextField;
	import org.aswing.border.EmptyBorder;
	import org.aswing.event.AWEvent;
	import org.aswing.geom.IntDimension;
	
	public class PictureImport extends JFrame
	{
		
		protected var _target:Picture;
		
		
		protected var _adress:JTextField;
		protected var _container:PictureContainer;
		protected var _src:String = "";
		protected var _type:String = ""
		public var submitButton:JButton;
		protected var _serverPath:String
		protected var _progressBar:JProgressBar;
		protected var _status:JLabel;
		
		public function PictureImport(target:Picture)
		{
			super(target.stage, "Ajouter une image", true);
			_target = target;
		
			setSize(new IntDimension( 500, 400 ) );
			setLocationXY(250,160);
			setClosable(false)
			setResizable(false);
			this.setMideground(new ASColor(0xF2F2F2))
			var pane : JPanel = new JPanel(new EmptyLayout());
			pane.setBorder(new EmptyBorder(null, new Insets(10,5,10,5)));
			getContentPane().append(pane);
			
			_status = new JLabel("");
			_status.setSizeWH(220,25);
			_status.setLocationXY(20,30);
			
			_progressBar = new JProgressBar(AsWingConstants.HORIZONTAL,0,100);
			_progressBar.setSizeWH(220,10);
			_progressBar.setLocationXY(250,40);
			_progressBar.setVisible(false);
				
			/*var facebook:Bitmap = new FACEBOOK_BUTTON();
			facebook.x = 250;
			facebook.y = 10
			pane.addChild(facebook)
			*/
				
			var label1:JLabel = new JLabel("Adresse de l'image:");
			label1.setSizeWH(120,25);
			label1.setLocationXY(20,70);
			
			_adress = new JTextField();
			_adress.setSizeWH(320,25);
			_adress.setLocationXY(150,70);
			this.addEventListener(Event.ENTER_FRAME,update);
			var label2:JLabel = new JLabel("Aperçu:");
			label2.setSizeWH(120,25);
			label2.setLocationXY(55,100);
			
			buildContainer(320,240,150,120);
			pane.graphics.beginFill(0xFFFFFF);
			pane.graphics.lineStyle(1,0x999999,1,true);
			pane.graphics.drawRoundRect(150,120,320,240,10,10);
			pane.addChild(_container)
				
				
			var uploadButton:JButton = new JButton("Uploader");
			uploadButton.addEventListener(MouseEvent.CLICK,onUpload);
			//uploadButton.setEnabled(false);
			uploadButton.setSizeWH(100,25);
			uploadButton.setLocationXY(25,150);
			
			var captureButton:JButton = new JButton("Capture camera");
			captureButton.setEnabled(false);
			captureButton.setSizeWH(100,25);
			captureButton.setLocationXY(25,180);
			
			submitButton= new JButton("Ajouter cette image");
			submitButton.addActionListener(submit);
			submitButton.setEnabled(false);
			submitButton.setSizeWH(120,25);
			submitButton.setLocationXY(15,270);
			
			var cancelButton:JButton = new JButton("Annuler");
			cancelButton.addActionListener(close);
			cancelButton.setSizeWH(80,25);
			cancelButton.setLocationXY(35,300);
			
			pane.appendAll(_status,_progressBar,label1,_adress,label2,uploadButton,captureButton,submitButton,cancelButton);
			
			this.show()
				
			_serverPath = ServerFunctions.getFileScript();
		}
		
		protected function buildContainer(w:uint,h:uint,posx:uint,posy:uint):void{
			_container = new PictureContainer(w,h,true);
			_container.x = posx;
			_container.y = posy;
		}
		
		protected function submit(evt:AWEvent):void{
			
			_target.setSrc(_src,true);
			close();
		}
		
		protected function close(evt:Event=null):void{
			_container.unload();
			
			if(evt){
				_target.destroy()
			}
			this.removeEventListener(Event.ENTER_FRAME,update);
			this.dispose();
		}
		
		protected function onUpload(evt:MouseEvent):void{
			var fileRef:FileReference= new FileReference();
			fileRef.addEventListener(Event.SELECT,onImage_Selected);
			fileRef.browse([new FileFilter("Images","*.jpg;*.png;*.gif")])
		}
		
		protected function onImage_Selected(evt:Event):void{
			var fileRef:FileReference = evt.target as FileReference;
			fileRef.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA,onImage_Sent);
			fileRef.addEventListener(IOErrorEvent.IO_ERROR,onImage_IO);
			fileRef.addEventListener(ProgressEvent.PROGRESS,onImage_Progress);
			
			var params:URLVariables = new URLVariables(); 
			params.ssid = "prezi_"+Math.floor(Math.random()*200);
			trace("upload to "+_serverPath)
			var request:URLRequest = new URLRequest(_serverPath); 
			request.method = URLRequestMethod.POST; 
			request.data = params; 
			try 
			{ 
				fileRef.upload(request); 
			} 
			catch (error:Error) 
			{ 
				trace("Unable to upload file."); 
			} 
		}
		
		protected function onImage_Sent(evt:DataEvent):void{
			trace(evt.data);
			_adress.setText(evt.data);
			
		}
		
		protected function update(evt:Event):void{
			var txt:String = _adress.getText();
			
			if(txt && _src!=txt){
				var extension:String = txt.substr(txt.lastIndexOf(".")+1).toLocaleLowerCase()
				//trace("extension "+extension);
				if((extension=="png"||extension=="gif"||extension=="jpg")){
					_container.loadUrl(txt);
					submitButton.setEnabled(true);
					_type = "local";
					_src = txt;
				}	
				else{
					submitButton.setEnabled(false);
				}
				
			}
			
			
		}
		
		protected function onImage_IO(evt:Event):void{
			trace("IO error");
		}
		
		protected function onImage_Progress(evt:ProgressEvent):void{
			var pt:int = evt.bytesLoaded*100/evt.bytesTotal;
			if(pt<98){
				_progressBar.setVisible(true);
				_progressBar.setValue(pt);
				_status.setText("Upload en cours...");
			}
			else{
				_progressBar.setVisible(false);
				_status.setText("Image chargée et prête");
			}
			trace("loaded "+evt.bytesLoaded/evt.bytesTotal);
		}
		
		
	}
}