package Components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class SWFContainer extends PictureContainer
	{
		public function SWFContainer(w:uint, h:uint,preview:Boolean = false)
		{
			super(w, h,preview);
		}
		
		/*override public function drawEnveloppe(w:Number,h:Number):void{
			graphics.clear();
			trace("resize swf")
			if(_src){
				
				var scale:Number = Math.max(w/_loader.width,h/_loader.height);
				
				scaleX =scale;
				scaleY =scale; 
			}
				
			else{
				graphics.beginFill(0xFFFFFF);
				graphics.lineStyle(1,0x999999,1,true);
				graphics.drawRoundRect(0,0,w,h,10,10);
				_icon.x = (w-_icon.width)/2
				_icon.y = (h-_icon.height)/2;
			}
			
		}
		*/
		override protected function onComplete(evt:Event):void{
			
			super.onComplete(evt);
			
			if(!_preview){
				var mc:MovieClip = _loader.content["getChildAt"](0) as MovieClip
					if(mc && mc.totalFrames>1){
						mc.addEventListener(MouseEvent.CLICK,playContent);
						this.buttonMode = true;
					}
				
			}
			
		}
		
		private function playContent(evt:MouseEvent):void{
			var target:MovieClip = evt.currentTarget as MovieClip;
			target.play();
		}
			
		
	}
}