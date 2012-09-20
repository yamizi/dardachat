package propertyWindow.panels
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.JSeparator;
	import org.aswing.JSlider;
	import org.aswing.JStepper;
	import org.aswing.LayoutManager;
	import org.aswing.ext.Form;
	import org.aswing.ext.FormRow;
	import org.aswing.geom.IntDimension;
	import org.aswing.geom.IntPoint;
	
	public class MinimalPanel extends JPanel
	{
		
		protected var _xStepper:JStepper;
		protected var _decalagexSlider:JSlider;
		protected var _widthStepper:JStepper;
		protected var _yStepper:JStepper;
		protected var _decalageySlider:JSlider;
		protected var _heightStepper:JStepper;
		private var _minimalPanelController:MinimalPanelController
		
		public function MinimalPanel()
		{
			super(null);
			build();
			_minimalPanelController = new MinimalPanelController(this)
		}
		
		protected function build():void{
			
			var form:Form = new Form();
			//form.setLocation(new IntPoint(5,10));
			form.setPreferredSize(new IntDimension(245,320));
			this.appendForm(form);
			form.setVGap(10)
			
				
			var lineForm1:FormRow = new FormRow();
			var lineForm2:FormRow = new FormRow();
			var lineForm3:FormRow = new FormRow();
			var lineForm4:FormRow = new FormRow();
			var lineForm5:FormRow = new FormRow();
			var lineForm6:FormRow = new FormRow();
			
			_xStepper = new JStepper();
			_xStepper.setMaximum(2000);
			_xStepper.addActionListener(onUpdate);	
			
			_decalagexSlider = new JSlider();
			
			_decalagexSlider.setMajorTickSpacing(20)
			_decalagexSlider.setMinimum(-2000);
			_decalagexSlider.setMaximum(2000);
			_decalagexSlider.setPreferredSize(new IntDimension(150,30))
			_decalagexSlider.addEventListener(MouseEvent.MOUSE_UP,onUpdate);	
			
			_yStepper = new JStepper();
			_yStepper.setMaximum(2000);
			_yStepper.addActionListener(onUpdate);
			
			_decalageySlider = new JSlider();
			_decalageySlider.setMajorTickSpacing(20)
			_decalageySlider.setPreferredSize(new IntDimension(150,30))
			_decalageySlider.setMinimum(-2000);
			_decalageySlider.setMaximum(2000);
			_decalageySlider.addEventListener(MouseEvent.MOUSE_UP,onUpdate);	
			
			_widthStepper = new JStepper();
			_widthStepper.setMaximum(2000);
			_widthStepper.addActionListener(onUpdate);	
			
			_heightStepper = new JStepper();
			_heightStepper.setMaximum(2000);
			_heightStepper.addActionListener(onUpdate);	
			
			lineForm1.setColumnChildren([new JLabel("x:"),_xStepper]);
			lineForm2.setColumnChildren([new JLabel("y:"),_yStepper]);
			lineForm3.setColumnChildren([new JLabel("largeur:"),_widthStepper]);
			lineForm4.setColumnChildren([new JLabel("hauteur:"),_heightStepper]);
			lineForm5.setColumnChildren([new JLabel("Decalage x:"),_decalagexSlider]);
			lineForm6.setColumnChildren([new JLabel("Decalage y:"),_decalageySlider]);
			
			var lineForm7:FormRow = new FormRow();
			
			var deleteButton:JButton = new JButton("Supprimer");
			deleteButton.setPreferredWidth(80);
			deleteButton.addActionListener(deleteElement);
			
			var reinitButton:JButton = new JButton("Réinitialiser");
			reinitButton.setPreferredWidth(80);
			reinitButton.addActionListener(reinitElement);
			
			var undoButton:JButton = new JButton("Undo")
			undoButton.addActionListener(undo);
			undoButton.setPreferredWidth(80);
			var redoButton:JButton = new JButton("Redo")
			redoButton.addActionListener(redo);
			lineForm7.setColumnChildren([undoButton,redoButton]);
			
			var backButton:JButton = new JButton("Reculer d'un plan")
			backButton.addActionListener(backElement);
			undoButton.setPreferredWidth(80);
			var forwardButton:JButton = new JButton("Avancer d'un plan")
			forwardButton.addActionListener(forwardElement);
			
			//lineForm7.setColumnChildrenIndecis("0,1");
			form.appendAll(lineForm1,lineForm2,lineForm3,lineForm4,lineForm5,lineForm6,new JSeparator(),new FormRow(deleteButton,backButton),new FormRow(reinitButton,forwardButton),lineForm7)
			form.append(new JSeparator());
		}
		
		
		protected function appendForm(form:Form):void{
			this.append(form);	
		}
		
		private function onUpdate(evt:Event):void{
			
			if(evt.currentTarget is JSlider){
				if(evt.currentTarget ==_decalagexSlider){
					_minimalPanelController.updateTarget("decalageX",_decalagexSlider.getValue());	
				}
				if(evt.currentTarget ==_decalageySlider){
					_minimalPanelController.updateTarget("decalageY",_decalageySlider.getValue());	
				}
				
			}
			else{
				var target:JStepper = evt.currentTarget as JStepper;
				
				switch(target){
					
					case _xStepper: _minimalPanelController.updateTarget("posx",target.getValue()); break
					case _yStepper: _minimalPanelController.updateTarget("posy",target.getValue()); break
					case _widthStepper: _minimalPanelController.updateTarget("w",target.getValue()); break
					case _heightStepper: _minimalPanelController.updateTarget("h",target.getValue()); break
				}	
			}
			
			
		}
		
		
		
		private function backElement(evt:Event):void{
			_minimalPanelController.backwardElement()
		}
		private function forwardElement(evt:Event):void{
			_minimalPanelController.forwardElement()
		}
		private function undo(evt:Event):void{
			_minimalPanelController.undo()
		}
		
		private function redo(evt:Event):void{
			_minimalPanelController.redo();
		}
		
		private function reinitElement(evt:Event):void{
			_minimalPanelController.reinitElement();
		}
		
		private function deleteElement(evt:Event):void{
			_minimalPanelController.deleteElement();
		}
		
		public function updatePanel(obj:Object):void{
			_minimalPanelController.updatePanel(obj);
		}
		
		public function setXStepper(value:int):void{
			_xStepper.setValue(value);
		}
		
		public function setdecalageXSlider(value:int):void{
			_decalagexSlider.setValue(value);
		}
		
		public function setdecalageYSlider(value:int):void{
			_decalageySlider.setValue(value);
		}
		
		public function setYStepper(value:int):void{
			_yStepper.setValue(value);
		}
		
		public function setWidthStepper(value:int):void{
			_widthStepper.setValue(value);
		}
		
		public function setHeightStepper(value:int):void{
			_heightStepper.setValue(value);
		}
	}
}