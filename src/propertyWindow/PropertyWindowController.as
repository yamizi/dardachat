package propertyWindow
{
	import Components.Element;
	
	import logic.AnimationManager;
	
	import org.aswing.AsWingManager;
	
	import propertyWindow.panels.MinimalPanel;
	import propertyWindow.panels.ShapePanel;
	import propertyWindow.panels.TextPanel;
	

	public class PropertyWindowController
	{
		private var _propertyWindow:PropertyWindow ;
		
		private var _lastType:String = "";
		
		public function PropertyWindowController(propertyWindow:PropertyWindow)
		{
			_propertyWindow = propertyWindow;
		}
		
		public function onSelectedAnimatedElement(index:uint):void{
			var main:Main = AsWingManager.getRoot() as Main;
			var selectedElement:Element = AnimationManager.getElementByIndex(index);
			main.selection = selectedElement
			trace("element selected "+selectedElement);
		}
		
		
		public function setProperties(obj:Object):void{
			
			
			if(obj){
				
				if(obj.type != _lastType){
					
					switch(obj.type){
					
						case "triangle" :  _propertyWindow.setPanel(new ShapePanel()); break;
						case "box" :  _propertyWindow.setPanel(new ShapePanel()); break;
						case "circle" :  _propertyWindow.setPanel(new ShapePanel()); break;
						case "text" :  _propertyWindow.setPanel(new TextPanel()); break;
						
						default : _propertyWindow.setPanel(new MinimalPanel()); break;
					}
				}
				
				_propertyWindow.getCurrentPanel().updatePanel(obj);
								
				
			}
		}
		
		
	}
}