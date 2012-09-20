package logic
{
	import Components.Box;
	import Components.Cercle;
	import Components.Element;
	import Components.Picture;
	import Components.SWF;
	import Components.Text;
	import Components.Triangle;
	import Components.Video;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.aswing.AsWingManager;
	
	public class Workspace extends Sprite
	{
		private var _content:Sprite;
		public static var lastSelectedElement:Element;
		
		
		public static function set selection(element:Element):void{
			Workspace.lastSelectedElement = element;
		}
		
		public static function get selection():Element{
			return Workspace.lastSelectedElement;
		}
		
		
		public function Workspace()
		{
			super();
			this.doubleClickEnabled = true;
			addEventListener(Event.ADDED_TO_STAGE,init);
			addEventListener(MouseEvent.CLICK,onElementClick);
			addEventListener(MouseEvent.DOUBLE_CLICK,onElementClick);
		}
		
		public function getContainer():Sprite{
			return _content;
		}
		
		private function init(evt:Event):void{
			_content = new Sprite();
			addChildAt(_content,0);
			_content.doubleClickEnabled = true;
			drawGrid();
		}
		
		private function onElementClick(evt:MouseEvent):void{
			
			
			var element:Element
			trace("->"+evt.type)
			if(evt.target is Element){
				element = evt.target as Element;
			}
			else{
				var obj:DisplayObject = evt.target as DisplayObject;
				
				while(obj && obj.hasOwnProperty("parent") && obj.parent  && !(obj is Element) ){
					
					obj = obj.parent;
				}
				element = obj as Element;
			}
	
			
			
			
			if(evt.type == MouseEvent.DOUBLE_CLICK){

				if(Workspace.lastSelectedElement){
					Workspace.lastSelectedElement.unSelect();	
				}
				if(element){
					element.elementDoubleClick(evt);
					Workspace.lastSelectedElement = element as Element;	
				}
				
			}
			
			else if(element && evt.type == MouseEvent.CLICK){
				trace("type element "+element.getProperties().type);
				element.elementClick(evt);
				
				
			}	
			
			
		}
	
		
		public function drawGrid(bool:Boolean=true):void{
			graphics.clear();
			if(bool){
				graphics.beginFill(0xFFFFFF,1);
				graphics.lineStyle(1,0,0.5);
			}
			else{
				graphics.beginFill(0xFFFFFF,1);
				graphics.lineStyle(1,0,0);
			}
			
			graphics.drawRect(0,0,3200,3200);
			
			if(bool){
				var gap:uint = 64;
				for(var i:uint=0;i<3200/gap;i++){
					graphics.moveTo(0,i*gap);
					graphics.lineTo(3200,i*gap);
					
					graphics.moveTo(i*gap,0);
					graphics.lineTo(i*gap,3200);
				}
			}
		}
		
	
		
		public function addElement(type:String,params:Object,newOne:Boolean = true):Element{
			var main:Main = (AsWingManager.getRoot() as Main)
			var center:Point = new Point(main.getWorkspacePanel().width/2,main.getWorkspacePanel().height/2)
			center = main.getWorkspace().globalToLocal(center);
			
			var pt:Object = params.position?params.position:{x:center.x,y:center.y};
			var size:Object = params.size?params.size:{x:pt.x+120,y:pt.y+50};
			
			var element:Element;
			switch(type){
				
				case "triangle": element = new Triangle(new Rectangle(pt.x,pt.y,size.x,size.y),params.id);
					break;
				case "circle": element = new Cercle(new Rectangle(pt.x,pt.y,size.x,size.y),params.id);
					break;
				case "text": element = new Text(new Rectangle(pt.x,pt.y,size.x,size.y),params.id);
					break;
				case "video": element = new Video(new Rectangle(pt.x,pt.y,size.x,size.y),params.id);
					break;
				case "image": element = new Picture(new Rectangle(pt.x,pt.y,size.x,size.y),params.id);
					break;
				case "swf": element = new SWF(new Rectangle(pt.x,pt.y,size.x,size.y),params.id);
					break;
				default: element = new Box(new Rectangle(pt.x,pt.y,size.x,size.y),params.id);
					break;
			}
			_content.addChild(element)
			//main.historyManager.registerAction(element,{},element.getProperties());
			return element;
		}
		
		public function loadContent(list:Vector.<Object>):void{
			list = list.reverse()
			trace("Ajout d'elements");
			while(_content.numChildren){
				_content.removeChildAt(0)	
			}
			
			if(list){
				for  (var i:uint=0;i<list.length;i++){
					trace("ajout de "+list[i].type);
					var element:Element = addElement(list[i].type,{position:null,size:null,id:list[i].id},false);
					//element.setSize(list[i].w,list[i]h);
					element.setProperties(list[i]);
				}
			}
		}
	}
}