package propertyWindow.panels
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.aswing.ASColor;
	import org.aswing.JLabel;
	import org.aswing.JSeparator;
	import org.aswing.JSlider;
	import org.aswing.ext.Form;
	import org.aswing.ext.FormRow;
	import org.aswing.geom.IntDimension;
	import org.aswing.geom.IntPoint;
	
	import ui.buttons.ColorButton;

	public class ShapePanel extends MinimalPanel
	{
		
		private var _shapePanelController:ShapePanelController
		private var _fillColorButton:ColorButton;
		private var _lineColorButton:ColorButton;
		private var _lineThickSlider:JSlider;
		
		
		public function ShapePanel()
		{
			super();
			_shapePanelController = new ShapePanelController(this)
		}
		
		override protected function build():void{
			
			super.build();
			
			var form:Form = new Form();
			form.setPreferredSize(new IntDimension(245,120));
			this.appendForm(form);
			form.setVGap(10)
			trace("build Shape")	
			
			_lineThickSlider = new JSlider();
			_lineThickSlider.setMinimum(0);
			_lineThickSlider.setMaximum(10);
			_lineThickSlider.setShowValueTip(true);
			_lineThickSlider.setPaintTicks(true);
			_lineThickSlider.setMajorTickSpacing(1);
			_lineThickSlider.setSnapToTicks(true);
			_lineThickSlider.setPreferredSize(new IntDimension(240,20));
			
			
			var label:JLabel =new JLabel("Epaisseur de la bordure: ") 
			label.setPreferredSize(new IntDimension(140,20));
			form.appendAll(label,_lineThickSlider);
			
			var colorRow:FormRow = new FormRow();
			form.append(colorRow);
			_lineColorButton = new ColorButton("Bordure/Trait",0,100,updateTargetLine,"lineC")
			_fillColorButton = new ColorButton("Remplissage",0xFFFFFF,100,updateTargetFill,"fillC")
			
			
			colorRow.appendAll(_lineColorButton,_fillColorButton)
			colorRow.setColumnChildrenIndecis("0,1");
			
			form.append(new JSeparator());
			
			_lineThickSlider.addEventListener(MouseEvent.MOUSE_UP,updateTargetLineThick);
		} 
		
		override public function updatePanel(obj:Object):void{
			super.updatePanel(obj);
			_shapePanelController.updatePanel(obj);
		}
		
		protected function updateTargetFill(color:ASColor):void{
			_shapePanelController.updateTargetFill(color);
		}
		
		protected function updateTargetLineThick(evt:Event):void{
			_shapePanelController.updateTargetLineThick(_lineThickSlider.getValue());
		}
		
		protected function updateTargetLine(color:ASColor):void{
			_shapePanelController.updateTargetLine(color);
		}
		
		public function setLineThick(value:uint):void{
			_lineThickSlider.setValue(value);
		}
		
		public function setLineColor(color:uint,alpha:uint):void{
			_lineColorButton.setColor(color,alpha,false)
		}
		
		public function setFillColor(color:uint,alpha:uint):void{
			_fillColorButton.setColor(color,alpha,false)
		}
	}
}