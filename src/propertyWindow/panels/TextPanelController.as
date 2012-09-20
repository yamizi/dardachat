package propertyWindow.panels
{
	import org.aswing.ASColor;
	import org.aswing.AsWingManager;

	public class TextPanelController
	{
		private var _textPanel:TextPanel
		
		public function TextPanelController(panel:TextPanel):void
		{
			_textPanel = panel;
		}
		
		public function updateTargetTextColor(value:ASColor):void{
			var main:Main = AsWingManager.getRoot() as Main;
			
			if(main.selection){
				var obj:Object = new Object();
				obj["textColor"] = value.getRGB();
				main.selection.setProperties(obj);
			}
		}
		
		public function updateTargetTextSize(value:uint):void{
			var main:Main = AsWingManager.getRoot() as Main;
			
			if(main.selection){
				var obj:Object = new Object();
				obj["textSize"] = value;
				main.selection.setProperties(obj);
			}
		}
		
		public function updateTargetText(txt:String):void{
			
			var main:Main = AsWingManager.getRoot() as Main;
			
			if(main.selection){
				var obj:Object = new Object();
				obj["txt"] = txt;
				main.selection.setProperties(obj);
			}
		}
		
		public function updatePanel(obj:Object):void{
			
			if(obj.textColor!=undefined){
				_textPanel.setTextColor(obj.textColor,100);
			}
			
			if(obj.textSize!=undefined){
				_textPanel.setTextSize(obj.textSize);
			}
			
			if(obj.txt!=undefined){
				_textPanel.setText(obj.txt);
			}
		}	
	}
}