package ui.windows
{
	import org.aswing.ASColor;
	import org.aswing.AsWingConstants;
	import org.aswing.AsWingManager;
	import org.aswing.BorderLayout;
	import org.aswing.FlowLayout;
	import org.aswing.JFrame;
	import org.aswing.JProgressBar;
	import org.aswing.ext.MultilineLabel;
	import org.aswing.geom.IntDimension;
	
	public class AlertWindow extends JFrame
	{
		private var _txt:MultilineLabel;
		private var _progress:JProgressBar;
		public static var listAlerts:Vector.<AlertWindow> = new Vector.<AlertWindow>();
		
		public function AlertWindow(title:String,params:Object)
		{
			var owner:Main = AsWingManager.getRoot() as Main
			super(owner, title, true);
			
			setClosable(false)
			setResizable(false)
			this.setMideground(new ASColor(0xF2F2F2))
			this.getContentPane().setLayout(new FlowLayout(AsWingConstants.LEFT,5,10))
				
			var h:uint = params.hasOwnProperty("height")?params.height:240;
			var w:uint = params.hasOwnProperty("width")?params.width:320;
			
			var paddingTop:int = params.hasOwnProperty("paddingTop")?params.paddingTop:0
			this.setSize(new IntDimension(w,h))
			listAlerts.push(this)
			setLocationXY((owner.stage.stageWidth-w)/2,(owner.stage.stageHeight-h)/2+paddingTop);
			
			if(params.progress){
				buildProgress(w,h);
			}
			
			if(params.message){
				buildMessage(params.message,w,h);
			}
			
			
			this.getContentPane().mouseChildren = false
			this.show();
		}
		

		private function buildMessage(msg:String,w:uint,h:uint):void{
			_txt = new MultilineLabel(msg);
			_txt.setPreferredSize(new IntDimension(w-10,h-10))
			this.getContentPane().append(_txt,AsWingConstants.CENTER);
		}
		
		public function setText(txt:String):void{
			_txt.setText(txt);
		}
		
		private function buildProgress(w:uint,h:uint,message:String = "Chargement..."):void{
			buildMessage(message,w,h-70);
			_progress = new JProgressBar();
			_progress.setMideground(new ASColor(0x0084ad))
			_progress.setPreferredSize(new IntDimension(w-30,20))
			_progress.setIndeterminate(true);
			this.getContentPane().append(_progress,AsWingConstants.CENTER);
		}
		
		public function setProgress(value:uint,msg:String=""):void{
			_progress.setIndeterminate(false);
			_progress.setValue(value);
			if(msg){
				setText(msg);
			}
		}
		
		override public function dispose():void{
			listAlerts.pop();
			super.dispose();
			delete this
		}
		
		public static function getLast():AlertWindow{
			return AlertWindow.listAlerts[AlertWindow.listAlerts.length-1];
		}
		
		
		
	}
}