package
{

	import Components.Element;
	import Components.ToolBox;
	
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.NetConnection;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import logic.AnimationManager;
	import logic.Fullscreen;
	import logic.HistoryManager;
	import logic.MenuFunctions;
	import logic.MouseGesture;
	import logic.Workspace;
	
	import org.aswing.ASColor;
	import org.aswing.AsWingManager;
	import org.aswing.BorderLayout;
	import org.aswing.Container;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JCheckBoxMenuItem;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JLoadPane;
	import org.aswing.JMenu;
	import org.aswing.JMenuBar;
	import org.aswing.JPanel;
	import org.aswing.border.LineBorder;
	import org.aswing.border.TitledBorder;
	import org.aswing.event.InteractiveEvent;
	import org.aswing.geom.IntDimension;
	
	import propertyWindow.PropertyWindow;
	
	import ui.Menu;
	import ui.buttons.PlayButton;
	import ui.windows.HomeWindow;
	import ui.windows.LoginWindow;
	
	[SWF(backgroundColor="0xCCCCCC")]
	
	
	public class Main extends Sprite
	{
		private var _main : JFrame;
		private var _menuBar:JMenuBar
		private var _workSpacePanel: JPanel;
		private var _propertyPanel:PropertyWindow
		private var _drawCanvas:Sprite;
		private var _leftFrame:PropertyWindow;
		private var _gesture:MouseGesture;
		private var _workSpace:Workspace;
		private var _zoomTarget:Element
		public var _zoomCenter:Point
		public var currentZoom:Number=1;
		private var _finalZoom:Number=1;
		private var _finalRotation:Number = 0;
		private var _pas:Number;
		private var _nbIteration:uint = 20;
		private var _lastScale:uint = 0;
		
		private var _zoomTxt:JLabel;
		
		public var elementToolBx:ToolBox;
		public var dragContent:Boolean;
		private var _playButton:PlayButton;
		private var _mouseTimer:Timer = new Timer(500);
		
		public var historyManager:HistoryManager;
		public var id:String;
		public var login:String;
		public var pass:String;
		private var _fileName:String = "";
		private var _logo:Loader
		
		public static var debugLevel:uint = 2	
		
		public function Main()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			AsWingManager.initAsStandard(this)
			graphics.beginFill(0,0);
			graphics.drawRect(0,0,1300,660)
			
			
			_logo = new Loader();
			_logo.load(new URLRequest("assets/ui/banniere.png"))
			addChild(_logo);
			_logo.x = (width-530)/2
			_logo.y = 70
			
			//UIManager.setLookAndFeel(new SkinBuilderLAF());  
			//initHome()
			initLogin()
			//initPresentation();
		}
		
		public function get menuBar():JMenuBar{
			return _menuBar
		}
		
		public function set fileName(str:String):void{
			_fileName = str;
			_main.setTitle(str);
		}
		
		public function get fileName():String{
			return _fileName.substr(0,_fileName.lastIndexOf("[")>=0?_fileName.lastIndexOf("[")-1:int.MAX_VALUE);
		}
		
		private function initLogin():void{
			if(_main){
				_main.dispose();
			}
			_main = new LoginWindow(this)
			_main.alpha = 0
			Tweener.addTween(_main,{alpha:1,time:1});
		}
		
		public function initHome():void{
			if(_main){
				_main.dispose();
			}
			if(_logo){
				_logo.unload();
				removeChild(_logo);
				_logo = null
			}
			_main = new HomeWindow(this) //as JFrame 
			_main.alpha = 0
			Tweener.addTween(_main,{alpha:1,time:1});
		}
		
		public function initPresentation(evt:Event=null,workspace:Vector.<Object>=null,animation:Array=null,filenm:String="Sans Nom",mode:String= "editor"):void{
			
			historyManager = new HistoryManager();
			if(_main){
				_main.dispose();
			}
			
			_main= new JFrame( null, "" );
			_main.setMideground(new ASColor(0xF2F2F2))
			_main.setSize(new IntDimension( stage.stageWidth-275, stage.stageHeight ) );
			_main.setClosable(false)
			//_main.setResizable(false)
			_main.setDragable(false);
			_main.getContentPane().setLayout(new BorderLayout());
			_main.show();	
			_main.alpha = 0
			
			Tweener.addTween(_main,{alpha:1,time:1});
			
			_propertyPanel = new PropertyWindow(275, stage.stageHeight,stage.stageWidth-275);
			_propertyPanel.show();
			
			var menuBar_Panel:JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			_main.getContentPane().append(menuBar_Panel,BorderLayout.NORTH)
			var mc:JFrame = new JFrame(null,"test");
			menuBar_Panel.append(mc)
			
			_menuBar = new JMenuBar();
			_menuBar.setBorder(new LineBorder(null,new ASColor(0x26AE90),2,5))
			_menuBar.addMenu(new Menu("Fichier",["Enregister",MenuFunctions.saveDocument,"Ouvrir",MenuFunctions.openDocument]));
			_menuBar.addMenu(new Menu("Edition",["Undo",historyManager.undo,"Redo",historyManager.redo]));
			_menuBar.addMenu(new Menu("Insertion",["Text",MenuFunctions.insertText,"Image",MenuFunctions.insertImage,"Swf",MenuFunctions.insertSwf,"Video",MenuFunctions.insertVideo]));
			_menuBar.addMenu(new Menu("A propos",[]));
			menuBar_Panel.append(_menuBar)
			_zoomTxt = new JLabel("Zoom :100%");
			_zoomTxt.setWidth(120);
			_menuBar.append(_zoomTxt);
			
			var _enableGrid:JCheckBoxMenuItem = new JCheckBoxMenuItem("Afficher Grille");
			_enableGrid.setSelected(true)
			_enableGrid.addEventListener(InteractiveEvent.SELECTION_CHANGED,updateGrid);
			_menuBar.append(_enableGrid);
		
			
			var _fullscreenButton:JCheckBoxMenuItem = new JCheckBoxMenuItem("Plein ecran");
			_fullscreenButton.addEventListener(MouseEvent.CLICK,Fullscreen.setFullScreen);
			_menuBar.append(_fullscreenButton);
				
			_workSpacePanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
			//_workSpacePanel.setBorder(new TitledBorder(null,"Espace de travail"));
			_main.getContentPane().append(_workSpacePanel,BorderLayout.CENTER);
			_workSpace = new Workspace();
			
			_workSpacePanel.addChild(_workSpace)
			_workSpacePanel.addEventListener(MouseEvent.MOUSE_WHEEL,onWheel);
			
			_playButton = new PlayButton();
			_main.getContentPane().addChild(_playButton);
			_playButton.y =15
			_playButton.x = 5;
			
			_drawCanvas = new Sprite();
			_drawCanvas.mouseEnabled = false;
			stage.addChild(_drawCanvas);			
			_gesture = new MouseGesture(_drawCanvas,_workSpace);
			_zoomCenter = new Point(550,300) ;
			
			
			Tweener.init();
			this.addEventListener(KeyboardEvent.KEY_UP,onKey_Down);
			this.addEventListener(MouseEvent.CLICK, onClick);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			elementToolBx = new ToolBox();
			_workSpace.addChild(elementToolBx);
			
			if(workspace){
				_workSpace.loadContent(workspace);	
			}
			
			if(animation){
				AnimationManager.loadAnimation(animation);
			}
			fileName = filenm;
		}
		
		
		private function updateGrid(evt:InteractiveEvent):void{
			_workSpace.drawGrid((evt.target as JCheckBoxMenuItem).isSelected());
		}

		
		public function getMain():Container{
			return _main.getContentPane();
		}
		
		public function getWorkspace():Workspace{
			return _workSpace;
		}
		
		public function displayMenuBar(d:Boolean):void{
			_menuBar.setVisible(d);
		}
		public function getWorkspacePanel():JPanel{
			return _workSpacePanel
		}
		
		private function onMouseMove(evt:MouseEvent):void {
			Mouse.show();
			_mouseTimer.reset();
			_mouseTimer.start();
			_mouseTimer.addEventListener(TimerEvent.TIMER, onMouseTimer);
		}
		
		private function onMouseTimer(evt:TimerEvent):void {
			Mouse.hide();
		}
		
		private function onWheel(evt:MouseEvent):void{
			_zoomCenter = new Point(evt.stageX,evt.stageY) ;
			_zoomTarget = null
			zoom(1+evt.delta/30)
			currentZoom *= 1+evt.delta/30
		}
		
		private function onClick(evt:MouseEvent):void {
			if(stage.displayState == StageDisplayState.FULL_SCREEN){
				playAnimation();
			}
		}
		private function onKey_Down(evt:KeyboardEvent):void{
			if(evt.keyCode==Keyboard.CONTROL){
				_workSpace.startDrag(false)
				dragContent = true;
				//cursor.visible = true;
				Mouse.cursor = MouseCursor.HAND
			
			}
			
			this.removeEventListener(KeyboardEvent.KEY_DOWN,onKey_Down);
			this.addEventListener(KeyboardEvent.KEY_UP,onKey_Up);	
			
			
			
		}
		
		public function playAnimation():void{
			trace("animation");
			var nextTarget:Element = AnimationManager.playNextElement();
			if(nextTarget){
				var finalWidth:Number = nextTarget.getRealSize().width
				var finalHeight:Number = nextTarget.getRealSize().height
				var amount:Number = Math.min(getWorkspacePanel().width/Math.abs(finalWidth),(getWorkspacePanel().height-20)/Math.abs(finalHeight))		
				zoomAt(amount,nextTarget)
			}
			
			var next:Element = AnimationManager.getElementBy(2)
			if(next){
				//next.displayContent()
			}
			
			var prev:Element = AnimationManager.getElementBy(-2)
			if(prev && stage.displayState == StageDisplayState.FULL_SCREEN){
				//prev.hideContent()
			}
			
		}
		
		private function onKey_Up(evt:KeyboardEvent):void{
			if(evt.keyCode==Keyboard.CONTROL){
				_workSpace.stopDrag()
				dragContent = false;
				Mouse.cursor = MouseCursor.ARROW
				//cursor.visible = false;
				
			}
			trace("key pressed "+evt.keyCode);
			
			if(evt.keyCode==Keyboard.F1){
				playAnimation();
			}
			
			if(evt.keyCode ==Keyboard.SPACE && stage.displayState == StageDisplayState.FULL_SCREEN){
				_playButton.onClick()
			}
			
			if(evt.keyCode==Keyboard.RIGHT && stage.displayState == StageDisplayState.FULL_SCREEN){
				playAnimation();
			}
				
			else if(evt.keyCode==Keyboard.LEFT && stage.displayState == StageDisplayState.FULL_SCREEN){
				if(_zoomTarget){
					var index:uint = _zoomTarget.parent.getChildIndex(_zoomTarget);
					if(index>0){
						var nextTarget:Element = _zoomTarget.parent.getChildAt(index-1) as Element
						var finalWidth:Number = nextTarget.getRealSize().width
						var finalHeight:Number = nextTarget.getRealSize().height
						var amount:Number = Math.min(getWorkspacePanel().width/Math.abs(finalWidth),(getWorkspacePanel().height-20)/Math.abs(finalHeight))		
						zoomAt(amount,nextTarget)
					}
				}
			}
			
			this.addEventListener(KeyboardEvent.KEY_DOWN,onKey_Down);
			this.removeEventListener(KeyboardEvent.KEY_UP,onKey_Up);	
			
		}
		
		public function zoomAt( scale : Number, target:Element) : void
		{
			var index:uint = target.parent.getChildIndex(target);
			/*if(index<target.parent.numChildren-1){
				(target.parent.getChildAt(index+1) as Element).displayContent()
			}
			
			if(index>3){
				(target.parent.getChildAt(index-3) as Element).hideContent()
			}*/
		
			_finalZoom = scale;
			_zoomTarget = target
			
			var rot:Number = (_zoomTarget.rotation/180*Math.PI);
			var rotDeg:Number =  rot>Math.PI?(rot-2*Math.PI)*180/Math.PI:rot*180/Math.PI;
			
			var rotationBefore_Center:Number = _workSpace.rotation;
			var scaleBefore_Center:Number = _workSpace.scaleX;
			
			_workSpace.scaleX=_workSpace.scaleY=scale;
			
			var targetRotation:Number;	
			/*if(_workSpace.rotation+_zoomTarget.rotation >360){
				targetRotation = _zoomTarget.rotation-360;
			}
			else if(_workSpace.rotation+_zoomTarget.rotation <-360){
				targetRotation = _zoomTarget.rotation+360;
			}
			else{*/
				targetRotation = _zoomTarget.rotation;
			//}
					
			_workSpace.rotation = -targetRotation;
			
			var final:Point = _workSpacePanel.localToGlobal(new Point(_workSpacePanel.width/2,_workSpacePanel.height/2));
			//trace("final "+final);
			var pos:Point = _zoomTarget.localToGlobal(new Point(0,0));
			//trace("point "+pos);
			
			var dest:Point = new Point(final.x-pos.x,final.y-pos.y)
			//trace("destination "+dest);
			dest = new Point(dest.x+_workSpace.x,dest.y+_workSpace.y)
			
			_workSpace.scaleX=_workSpace.scaleY=scaleBefore_Center
			_workSpace.rotation = rotationBefore_Center;
			
			trace(targetRotation);
			var time:int = 2;
			if (Math.abs(_workSpace.rotation -Math.abs(targetRotation)) < 30) {
				time = 3;
			}
			Tweener.addTween(_workSpace,{rotation:-targetRotation, time:2, transition:"easeOutCubic"})
			Tweener.addTween(_workSpace,{x:dest.x,y:dest.y, time:2, transition:"easeOutQuad"})		
			Tweener.addTween(_workSpace,{scaleX:scale,scaleY:scale, time:2, transition:"easeOutQuad"})		
		}
		
		
		public function zoom(value:Number=0):void{
			
			//trace("zoom "+currentZoom)	
			_zoomTxt.setText("Zoom: "+Math.ceil(_workSpace.scaleX*100)+"%")
				
			if(!value){
				trace("zoom "+_workSpace.scaleX) 
				var finalX:int = -_zoomTarget.x*_workSpace.scaleX+_workSpacePanel.width/2
				var finalY:int = -_zoomTarget.y*_workSpace.scaleY+_workSpacePanel.height/2;
				currentZoom = _workSpace.scaleX;
				var r:Number =  0//1-currentZoom/_finalZoom
				_workSpace.x = _workSpace.x*r+finalX*(1-r);
				_workSpace.y = _workSpace.y*r+finalY*(1-r);
				//Tweener.addTween(_workSpace, {x:finalX, y:finalY, time:3, transition:"linear"});
			}
			
				
			else{
				
				if(_zoomTarget){
					_zoomCenter.x = _zoomTarget.x
					_zoomCenter.y = _zoomTarget.y
					_zoomCenter = _workSpace.localToGlobal(_zoomCenter);	
				}
			
				// get the transformation matrix of this object
				var affineTransform:Matrix = _workSpace.transform.matrix
				
				
				// move the object to (0/0) relative to the origin
					
				affineTransform.translate( -_zoomCenter.x, -_zoomCenter.y )
				
				// scale
				affineTransform.scale( value, value )
				
				// move the object back to its original position
				affineTransform.translate( _zoomCenter.x, _zoomCenter.y )
				
				
				// apply the new transformation to the object
				_workSpace.transform.matrix = affineTransform
			}
			
		}
		
		public function set selection(element:Element):void{
			var el:Element = Workspace.lastSelectedElement;
		
			if(el){
				el.unSelect();
				Workspace.lastSelectedElement = element
				
			}
			if(element){
				Workspace.lastSelectedElement = element
				_propertyPanel.setProperties(element.getProperties());	
				element.select()
			}
			
			else{
				_propertyPanel.setProperties(null)
			}
			
		}
		
		public function get selection():Element{
			return Workspace.lastSelectedElement;
		}
		
		public function loadContent(list:Vector.<Object>):void{
			_workSpace.loadContent(list);			
		}
		

	}
}