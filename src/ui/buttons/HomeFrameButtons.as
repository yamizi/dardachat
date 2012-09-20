package ui.buttons
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.aswing.ASColor;
	import org.aswing.AsWingConstants;
	import org.aswing.AssetBackground;
	import org.aswing.GroundDecorator;

	import org.aswing.JLabelButton;
	import org.aswing.event.AWEvent;
	
	public class HomeFrameButtons extends JLabelButton
	{
		private var _backGround:Sprite = new Sprite();
		private var _selected:Boolean = false
		public function HomeFrameButtons(text:String="",level:uint=0)
		{
			super(text, null);
			setHorizontalAlignment(AsWingConstants.LEFT);
			this.setForeground(new ASColor(0x222222))
			_backGround.graphics.beginFill(0xF2F2F2,0);
			_backGround.graphics.drawRect(0,0,100,20);
			this.setBackgroundDecorator(new AssetBackground(_backGround));
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.mouseChildren = false;
			this.buttonMode = true
			trace("created "+text);
			addEventListener(AWEvent.PAINT,onPaint);
			
		}
		
		private function onPaint(evt:Event):void{
			removeEventListener(AWEvent.PAINT,onPaint);
			setSelected(_selected)
			repaintAndRevalidate()
			
		}
		
		private function onOver(evt:MouseEvent):void{
			if(!_selected){
				_backGround.graphics.clear();
				_backGround.graphics.beginFill(0xDDDDDD,1);
				_backGround.graphics.drawRect(0,0,width,height);
				
			}	
			this.removeEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
		}
		
		private function onOut(evt:MouseEvent):void{
			if(!_selected){
				_backGround.graphics.clear();
				_backGround.graphics.beginFill(0xF2F2F2,0);
				_backGround.graphics.drawRect(0,0,width,height);
			}
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT,onOut);
		}
		
		public override function setSelected(bool:Boolean):void{
			trace("selected "+getText()+":"+bool);
			_selected = bool
			if(bool){
				//this.removeEventListener(MouseEvent.MOUSE_OUT,onOut);
				_backGround.graphics.clear();
				_backGround.graphics.beginFill(0xCCCCCC,1);
				_backGround.graphics.drawRect(0,0,width,height);
				_backGround.graphics.beginFill(0xFFFFFF,1);
				_backGround.graphics.moveTo(width,0);
				_backGround.graphics.lineTo(width-height/2,height/2);
				_backGround.graphics.lineTo(width,height);
				_backGround.graphics.lineTo(width,0);
				//this.validate()
			}
			else{
				_backGround.graphics.clear();
				_backGround.graphics.beginFill(0xF2F2F2,0);
				_backGround.graphics.drawRect(0,0,width,height);
				
			}
		}
	}
}