package ui
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.LoaderContext;
	
	import org.aswing.LoadIcon;
	
	public class ProgressIcon extends LoadIcon
	{
		public function ProgressIcon()
		{
			var w:uint = 100
			super("assets/ui/loading.swf", w, w, true, null);
			//this.getLoader().x = w/2;
			//this.getLoader().y = w/2;
			
		}
		
		public function stop(evt:Event=null):void{
			var movie:MovieClip = this.getLoader().content["getChildAt"](0) as MovieClip
			movie.gotoAndStop(movie.totalFrames);
			movie.getChildAt(0)["stop"]()
				trace("num "+movie.numChildren);
			//(this.getLoader().content as MovieClip).stop()
			trace('frame '+this.getAsset().stage.frameRate)
		}
	}
}