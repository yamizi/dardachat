package logic
{
	import Components.Element;
	
	import flash.events.Event;
	
	import org.aswing.AsWingManager;

	public class HistoryManager
	{
		private var _actionList:Vector.<Action> = new Vector.<Action>();
		private var _currentIndex:int = -1;
		private var _action:String = "";
		public function HistoryManager()
		{
		}
		
		public function registerAction(target:Element,oldValue:Object,newValue:Object):void{
			if(_action==""){
				if(_currentIndex<_actionList.length-1){
					_actionList = _actionList.slice(0,_currentIndex+1);
				}
				var action:Action = new Action(target,oldValue,newValue);
				_actionList.push(action);
				_currentIndex = _actionList.length-1
				
				trace("register "+_currentIndex+ " from "+ (_actionList.length-1));
				
			}
			_action = ""
				if((AsWingManager.getRoot() as Main).fileName){
					(AsWingManager.getRoot() as Main).fileName = (AsWingManager.getRoot() as Main).fileName+ " [Modifications non sauvegardées]"	
				}
			
		}
		
		public function undo(evt:Event=null):void{
			//trace(_actionList.length);
		
			if(_currentIndex>=0){
				_action="undo"
				_actionList[_currentIndex].undo();
				_currentIndex--;
			}
			trace("undo "+_currentIndex+" from "+(_actionList.length-1));
			_action = ""
		}
		
		public function redo(evt:Event=null):void{
			
			if(_currentIndex<_actionList.length-1){
				_action="redo"
				_currentIndex++;
				_actionList[_currentIndex].redo();
			}
			trace("redo "+_currentIndex+" from "+(_actionList.length-1));
			_action = ""
		}
	}
}