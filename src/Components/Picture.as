package Components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import logic.AnimationManager;
	
	import org.aswing.AsWingManager;
	import org.aswing.geom.IntDimension;
	
	import ui.PictureImport;
	
	public class Picture extends RichMedia
	{
		protected var _container:PictureContainer
		private var _src:String;
		
		
		public function Picture(coord:Rectangle,id:String=null)
		{
			
			_content = new Sprite();
			buildContainer(coord);
			addChildAt(_content,0);
			super(coord,id);
			if(!id){
				openImportPanel()
			}
			
			
		}
		
		
		protected function buildContainer(coord:Rectangle):void{
			_container = new PictureContainer(coord.width,coord.height);
			_content.addChild(_container)
		}
		
		protected function openImportPanel():void{
			var pictureImport:PictureImport = new PictureImport(this);	
			//AnimationManager.removeElementById(getId());
		}
		
	
		override public function getProperties():Object{
			var obj:Object = super.getProperties();
			obj.type = "image";
			obj.src = _container.src
			return obj
		}
		
		override public function setProperties(obj:Object):void{
			//trace("------------------------------\n"+obj.w+"/"+obj.src+"\n------------------------------")
			if(obj.src){
				setSrc(obj.src);
				//trace(getDetails())
			}
			
			super.setProperties(obj)
			
		}
		
		override public function elementClick(evt:MouseEvent=null):void{
			displayContent()
		}
		
		 override public function displayContent():void{
			if(_container.src!=_src){
				_container.loadUrl(_src);	
				//display()
			}
		}
		
		override public function hideContent():void{
			_container.unload();
		}
		
		public function setSrc(path:String,display:Boolean = false):void{
			_src=  path;
			
			//if(display){
				displayContent();
			//}
			//_container.loadUrl(path);
		}
		
		override protected function setSize(w:Number, h:Number, center:Boolean=false):void{ 
			
			if(!stage){
				w = 320;
				h = 240;
			}
			//_container.finalDimension = new IntDimension(w,h);
			_container.drawEnveloppe(w,h);
			
			//trace("set size")
			_content.x = -_content.width/2+_decalageX;
			_content.y = -_content.height/2+_decalageY
		}
		
		override public function reinit():void{
			super.reinit();
			_container.reinit();
			_content.x = -_content.width/2+_decalageX;
			_content.y = -_content.height/2+_decalageY;
			
		}
	}
}