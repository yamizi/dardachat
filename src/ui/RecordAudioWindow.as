package ui
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.SampleDataEvent;
	import flash.media.Microphone;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import logic.ServerFunctions;
	import logic.sound.WAVEncoder;
	
	import org.aswing.ASColor;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.LoadIcon;
	import org.aswing.geom.IntDimension;
	import ui.windows.AlertWindow;
	import ui.windows.InputWindow;
	import ui.buttons.IconButton;

	public class RecordAudioWindow extends AlertWindow
	{
		private var _soundBytes:ByteArray = new ByteArray();
		private var _samples:ByteArray = new ByteArray();
		private var _soundChannel:SoundChannel = new SoundChannel()
		private var _mic:Microphone = Microphone.getMicrophone();
		private var _sound:Sound = new Sound();
		private var _playButton:IconButton,_recordButton:IconButton,_saveButton:IconButton
		private var _status:String="";
		private var _soundWav:ByteArray;
		private var _message:JLabel;
		private var _closeFunction:Function;
		
		public function RecordAudioWindow(closeFunction:Function)
		{
			super("Enregister microphone", {height:180});
			this.getContentPane().mouseChildren = true	
			_mic.rate = 44;
			_mic.gain = 80;
			_soundBytes.endian = Endian.LITTLE_ENDIAN;
			this.getContentPane().append(_recordButton = new IconButton("",new LoadIcon("assets/ui/record.png"),100,100,captureHandler));
			this.getContentPane().append(_playButton = new IconButton("",new LoadIcon("assets/ui/play.png"),100,100,playBackHandler));
			this.getContentPane().append(_saveButton = new IconButton("",new LoadIcon("assets/ui/accept.png"),80,100,saveHandler));
			_message = new JLabel("Durée de l'enregistrement:")
			_message.setPreferredSize(new IntDimension(220,25));
			var closeButton:JButton = new JButton("Fermer")
			closeButton.setBackground(new ASColor(0x0084ad))
			closeButton.setPreferredSize(new IntDimension(60,25));
			closeButton.addEventListener(MouseEvent.CLICK,close);
			this.getContentPane().appendAll(_message,closeButton);
			
			_closeFunction = closeFunction
		}
		
		protected function captureHandler(event:Event):void
		{
			trace("status before "+_status);
			if(_status == "play"){
				_soundChannel.stop();
			}
			if(_status != "record_on"){
				if(_sound.hasEventListener(SampleDataEvent.SAMPLE_DATA)){
					_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA,playBack)
				}
				_recordButton.setIcon(new LoadIcon("assets/ui/pauseRecord.png"));
				_status = "record_on"
				_mic.addEventListener(SampleDataEvent.SAMPLE_DATA,capture)
			}
			else{
				_recordButton.setIcon(new LoadIcon("assets/ui/record.png"));
				_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA,capture)
				_status = "record_pause"
			}
			trace("status after "+_status);
		}
		
		private function capture(evt:SampleDataEvent):void{
			var limit:int = 0;
			
			while(evt.data.bytesAvailable){
				
				var sample:Number = evt.data.readFloat();
				_soundBytes.writeFloat(sample);
				//activity.text = FieldLabels.onAudioCapture();
				limit++
			}
			
		}
		
		private function playBack(evt:SampleDataEvent):void{
			for(var i:int = 0;i<8192 && _soundBytes.bytesAvailable>0;i++){
				var sample:Number = _soundBytes.readFloat();
				evt.data.writeFloat(sample);
				evt.data.writeFloat(sample);
			}
				
		}
		private function playBackHandler(event:Event=null):void{
			trace("------------\nstatus before "+_status);
			
			if(_mic.hasEventListener(SampleDataEvent.SAMPLE_DATA)){
				_mic.removeEventListener(SampleDataEvent.SAMPLE_DATA,capture)
				_status = "record_pause"
				_recordButton.setIcon(new LoadIcon("assets/ui/record.png"));
				_soundBytes.position = 0;
			}
			
			if(_status == "play"){
				_playButton.setIcon(new LoadIcon("assets/ui/play.png"));
				_status = "stop"
				_sound.removeEventListener(SampleDataEvent.SAMPLE_DATA,playBack);
				_soundChannel.stop();
			}
			else
			{
				_status = "play"
				_soundBytes.position = 0;
				_playButton.setIcon(new LoadIcon("assets/ui/stop.png"));
				_sound.addEventListener(SampleDataEvent.SAMPLE_DATA,playBack);
				this.addEventListener(Event.ENTER_FRAME,onSoundPlayed);
				_sound.play();	
			}
			
			trace("status after "+_status);
		}
		
		private function onSoundPlayed(evt:Event):void{
			
			if(_soundBytes.position == _soundBytes.length){
				trace("complete")
				removeEventListener(Event.ENTER_FRAME,onSoundPlayed);
				playBackHandler()
				
			}
		}
		
		public function saveHandler(evt:Event):void{
			var wavData:ByteArray = new ByteArray()
			wavData.endian = Endian.LITTLE_ENDIAN;
			_soundBytes.position = 0;
			while(_soundBytes.position<_soundBytes.length){
				wavData.writeShort(_soundBytes.readFloat()*32767);
			}
			_soundWav = new WAVEncoder().addHeaders(wavData);
			new InputWindow("Nommer l'enregistrement audio",{submitMessage:"Nom du fichier:",submitFunction:save});
		}
		
		public function save(txt:String):void{
			ServerFunctions.addFile(txt,_soundWav,"arec",onRecorded,onError);
			var window:AlertWindow = AlertWindow.getLast()
			window.dispose()
			new AlertWindow("Enregistrement du message audio...",{progress:true,width:320,height:100})
		}
		
		public function onRecorded(tbl:Array):void{
			trace("onRecorded "+tbl.join("\n")); 
			if(tbl && tbl[0]){
				trace("record success")
				_message.setText("Message Enregitré sur le serveur");
				var window:AlertWindow = AlertWindow.getLast()
				window.dispose()
			}
		}
		
		public function onError(error:Object):void{
			for(var a:String in error){
				trace(error[a])
			}
				_message.setText("Erreur:");
				var window:AlertWindow = AlertWindow.getLast()
				window.dispose()
			
		}
		
		private function close(evt:Event=null):void{
			var button:JButton = evt.target as JButton;
			button.removeEventListener(MouseEvent.CLICK,close);
			dispose()
			_closeFunction()
		}
		
	}
}