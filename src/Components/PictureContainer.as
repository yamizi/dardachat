package Components
{
	import api.VimeoPlayer;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	import logic.ServerFunctions;
	
	import org.aswing.geom.IntDimension;
	
	public class PictureContainer extends Sprite
	{
		protected var _src:String
		protected var _player:Object;
		protected var _loader:Loader = new Loader();
		protected var _type:String="";
		[Embed(source = "/assets/ui/loader.swf")]
		protected static const LOADER_ICON:Class;
		protected var _icon:Sprite = new LOADER_ICON();
		protected var _preview:Boolean;
		protected var _w:uint;
		protected var _h:uint;
		
		public var finalDimension:IntDimension;
		
		
		public function PictureContainer(w:uint,h:uint,preview:Boolean = false)
		{
			super();
			_preview = preview
			drawEnveloppe(w,h)	
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onComplete);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,onProgress);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onIO);
			addChildAt(_loader,0)
			addChild(_icon);
			_icon.visible = false
				
			
		}
		
		public function unload():void{
			_loader.unload();
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,onComplete);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,onProgress);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,onIO);
			this._src = "";
			
		}
		
		public function loadUrl(path:String,w:uint=320,h:uint = 240):void{
			_type = "local";
			_src = path;
			var url:String = ServerFunctions.getFileScript()+"?src="+path;
			trace("path "+url);
			_loader.load(new URLRequest(url));	
			
			
			_icon.visible = true;
		}
		
		protected function onComplete(evt:Event):void{
			
			
			_icon.visible = false;
			graphics.clear();
			
			if(_preview){
				
			}
			
			else{
				trace("complete loaded "+_loader.content.width+"=>"+_w)
				if(_w){
					_loader.content.width = _w;
				}
				if(_h){
					_loader.content.height = _h;
				}
				
				
			}
			
			/*
			if(parent.parent is Picture){
				graphics.clear();
				
				
				if(finalDimension){
						drawEnveloppe(finalDimension.width,finalDimension.height);
				}
				trace("loader "+_loader.width)
		
				trace("loader "+_loader.width)
				trace("this "+width)
			}

			else{
				
				if(_loader.content.width>=_loader.content.height){
					_loader.content.height = Math.min(_loader.content.width,width)/_loader.content.width*_loader.content.height;
					_loader.content.width = Math.min(_loader.content.width,width)
				}
				else{
					_loader.content.width = Math.min(_loader.content.height,height)/_loader.content.height*_loader.content.width;
					_loader.content.height = Math.min(_loader.content.height,height)
				}
				
				
			}*/
			
			/*
			_imageLoader = addChild(new Loader()) as Loader;
			...
			var bitmap = _imageLoader.content as Bitmap;
			bitmap.scaleX = bitmap.scaleY = scaleFactor;
			bitmap.smoothing = true;
			*/
			
			/*
			var scale:Number = 0.32;
			var matrix:Matrix = new Matrix();
			matrix.scale(scale, scale);
			
			var smallBMD:BitmapData = new BitmapData(bigBMD.width * scale, bigBMD.height * scale, true, 0x000000);
			smallBMD.draw(bigBMD, matrix, null, null, null, true);
			
			var bitmap:Bitmap = new Bitmap(smallBMD, PixelSnapping.NEVER, true);
			*/
			trace(_loader.content.width );
			
		}
		
		private function onProgress(evt:ProgressEvent):void{
			
		}
		
		private function onIO(evt:IOErrorEvent):void{
			
		}
		public function get src():String{
			return _src
		}
		
		public function drawEnveloppe(w:Number,h:Number):void{
			graphics.clear();
			_w = w;
			_h= h;
			if(_src && _loader.content){
			
				trace("draw enveloppe content loaded")
				
				_loader.content.width = _w;
				_loader.content.height = _h;
				
			}
			
			else{
				trace("draw enveloppe content empty")
				graphics.beginFill(0xFFFFFF);
				graphics.lineStyle(1,0x999999,1,true);
				graphics.drawRoundRect(0,0,w,h,10,10);
				_icon.x = (w-_icon.width)/2
				_icon.y = (h-_icon.height)/2;
			}
			
			
		}
		
		public function reinit():void{
			_loader.content.scaleX = _loader.content.scaleY = 1;
		}
	}
}