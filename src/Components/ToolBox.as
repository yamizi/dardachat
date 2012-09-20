package Components
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.aswing.AsWingManager;
	
	
	public class ToolBox extends Sprite
	{
		protected var _rotateCaret:Sprite;
		protected var _moveCaret:Sprite;
		protected var _resizeCaret:Sprite;
		protected var action:String="";
		protected var _origin:Point;
		protected var _beginRadius:uint;
		private var _target:Element;
		private var _preview:Sprite;
		private var _tempPos:Object;
		private var _resizeMode:String = "free"
		
		public function ToolBox()
		{
			super();
			addEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(Event.ENTER_FRAME,updateTarget);
			visible = false
		}
		
		private function init(evt:Event):void{
			
			_preview = new Sprite();
			this.addChild(_preview);
			this.graphics.beginFill(0xFFFFFF,0);
			this.graphics.drawCircle(0,0,38);
			
			_moveCaret = new Sprite();
			_moveCaret.graphics.beginFill(0x7cdeff);
			_moveCaret.graphics.lineStyle(1);
			_moveCaret.graphics.drawCircle(0,0,10);
			this.addChild(_moveCaret);
			
			_resizeCaret = new Sprite();
			var radius:Number = 30;
			var _width:Number = 6
			_resizeCaret.graphics.lineStyle(_width*2,0x7cdeff);
			_resizeCaret.graphics.drawCircle(0,0,radius);
			_resizeCaret.graphics.lineStyle(1,0);
			_resizeCaret.graphics.drawCircle(0,0,radius-_width);
			_resizeCaret.graphics.drawCircle(0,0,radius+_width);
			this.addChild(_resizeCaret);
			
			_rotateCaret = new Sprite();
			_rotateCaret.graphics.beginFill(0x7cdeff);
			_rotateCaret.graphics.lineStyle(1);
			_rotateCaret.graphics.drawRect(20,-5,20,10);
			this.addChild(_rotateCaret);
			this.addEventListener(MouseEvent.MOUSE_DOWN,toolsMouseDown);
		}
		
		public function set target(obj:Element):void{
			if(obj==null){
				visible = false;
			}
			else{
				if(action ==""){
					_target = obj;
					//trace("ToolBox "+_target.x+"--"+_target.y)
					this.x = _target.x;
					this.y = _target.y;
					this.rotation = _target.rotation
				}
				parent.swapChildren(this,parent.getChildAt(parent.numChildren-1));
				visible = true
			}
				
		}
		private function updateTarget(evt:Event):void{
			if(_target){
				_target.x = this.x;
				_target.y = this.y;
				
				if(_target.getProperties().type =="text"){
					alpha = 0.2;
				}
				else{
					alpha =1
				}
			}
		}
		/*protected function rotateAroundCenter (ob:Sprite, angleDegrees:int,point:Point) :void{
			var m:Matrix=ob.transform.matrix;
			m.tx -= point.x;
			m.ty -= point.y;
			m.rotate (angleDegrees*(Math.PI/180));
			m.tx += point.x;
			m.ty += point.y;
			ob.transform.matrix=m;
		}*/
		
		
		
		protected function toolsMouseDown(evt:MouseEvent):void{
			
			
			_tempPos = _target.getProperties()
			_origin = new Point(0,0);
			_origin = this.localToGlobal(_origin);
			_beginRadius =width/2
				
				
			switch(evt.target){
				case _moveCaret:
					this.startDrag(true);
					action = "move";
					break;
				case _resizeCaret:
					action = "resize";
					_resizeMode = "free";
					var dx:Number =(evt.stageX-_origin.x)*2/parent.scaleX;
					var dy:Number = (evt.stageY-_origin.y)*2/parent.scaleY;
					var angle:Number = Math.atan2(dy,dx);
					var nbSectors:uint = 16
					var direction:int = Math.round(angle/Math.PI*nbSectors/2)
					if(direction<0){
						direction+=nbSectors
					}
					if(direction==0||direction==nbSectors/2){
						_resizeMode = "horizontal"
					}
					
					if(direction==nbSectors/4||direction==nbSectors*3/4){
						_resizeMode = "vertical"
					}
					
					
					if(direction==nbSectors/8||direction==nbSectors*3/8||direction==nbSectors*5/8||direction==nbSectors*7/8){
						_resizeMode = "ratio"
					}
					
					break;
				case _rotateCaret:
					action = "rotate";
					break;
				
			}
			stage.addEventListener(MouseEvent.MOUSE_MOVE,toolsMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP,toolsMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_DOWN,toolsMouseDown);
			if(this._target){
				(AsWingManager.getRoot() as Main).selection = this._target;	
			}
			
		}
		
		protected function toolsMouseUp(evt:MouseEvent):void{
			
			this.stopDrag();
			if(action=="resize"){
				_target.setProperties({w:_preview.width,h:_preview.height});		
			}
			if(action=="rotate"){
				_target.setProperties({rotation:this.rotation});			
			}
			
			if(action=="move"){
				var finalPos:Object =  _target.getProperties();
				var main:Main = (AsWingManager.getRoot() as Main)
					main.selection = _target
				main.historyManager.registerAction(_target,_tempPos,finalPos);		
			}
			_preview.graphics.clear();
			_target.refresh();
			action = ""
			stage.removeEventListener(MouseEvent.MOUSE_MOVE,toolsMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP,toolsMouseUp);
			this.addEventListener(MouseEvent.MOUSE_DOWN,toolsMouseDown);
		}
		
		protected function toolsMouseMove(evt:MouseEvent):void{
			var dx:Number =(evt.stageX-_origin.x)*2/parent.scaleX;
			var dy:Number = (evt.stageY-_origin.y)*2/parent.scaleY;
			_preview.graphics.clear();
			_preview.graphics.lineStyle(0,0);
			if(action=="resize"){
				
					
				if(_resizeMode =="vertical"){
					dx = _target.width
				}
				else if(_resizeMode =="horizontal"){
					dy = _target.height
				}
				
				else if(_resizeMode =="ratio"){
					var finalWidth:Number = _target.getRealSize().width
					var finalHeight:Number = _target.getRealSize().height
					dy = finalHeight/finalWidth*dx
				}
				
					//if(Math.abs((dy-fin/dx) >0.9 || Math.abs(dy/dx)>0.9){
						//dy = finalHeight/finalWidth*dx		
					//}	
					
				//}
				
				_preview.graphics.drawRect(-Math.abs(dx)/2,-Math.abs(dy)/2,Math.abs(dx),Math.abs(dy));
				
				
			}
			
			if(action=="rotate"){
				
				this.rotation = Math.atan2(dy,dx)*180/Math.PI;
				var w:Number = _target.getProperties().w;
				var h:Number = _target.getProperties().h;
				
				_preview.graphics.drawRect(-w/2,-h/2,w,h);
				
			}
		}
		
	}
}