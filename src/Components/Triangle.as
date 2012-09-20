package Components
{
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	public class Triangle extends Shape
	{

		
		public function Triangle(coord:Rectangle,id:String=null)
		{
			super(coord,id);
		}
		
		/*override protected function draw(evt:Event=null):void{
			super.draw(evt);
			/*_content.graphics.moveTo(0,_coord.width*Math.sqrt(3)*5/12);
			_content.graphics.lineTo(_coord.width,_coord.width*Math.sqrt(3)*5/12);
			_content.graphics.lineTo(_coord.width/2,-_coord.width*Math.sqrt(3)*1/12);
			
			var origin:Point = new Point(0,0);
			if(evt){
			_coord.height = _coord.width/2*Math.tan(Math.PI/3)
			}
			origin = new Point(0,_coord.height);
			_content.graphics.moveTo(0+origin.x,0+origin.y);
			_content.graphics.lineTo(_coord.width/2+origin.x,-_coord.height+origin.y);
			_content.graphics.lineTo(_coord.width+origin.x,0+origin.y);
			setSize(_content.width,_content.height)
		}*/
		
		override protected function setSize(w:Number, h:Number, center:Boolean=false):void{ 
			initDraw()
			if(!stage){
				h = w/2*Math.tan(Math.PI/3)
			}	
			var origin:Point = new Point(0,h);
			_content.graphics.moveTo(0+origin.x,0+origin.y);
			_content.graphics.lineTo(w/2+origin.x,-h+origin.y);
			_content.graphics.lineTo(w+origin.x,0+origin.y);
			
			//_content.graphics.drawRoundRect(0,0,w,h,0,0);
			_content.width = w;
			_content.height = h
			_content.x = -w/2;
			_content.y = -h/2;
		}
		
		override public function getProperties():Object{
			var obj:Object = super.getProperties();
			obj.type = "triangle";
			return obj;
		}
	}
}