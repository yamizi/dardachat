package
{
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.Security;
	
	public class testApi extends Sprite
	{
		// The player SWF file on www.dailymotion.com needs to communicate with your host
		// SWF file. Your code must call Security.allowDomain() to allow this communication.
		Security.allowDomain("www.dailymotion.com");
		
		// This will hold the API player instance once it is initialized.
		public var player:Object;
		
		public var loader:Loader = new Loader();
		
		public function testApi()
		{
			this.loader.contentLoaderInfo.addEventListener(Event.INIT, this.onLoaderInit);
			this.loader.load(new URLRequest("http://www.dailymotion.com/swf?enableApi=1"));
		}
		
		public function onLoaderInit(event:Event):void
		{
			addChild(this.loader);
			this.loader.content.addEventListener("onReady", this.onPlayerReady);
			this.loader.content.addEventListener("onError", this.onPlayerError);
			this.loader.content.addEventListener("onStateChange", this.onPlayerStateChange);
		}
		
		public function onPlayerReady(event:Event):void
		{
			// Event.data contains the event parameter, which is the Player API ID
			trace("player ready:", Object(event).data.playerId);
			
			// Save a reference to this player's instance
			this.player = this.loader.content;
			
			// Set appropriate player dimensions for your application
			this.player.setSize(480, 270);
			
			// Once this event has been dispatched by the player, we can use
			// cueVideoById, loadVideoById, cueVideoByUrl and loadVideoByUrl
			// to load a particular Dailymotion video.
			this.player.loadVideoById("xcv6dv");
		}
		
		public function onPlayerError(event:Event):void
		{
			// Event.data contains the event parameter, which is the error code
			trace("player error:", Object(event).data);
		}
		
		public function onPlayerStateChange(event:Event):void
		{
			// Event.data contains the event parameter, which is the new player state
			trace("player state:", Object(event).data);
		}
	}
}