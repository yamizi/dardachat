package Components
{
	import api.VimeoPlayer;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	public class VideoContainer extends Sprite
	{
		private var _id:String
		private var _player:Object;
		private var _loader:Loader = new Loader();
		private var _type:String="";
		[Embed(source = "/assets/ui/loader.swf")]
		private static const LOADER_ICON:Class;
		private var _icon:Sprite = new LOADER_ICON();
		
		
		public function VideoContainer(w:uint,h:uint)
		{
			super();
			graphics.clear();
			graphics.beginFill(0xFFFFFF);
			graphics.lineStyle(1,0x999999,1,true);
			graphics.drawRoundRect(0,0,w,h,10,10);
			_icon.x = (w-_icon.width)/2
			_icon.y = (h-_icon.height)/2;
			
			
			//Security.loadPolicyFile("vimeo.com/moogaloop/crossdomain.xml");
		}
		
		public function unload():void{
			if(_type =="vimeo"){
				var vimeo:VimeoPlayer = this.getChildAt(0) as VimeoPlayer;
				vimeo.destroy();
				removeChild(vimeo);
			}
			if(_type =="youtube"){
				_player.destroy();
				_loader.unload()
				this.removeChild(_loader);
				_loader = null;
			}
			
		}
		
		public function loadYoutube(id:String,w:uint=320,h:uint = 240):void{
			
			_id = id;
			
			if(_type =="vimeo"){
			var vimeo:VimeoPlayer = this.getChildAt(0) as VimeoPlayer;
    		vimeo.destroy();
			removeChild(vimeo);
			_type = ""
			}
			if(_type==""){
				_loader = new Loader();
				addChild(_icon);
				Security.allowDomain("www.youtube.com");
				_loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
				_loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));	
			}
			if(_type=="youtube"){
				_player.setSize(320, 240);
				_player.loadVideoById(_id);
				_player.pauseVideo()
			}
			_type = "youtube"
		}
		
		public function loadVimeo(id:String):void{
			_id = id;
			var vimeo:VimeoPlayer
			if(_type =="youtube"){
				_player.destroy();
				_loader.unload()
				this.removeChild(_loader);
				_loader = null;
				_type = ""
				
			}
			
			if(_type==""){
				Security.allowDomain('*');
				Security.allowInsecureDomain('*');
				Security.loadPolicyFile("t.vimeo.com/crossdomain.xml");
				
				vimeo = new VimeoPlayer("be40cec8adc542568a746617c60f6d99",int(_id),320,240);
				addChildAt(vimeo,0)
				vimeo.addEventListener(Event.COMPLETE, vimeoPlayerLoaded);
				addChild(_icon);
			}
			if(_type=="vimeo"){
				vimeo = this.getChildAt(0) as VimeoPlayer;
				vimeo.loadVideo(int(_id));
			}
			_type = "vimeo";
			
		}
		
		private function vimeoPlayerLoaded(evt:Event):void{
			removeChild(_icon)
		}
		
		private function onLoaderInit(event:Event):void {
			addChildAt(_loader,0);
				_loader.content.addEventListener("onReady", onPlayerReady);
				_loader.content.addEventListener("onError", onPlayerError);
				_loader.content.addEventListener("onStateChange", onPlayerStateChange);
				_loader.content.addEventListener("onPlaybackQualityChange", 
					onVideoPlaybackQualityChange);
			}
			
		private function onPlayerReady(event:Event):void {
				// Event.data contains the event parameter, which is the Player API ID 
				trace("player ready:", Object(event).data);
				removeChild(_icon)
				// Once this event has been dispatched by the player, we can use
				// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
				// to load a particular YouTube video.
				_player = _loader.content;
				_player.setSize(320, 240);
				_player.loadVideoById(_id);
			}
			
		private function onPlayerError(event:Event):void {
				// Event.data contains the event parameter, which is the error code
				trace("player error:", Object(event).data);
			}
			
		private function onPlayerStateChange(event:Event):void {
				// Event.data contains the event parameter, which is the new player state
				trace("player state:", Object(event).data);
			}
			
		private function onVideoPlaybackQualityChange(event:Event):void {
				// Event.data contains the event parameter, which is the new video quality
				trace("video quality:", Object(event).data);
			
		}
		
		public function get id():Vector.<String>{
			return new Vector.<String>([_type,_id]);
		}
	}
}