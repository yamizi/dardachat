package Components
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	
	import logic.AnimationManager;
	import logic.Fullscreen;
	import logic.Workspace;
	
	import org.aswing.AsWingManager;
	import org.aswing.geom.IntDimension;
	
	public class Element extends Sprite
	{
		
		protected var _type:String
		
		protected var _content:Sprite;
		
		public var enableKeyframe:Boolean = true 
		protected var _app:Main
		private var _id:String;
		protected var _decalageX:int = 0;
		protected var _decalageY:int= 0;
		
		public function Element(coord:Rectangle,id:String=null)
		{
			super();
			_app = AsWingManager.getRoot() as Main
				
			//graphics.beginFill(0xFF0000);
			//graphics.drawCircle(0,0,1);	
			
			this.addEventListener(MouseEvent.MOUSE_OVER,showTools);	
			this.doubleClickEnabled = true	
			//this.mouseChildren = false;
				
			var obj:Object = {w:Math.abs(coord.width-coord.x),h:Math.abs(coord.height-coord.y)}
			obj.posx = coord.x+obj.w/2;
			obj.posy = coord.y+obj.h/2;
			
			setProperties(obj);
			if(id){
				_id =  id;
			}
			else{
				_id = buildId();
			}
			
			AnimationManager.appendElement(this,false);
			//addEventListener(Event.ADDED_TO_STAGE,draw);
		}
		

		private function buildId():String{
			
			var output:String = "";
			var characters:String = "abcdefghijklmnopqrstuvwxyz0123456789";
			var length:uint = characters.length
			for(var i:uint=0;i<10;i++){
				output += characters.charAt(int(Math.random()*length));
			}
			return output; 
		}
		
		public function getId():String{
			return this.getProperties().type+"_"+_id;
		}
		protected function setSize(w:Number,h:Number,center:Boolean = false):void{
			
			_content.width = w;
			_content.height =h;
		
			_content.x = -w/2+_decalageX;
			_content.y = -h/2+_decalageY;
			//trace("width :"+w+ " height: "+h)
			
		}
		
		protected function setPosition(posx:Number,posy:Number):void{
			//trace("posx :"+posx+ " posy: "+posy)
			x = posx;
			y = posy;
			_app.elementToolBx.target = this
		}
		
		public function getProperties():Object{
			var obj:Object = new Object();
			obj.id = _id
			obj.posx = x;
			obj.posy = y;
			obj.decalageX = _decalageX;
			obj.decalageY = _decalageY;
			obj.rotation = rotation;
			if(_content){
				obj.w = _content.width*scaleX;
				obj.h = _content.height*scaleY;
			}
			else{
				obj.w = width*scaleX;
				obj.h = height*scaleY;
			}
			
			return obj
		}
		
		public function setProperties(obj:Object):void{
			
			if(Main.debugLevel>1){
				trace("--------------------\nset Props")
				for(var prop:String in obj){
					trace("=>"+prop+":"+obj[prop]);
				}
			}	
				if(stage){
					trace("register update")
					_app.historyManager.registerAction(this,this.getProperties(),obj)	
				}
				else{
					trace("register new")
					_app.historyManager.registerAction(this,{},obj)		
				}
			
			var props:Object = getProperties();
			
			if(obj.decalageX!=undefined){
				trace("decalage modifié ancien"+_decalageX +" nouveau "+ obj.decalageX )
				_decalageX = obj.decalageX;
				setSize(props.w,props.h);
			}
			
			if(obj.decalageY!=undefined){
				_decalageY = obj.decalageY;
				setSize(props.w,props.h);
			}
			
			
			
			if(obj.w!=undefined && obj.h!=undefined){
				setSize(obj.w,obj.h);
			}
			else if (obj.w!=undefined ){
				setSize(obj.w,props.h);
			}
			
			else if(obj.h!=undefined){
				setSize(props.w,obj.h);
			}
			
			
			if(obj.posx!=undefined && obj.posy!=undefined){
				setPosition(obj.posx,obj.posy);
			}
			else if (obj.posx!=undefined ){
				setPosition(obj.posx,props.posy);
			}
				
			else if(obj.posy!=undefined){
				setPosition(props.posx,obj.posy);
			}
				
			
			if(obj.rotation!=undefined && obj.rotation!=props.rotation){
				rotation = obj.rotation 
			}
			
			
			if(obj.id!=undefined && obj.id!=props.id){
				_id = obj.id 
			}
			
			
			//trace("final w:"+w+" h:"+h+" posx:"+posx+" posy:"+posy);
			//trace(this.toString())
		}
		
		public function refresh():void{
			setProperties({});
			_app.selection = this
		}
		
		protected function draw(evt:Event=null):void{
			
/*			if(_content){
				this.removeChild(_content);
			}
			else{
				drawTools()
			}
			
	*/		

		}
		
		protected function showTools(evt:MouseEvent):void{
			//parent.swapChildren(this,parent.getChildAt(parent.numChildren-1))
			if(Fullscreen.playerMode){
			_app.elementToolBx.target = null
			}
			else{
				_app.elementToolBx.target = this
			}
		}
		
		
		protected function drawTools():void{
			/*
			//addChild(_toolBox);
			var marker:Sprite = new Sprite();
			marker.graphics.beginFill(0xFF0000);
			marker.graphics.drawCircle(0,0,2);
			addChild(marker)*/
			
		}
		
		public function hide():void{
			_app.selection = null
			this.visible = false;
			_app.elementToolBx.target = null
			AnimationManager.removeElementById(getId());
		}
		
		public function display():void{
			
			_app.selection = this
			this.visible = true;
			_app.elementToolBx.target = this
			AnimationManager.appendElement(this);
		}
		
		public function destroy():void{
			_app.elementToolBx.target = null
			_app.selection = null
			parent.removeChild(this);
		}
		
		public function elementClick(evt:MouseEvent=null):void{
			
			/*_app.selection = this;
			var amount:Number = Math.min(_app.getWorkspacePanel().width/width,(_app.getWorkspacePanel().height-20)/height)
			_app.zoomAt(amount,this);
			*/
		}
		
		public function elementDoubleClick(evt:MouseEvent=null):void{
			
			_app.selection = this;
			//var amount:Number = Math.min(_app.getWorkspacePanel().width/width,(_app.getWorkspacePanel().height-20)/height)
			//_app.zoomAt(amount,this);
			trace(this)
			
		}
		
		public function getRealSize():IntDimension{
			return new IntDimension(_content.width,_content.height);
		}
		
		public function unSelect():void{
			filters = []
		
		}
		
		public function select():void{
			filters = [new GlowFilter()]
		}
		
		public function displayContent():void{
			
			
		}
		
		public function hideContent():void{
			
		}
		
		public function reinit():void{
			rotation = 0;
			
		}
		
		public function moveForward():void{
			var index:uint = parent.getChildIndex(this);
			if(index<parent.numChildren-1){
				parent.setChildIndex(this,index+1);
			}
		}
		
		public function moveBackward():void{
			var index:uint = parent.getChildIndex(this);
			if(index>0){
				parent.setChildIndex(this,index-1);
			}
		}
		
		override public function toString():String{
			var output:String = "";
			output = "id: "+_id
			
			return output;
		} 
		
		public function getDetails():String{
			var output:String = "";
			var prop:String
			var obj:Object  = this.getProperties()
			output+="\nProperties:";
			for(prop in obj){
				output+="\n=>"+prop+":"+obj[prop];
			}
			return output
		}
		
	}
}