package logic
{
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.FullScreenEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.aswing.AsWingManager;

	public class Fullscreen
	{
		public function Fullscreen()
		{
		}
		
		public static var playerMode:Boolean = false;
		
		
		public static function setFullScreen(evt:MouseEvent=null,forceFullScreen:Boolean=false):void{
			var app:Main = AsWingManager.getRoot() as Main;
			if(  app.stage.displayState != StageDisplayState.FULL_SCREEN ||forceFullScreen ){
				enterFullScreen();

			}
			
			else{
				app.stage.displayState = StageDisplayState.NORMAL;
				playerMode = false;
			}
							
			
			
		}
		
		private static function enterFullScreen():void{
			var app:Main = AsWingManager.getRoot() as Main;
			app.stage.scaleMode = StageScaleMode.NO_BORDER;
			app.stage.displayState = StageDisplayState.FULL_SCREEN;
			app.getWorkspace().drawGrid(false);
			app.stage.addEventListener(FullScreenEvent.FULL_SCREEN,onFullscreen);
			var pos:Point = new Point(app.getMain().x, app.getMain().y);
			pos = app.getWorkspacePanel().localToGlobal(pos)
			app.stage.fullScreenSourceRect = new Rectangle(pos.x,pos.y-50,app.getMain().width,app.getMain().height);
			trace("full screen "+app.stage.fullScreenSourceRect)
			playerMode = true;
			app.displayMenuBar(false);
		}
		
		private static function onFullscreen(evt:FullScreenEvent):void{
			
			var app:Main = AsWingManager.getRoot() as Main;
			app.stage.scaleMode = StageScaleMode.NO_SCALE;
			app.displayMenuBar(true);
			app.stage.removeEventListener(FullScreenEvent.FULL_SCREEN,onFullscreen);
		}
	}
}