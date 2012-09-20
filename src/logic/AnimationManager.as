package logic
{
	import Components.Element;
	
	import org.aswing.VectorListModel;

	public class AnimationManager
	{
		
		private static var _listElementsIds:VectorListModel = new VectorListModel([]);
		private static var _listElements:VectorListModel = new VectorListModel([]);
		private static var _currentIndex:int = -1;
		private static var _assocObject:Object= new Object();
		
		public function AnimationManager()
		{
		}
		
		public static function getElementsId():VectorListModel{
			return _listElementsIds
		}
		
		public static function appendElement(element:Element,newAnimation:Boolean=true):void{
			if(newAnimation){
				_listElementsIds.append(element.getId());
				_listElements.append(element);
			}
			
			_assocObject[element.getId()] = element;
			trace("assoc object added "+element.getId()+" "+_assocObject[element.getId()])
		}
		
		public static function getElementByIndex(index:uint):Element{
			return _listElements.get(index) as Element
		}
		
		public static function playNextElement():Element{
			if(_listElements.getSize()==0){
				return null
			}
			_currentIndex = ++_currentIndex% _listElements.getSize()
			return _listElements.get(_currentIndex);
		}
		
		public static function getElementBy(decalage:int):Element{
			
			if(Math.abs(decalage)<_listElements.getSize()-1){
				var index:uint = _currentIndex+decalage
				while(index<0){
					index +=_listElements.getSize()
				}
				index = index %_listElements.getSize()
				
				return _listElements.get(index);
			}
			
			return null
				
		}
		
		public static function removeElementById(id:String):void{
			var index:int = _listElementsIds.toArray().indexOf(id);
			if(index>-1){
				removeElementbyIndex(index);
			}
		}
		
		public static function removeElementbyIndex(index:uint):void{
			_listElements.removeAt(index);
			_listElementsIds.removeAt(index);
		}
		
		public static function loadAnimation(tbl:Array):void{
			
			_listElementsIds.clear();
			_listElements.clear();
			trace("Reconstitution ")
			for each(var id:String in tbl){
				trace("id "+id+" element "+ _assocObject[id]);
				_listElementsIds.append(id);
				_listElements.append(_assocObject[id]);
			}
		}
	}
}