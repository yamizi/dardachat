package propertyWindow.panels
{
	import org.aswing.ASColor;
	import org.aswing.AsWingManager;

	public class ShapePanelController
	{
		
		private var _shapePanel:ShapePanel
		
		public function ShapePanelController(panel:ShapePanel)
		{
			_shapePanel = panel;
		}
		
		public function updateTargetFill(color:ASColor):void{
			var main:Main = AsWingManager.getRoot() as Main;
			
			if(main.selection){
				trace("color "+color.getRGB() +"--alpha:"+color.getAlpha())
				var obj:Object = new Object();
				obj["fillColor"] = color.getRGB();
				obj["fillAlpha"] = color.getAlpha()*100;
				main.selection.setProperties(obj);
			}
		}
		
		public function updateTargetLine(color:ASColor):void{
			var main:Main = AsWingManager.getRoot() as Main;
			
			if(main.selection){
				var obj:Object = new Object();
				obj["lineColor"] = color.getRGB();
				obj["lineAlpha"] = color.getAlpha()*100;
				main.selection.setProperties(obj);
			}
		}
		
		public function updateTargetLineThick(value:uint):void{
			var main:Main = AsWingManager.getRoot() as Main;
			
			if(main.selection){
				var obj:Object = new Object();
				obj["lineThick"] = value;
				main.selection.setProperties(obj);
			}
		}
		
		public function updatePanel(obj:Object):void{
			
			if(obj.lineColor!=undefined && obj.lineAlpha!=undefined){
				_shapePanel.setLineColor(obj.lineColor,obj.lineAlpha);
			}
			
			if(obj.fillColor!=undefined && obj.fillAlpha!=undefined){
				_shapePanel.setFillColor(obj.fillColor,obj.fillAlpha);
			}
			
			if(obj.lineThick!=undefined){
				_shapePanel.setLineThick(obj.lineThick);
			}
			
		}
	}
}