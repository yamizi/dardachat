package Components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import logic.AnimationManager;
	
	import org.aswing.AsWingManager;
	
	import ui.VideoImport;
	
	public class Video extends RichMedia
	{
		private var _container :VideoContainer;
		public function Video(coord:Rectangle,id:String=null)
		{
			_content = new Sprite();
			_container = new VideoContainer(320,240);
			_content.addChild(_container)
			addChildAt(_content,0);
			super(coord,id);
			
			if(!id){
				AnimationManager.removeElementById(getId());
				var videoImport:VideoImport = new VideoImport(this);	
			}
				
			
			
			
		}
		
		override protected function setSize(w:Number, h:Number, center:Boolean=false):void{ 
			
			if(!stage){
				h = 240;
				w = 320;
			}
			_container.width = w;
			_container.height =h;
			
			_content.x = -w/2+_decalageX;
			_content.y = -h/2+_decalageY;
		}
		
		public function load(id:String,type:String):void{
			switch(type){
				case "youtube": _container.loadYoutube(id); break;
				case "vimeo": _container.loadVimeo(id); break;
				
			}
			//AnimationManager.appendElement(this);
		}
		
		override public function getProperties():Object{
			var obj:Object = super.getProperties();
			obj.type = "video";
			obj.src = _container.id?_container.id:""
			return obj
		}
		

	}
}