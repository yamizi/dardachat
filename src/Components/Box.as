package Components
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Box extends Shape
	{
		public function Box(coord:flash.geom.Rectangle,id:String)
		{
			super(coord,id);
			
		}
		
		
		override protected function setSize(w:Number, h:Number, center:Boolean=false):void{ 
			initDraw()
			_content.graphics.drawRoundRect(0,0,w,h,0,0);
			_content.width = w;
			_content.height = h
			_content.x = -w/2;
			_content.y = -h/2;
		}
		
		override public function getProperties():Object{
			var obj:Object = super.getProperties();
			obj.type = "box";
			return obj;
		}
	}
}