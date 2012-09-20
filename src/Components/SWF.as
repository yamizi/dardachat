package Components
{
	import flash.geom.Rectangle;
	
	import logic.AnimationManager;
	
	import ui.SWFIMport;
	
	public class SWF extends Picture
	{
		//override protected var _container:SWFContainer;
		
		public function SWF(coord:Rectangle, id:String=null)
		{
			super(coord, id);
		}
		
		override public function getProperties():Object{
			var obj:Object = super.getProperties();
			obj.type = "swf";
			return obj
		}
		
		override protected function openImportPanel():void{
		
				var pictureImport:SWFIMport = new SWFIMport(this);	
				AnimationManager.removeElementById(getId());
		}
		
		override protected function buildContainer(coord:Rectangle):void{
			_container = new SWFContainer(coord.width,coord.height);
			_content.addChild(_container)
		}
		
		/*override protected function setSize(w:Number, h:Number, center:Boolean=false):void{ 
			
			if(!stage){
				w = 320;
				h = 240;
			}
			//_container.finalDimension = new IntDimension(w,h);
			_container.drawEnveloppe(w,h);
			
			trace("set size")
			_content.x = -_content.width/2;
			_content.y = -_content.height/2;
		}*/
	
	}
}