package propertyWindow.panels
{
	import org.aswing.AsWingManager;
	
	
	public class MinimalPanelController
	{
		private var _minimalPanel:MinimalPanel
		
		public function MinimalPanelController(panel:MinimalPanel)
		{
			_minimalPanel = panel;
		}
		
		public function forwardElement():void{
			var main:Main = AsWingManager.getRoot() as Main;
			if(main.selection){
				main.selection.moveForward();
			}
		}
		
		
		public function backwardElement():void{
			var main:Main = AsWingManager.getRoot() as Main;
			if(main.selection){
				main.selection.moveBackward();
			}
		}
		
		public function undo():void{
			var main:Main = AsWingManager.getRoot() as Main;
			main.historyManager.undo();
		}
		
		public function reinitElement():void{
			var main:Main = AsWingManager.getRoot() as Main;
			if(main.selection){
				main.selection.reinit();
			}
		}
		
		
		public function redo():void{
			var main:Main = AsWingManager.getRoot() as Main;
			main.historyManager.redo();
		}
		
		public function deleteElement():void{
			var main:Main = AsWingManager.getRoot() as Main;
			if(main.selection){
				main.selection.hide();
			}
		}
		
		public function updateTarget(prop:String,value:Number):void{
			var main:Main = AsWingManager.getRoot() as Main;
			
			if(main.selection){
				var obj:Object = new Object();
				obj[prop] = value;
				main.selection.setProperties(obj);
			}
		}
		
		public function updatePanel(obj:Object):void{
			if(obj.posx!=undefined){
				_minimalPanel.setXStepper(obj.posx);
			}
			
			if(obj.posy!=undefined){
				_minimalPanel.setYStepper(obj.posy);
			}
			
			if(obj.w!=undefined){
				_minimalPanel.setWidthStepper(obj.w);
			}
			
			if(obj.h!=undefined){
				_minimalPanel.setHeightStepper(obj.h);
			}
			
			if(obj.decalageX!=undefined){
				_minimalPanel.setdecalageXSlider(obj.decalageX);
			}
			
			if(obj.decalageY!=undefined){
				_minimalPanel.setdecalageYSlider(obj.decalageY);
			}
		}
	}
}