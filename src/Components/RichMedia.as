package Components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import logic.AnimationManager;
	
	import org.aswing.AsWingManager;
	
	
	public class RichMedia extends Element
	{
		public function RichMedia(coord:Rectangle,id:String=null)
		{
			super(coord,id);
			
		}
		
		override public function setProperties(obj:Object):void{
			super.setProperties(obj);
		}
		
		
	}
}