package Components
{
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class Cercle extends Shape
	{
		public function Cercle(coord:Rectangle,id:String=null)
		{
			super(coord,id);
		}
		
		/*override protected function draw(evt:Event=null):void{
			super.draw(evt);
			
			var diametre:Number = Math.max(0.1,Math.floor(Math.sqrt(_coord.width^2+_coord.height^2)));
			trace("coord "+String(diametre))
			_content.graphics.drawCircle(diametre*10,diametre*10,diametre*10);
			if(!evt){
				setSize(_coord.width,_coord.height)
			}
			else{
				setSize(_content.width,_content.height)
			}
		}*/
		
		override protected function setSize(w:Number, h:Number, center:Boolean=false):void{ 
			initDraw();
			var diametre:Number = Math.max(0.1,w);
			_content.graphics.drawCircle(0,0,diametre)
				if(stage){
					_content.width = w;
					_content.height = h;
				}
			
		}
		
		
		override public function getProperties():Object{
			var obj:Object = super.getProperties();
			obj.type = "circle";
			return obj
		}
	}
}