package logic
{
	import Components.Element;
	
	import flash.display.Sprite;
	
	import logic.Workspace;
	
	import org.aswing.AsWingManager;
	
	public class Action
	{
		private var _target:Element;
		private var _type:String;
		private var _oldValue:Object;
		private var _newValue:Object
		public function Action(target:Element,oldValue:Object,newValue:Object)
		{
			registerAction(target,oldValue,newValue);
		}

		public function registerAction(target:Element,oldValue:Object,newValue:Object):void{
			_target = target;
			_oldValue = oldValue;
			_newValue = newValue;
		}
		
		public function undo():void{
			var main:Workspace = (AsWingManager.getRoot() as Main).getWorkspace();
			
			if(!_oldValue.type){
				_target.hide()
				trace("undo creation");
			}
			else{
				trace("undo property");
		//		trace("Prop:\n"+this.toString())
				_target.setProperties(_oldValue);
			}
		}
		
		public function redo():void{
			var main:Workspace = (AsWingManager.getRoot() as Main).getWorkspace();
			if(!_target.visible){
				_target.display()
				
			}
			else{
				trace("redo property");
				if(_target.stage){
					_target.setProperties(_newValue);	
				}
				else{
					var mc:Sprite =  main.getChildAt(0) as Sprite
					_target =mc.getChildAt(mc.numChildren-1) as Element
				}
				
			}
		}
		
		public function toString():String{
			var output:String = "";
			var prop:String 
			output+="target :"+_target;
			output+="\noldValue:";
			for(prop in _oldValue){
				output+="\n=>"+prop+":"+_oldValue[prop];
			}
			
			output+="\nnewValue:";
			for(prop in _newValue){
				output+="\n=>"+prop+":"+_newValue[prop];
			}
			return output;
		} 
	}
}