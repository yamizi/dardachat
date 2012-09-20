package Components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	
	public class Shape extends Element
	{
		protected var _lineColor:uint=0
		protected var _lineAlpha:uint = 100;
		protected var _lineThick:uint=2
		protected var _fillColor:uint=0xFFFFFF;
		protected var _fillAlpha:uint=100
		public function Shape(coord:Rectangle,id:String=null)
		{
			_content = new Sprite();
			addChildAt(_content,0);
			_content.doubleClickEnabled = true
				
			super(coord,id);
		}
		
		override public function setProperties(obj:Object):void{
			
				var props:Object = getProperties();
				super.setProperties(obj);
				_lineColor =  obj.lineColor!=undefined?obj.lineColor:props.lineColor;
				_lineAlpha = obj.lineAlpha!=undefined?obj.lineAlpha:props.lineAlpha;
				_lineThick = obj.lineThick!=undefined?obj.lineThick:props.lineThick;
				_fillAlpha = obj.fillAlpha!=undefined?obj.fillAlpha:props.fillAlpha;
				_fillColor = obj.fillColor!=undefined?obj.fillColor:props.fillColor;
				var w:Number = obj.w!=undefined?obj.w:props.w;
				var h:Number = obj.h!=undefined?obj.h:props.h;
				setSize(w,h);
				trace("_fill "+_fillColor+"/"+obj.fillColor)
				
				
				
		}
		
		protected function initDraw():void{
			_content.graphics.clear();
			_content.graphics.lineStyle(_lineThick,_lineColor,_lineAlpha/100,true);
			_content.graphics.beginFill(_fillColor,_fillAlpha/100);
		}
		
		override public function getProperties():Object{
			var obj:Object = super.getProperties();
			obj.lineColor =  _lineColor;
			obj.lineAlpha = _lineAlpha;
			obj.lineThick = _lineThick;
			obj.fillAlpha = _fillAlpha;
			obj.fillColor = _fillColor;
			obj.type = "shape";
			return obj
		}
		
		override protected function draw(evt:Event=null):void{
			super.draw();
		}
	}
}