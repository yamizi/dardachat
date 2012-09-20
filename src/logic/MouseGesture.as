package logic
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	import org.aswing.AsWingManager;
	import org.aswing.JPanel;

	public class MouseGesture
	{
		
		private var _canevas:Sprite;
		private var _workSpace:Workspace;
		private var timer:Timer = new Timer(50);
		private var _steps:Array = ["0642","035","0","123567","6","71"];
		private var _shapes:Array = ["rectangle","triangle","text","circle","image","video"];
		private var _step:String;
		private var _coord:Rectangle;
		private var _lastPosition:Point;
		private var _lastPos:Point;
		
		private var _nbSectors:uint = 8;
		private var _seuil:uint = 60;
		
		public function MouseGesture(canevas:Sprite,workSpace:Workspace)
		{
			_canevas = canevas;
			_workSpace = workSpace;
			trace("works "+_workSpace)
			_workSpace.addEventListener(MouseEvent.MOUSE_DOWN,onMouse_Down);
			timer.addEventListener(TimerEvent.TIMER,update);
			
			/*trace(getAngle(new Point(0,0),new Point(1,0)));//0
			trace(getAngle(new Point(0,0),new Point(1,1)));//pi/4
			trace(getAngle(new Point(0,0),new Point(0,1)));//pi/2
			trace(getAngle(new Point(0,0),new Point(-1,1)));//3pi/4
			trace(getAngle(new Point(0,0),new Point(-1,0)));//pi
			trace(getAngle(new Point(0,0),new Point(-1,-1)));//-3pi/4
			trace(getAngle(new Point(0,0),new Point(0,-1)));//-pi/2
			trace(getAngle(new Point(0,0),new Point(1,-1)));//-pi/4*/
								
		}
		
		private function onMouse_Down(evt:MouseEvent):void{
			_step = "";
			
			var prezi:Main = AsWingManager.getRoot() as Main

			if(evt.target.parent is JPanel && !prezi.dragContent){ 
			timer.start()
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_UP,onMouse_Up);
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_DOWN,onMouse_Down);
			_coord= new Rectangle(_canevas.stage.mouseX,_canevas.stage.mouseY,0,0)
			}
			
				
		}
		
		
		private function onMouse_Up(evt:MouseEvent):void{
			var prezi:Main = AsWingManager.getRoot() as Main
			
			timer.stop()
			evt.currentTarget.removeEventListener(MouseEvent.MOUSE_UP,onMouse_Up);
			evt.currentTarget.addEventListener(MouseEvent.MOUSE_DOWN,onMouse_Down);
			_canevas.graphics.clear();
			_lastPosition = null;
			
			if(_step.length){
				var pt:Point = new Point(_coord.x,_coord.y)
				pt = _workSpace.globalToLocal(pt);
				
				var size:Point = new Point(_coord.width,_coord.height)
				size = _workSpace.globalToLocal(size);
				trace("type " +getShape(_step))	
				
				var params:Object = new Object();
				params.position = pt;
				params.size = size;
				_workSpace.addElement(getShape(_step),params);
			}
			
		}
		private function update(evt:TimerEvent):void{
		//	trace("timer "+_lastPosition)
			var pt:Point = new Point(_canevas.stage.mouseX,_canevas.stage.mouseY)
			var tmp:Point = new Point(_workSpace.mouseX,_workSpace.mouseY)
			
			if(tmp.x<3200 && tmp.y<2400&&tmp.x>0&&tmp.y>0){
				if(_lastPosition!=null){
					_canevas.graphics.lineStyle(1,0,.2);
					_canevas.graphics.moveTo(_lastPosition.x,_lastPosition.y);
					
					_canevas.graphics.lineTo(pt.x,pt.y);
					var dx:uint = (pt.x-_lastPos.x)^2+(pt.y-_lastPos.y)^2;
					
					if(dx>_seuil){
						//trace("angle "+getAngle(_lastPos,pt));
						var  step:String = getAngle(_lastPos,pt);
						if(_step.charAt(_step.length-1) !=step){
							_step +=step
						}
						
						_lastPos = pt;
						
					}
					
			
				}
				else{
					_lastPos= pt
				}
				_lastPosition = pt
					if(pt.y>_coord.height){
						_coord.height = pt.y
					}
					if(pt.x>_coord.width){
						_coord.width = pt.x;
					}
			}
		}
		
		private function getAngle(start:Point,end:Point):String{
			var dx:int = end.x-start.x;
			var dy:int = start.y-end.y;
			var angle:Number = Math.atan2(dy,dx);
			var direction:int = Math.round(angle/Math.PI*_nbSectors/2)
				if(direction<0){
					direction+=_nbSectors
				}
			return ""+direction
		}
		
		private function coutLevenshtein(str1:String,str2:String):uint{
			var list:Vector.<Vector.<uint>> = new Vector.<Vector.<uint>>()
				
				for(var i:uint = 0;i<=str1.length;i++){
					list.push(new Vector.<uint>(str2.length+1,true));
					list[i][0] = i;	
				}
				
				for(var j:uint = 0;j<=str2.length;j++){
					list[0][j] = j;	
				}
				
				for (var x:uint=1;x<=str1.length;x++){
					for (var y:uint=1;y<=str2.length;y++){
						var cost:uint
						if(str1.charAt(x-1)==str2.charAt(y-1)){
							cost  = 0;
						}
						else{
							cost = 1;
						}	
							list[x][y] =  Math.min(Math.min(list[x-1][y]+1,list[x][y-1]+1),list[x-1][y-1]+cost)
						
						
					}
				}
				return list[str1.length][str2.length];
						
		}
		
		private function getShape(str:String):String{
			trace("nb à comparer "+_steps.length)
			var pos:uint = 0;
			var cost:uint = 100000
			for(var i:uint = 0;i<_steps.length;i++){
				var tmp:uint = coutLevenshtein(str,_steps[i])
					trace("cout "+i +":"+tmp)
					if(tmp<cost){
						cost = tmp;
						pos = i;
					}
			}
			
			return _shapes[pos];
		}
		
	}
}