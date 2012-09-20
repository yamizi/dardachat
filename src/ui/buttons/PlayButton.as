package ui.buttons
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import org.aswing.AsWingManager;
	
	public class PlayButton extends Sprite
	{
		private var _progressArc:Shape;
		private var _forgroundButton:Shape
		
		private var _duration:uint = 5000;
		private var _timer:Timer = new Timer(50);
		private var _playing:Boolean = true;
		
		public function PlayButton()
		{
			super();
			init();
			scaleX = scaleY = 0.5
		}
		
		private function init():void{
			
			
			_progressArc = new Shape();
			this.addChild(_progressArc);
			_forgroundButton = new Shape();
			this.addChild(_forgroundButton);
			this.buttonMode = true;
			this.doubleClickEnabled = true
			_timer.addEventListener(TimerEvent.TIMER,onTimer);
			
			onClick();	
			this.addEventListener(MouseEvent.MOUSE_OVER,onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT,onOut);
			this.addEventListener(MouseEvent.CLICK,onClick);
			onOut();
		}
		
		
		private function onOver(evt:MouseEvent):void{
			this.alpha = 1;
		}
		private function onOut(evt:MouseEvent=null):void{
			this.alpha = 0;
		}
		public function onClick(evt:MouseEvent=null):void {
			trace("click")
			_forgroundButton.graphics.clear()
			_forgroundButton.graphics.beginFill(0x0084ad,0.2);
			_forgroundButton.graphics.lineStyle(2);
			_forgroundButton.graphics.drawCircle(20,20,20);
			
			_forgroundButton.graphics.beginFill(0x0024ed,0.2);
			
			if(_playing){
				_timer.stop()
				_forgroundButton.graphics.moveTo(12,8);
				
				_forgroundButton.graphics.lineTo(32,22);
				_forgroundButton.graphics.lineTo(12,32);
				_forgroundButton.graphics.lineTo(12,8);
			}
			
			else{
				
				_forgroundButton.graphics.lineStyle(3);
				_forgroundButton.graphics.moveTo(15,5);
				_forgroundButton.graphics.lineTo(15,35);
				
				_forgroundButton.graphics.moveTo(25,5);
				_forgroundButton.graphics.lineTo(25,35);
				
				_timer.reset();
				_timer.start();
				
				var main:Main = AsWingManager.getRoot() as Main;
				main.playAnimation();
				
			}
			
			
			_playing = !_playing;
		} 
		
		private function onTimer(evt:TimerEvent):void{
			var timer:Timer = evt.currentTarget as Timer;
			if(timer.currentCount*timer.delay % _duration==0){
				var main:Main = AsWingManager.getRoot() as Main;
				main.playAnimation();
			}
			_progressArc.graphics.clear();
			_progressArc.graphics.beginFill(0x99badd);
			var angle:uint = (timer.currentCount*timer.delay % _duration)/_duration*360;
			DrawSolidArc(_progressArc,20,20,22,25,0,angle,50);
		}
		
		private function DrawSolidArc (target:Shape,centerX:int, centerY:int, innerRadius:int, outerRadius:int, startAngle:int, arcAngle:int, steps:uint):void{
			//
			// Used to convert angles to radians.
			var twoPI:Number = 2 * Math.PI/360;
			//
			// How much to rotate for each point along the arc.
			var angleStep:Number = arcAngle/steps;
			//
			// Variables set later.
			var angle:Number, i:uint, endAngle:Number;
			//
			// Find the coordinates of the first point on the inner arc.
			var xx:Number = centerX + Math.cos(startAngle * twoPI) * innerRadius;
			var yy:Number = centerY + Math.sin(startAngle * twoPI) * innerRadius;
			//
			// Store the coordiantes in an object.
			var startPoint:Point = new Point(xx,yy);
			//
			// Move to the first point on the inner arc.
			target.graphics.moveTo(xx, yy);
			//
			// Draw all of the other points along the inner arc.
			for(i=1; i<=steps; i++){
				angle = (startAngle + i * angleStep) * twoPI;
				xx = centerX + Math.cos(angle) * innerRadius;
				yy = centerY + Math.sin(angle) * innerRadius;
				
				target.graphics.lineTo(xx, yy);
			}
			//
			// Determine the ending angle of the arc so you can
			// rotate around the outer arc in the opposite direction.
			endAngle = startAngle + arcAngle;
			//
			// Start drawing all points on the outer arc.
			for(i=0; i<=steps; i++){
				//
				// To go the opposite direction, we subtract rather than add.
				angle = (endAngle - i * angleStep) * twoPI;
				xx = centerX + Math.cos(angle) * outerRadius;
				yy = centerY + Math.sin(angle) * outerRadius;
				target.graphics.lineTo(xx, yy);
			}
			//
			// Close the shape by drawing a straight
			// line back to the inner arc.
			target.graphics.lineTo(startPoint.x, startPoint.y);
		}
	}
}