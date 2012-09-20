package propertyWindow.panels
{

	import flash.events.Event;
	import flash.events.TextEvent;
	
	import org.aswing.ASColor;
	import org.aswing.JLabel;
	import org.aswing.JSeparator;
	import org.aswing.JStepper;
	import org.aswing.JTextArea;
	import org.aswing.ext.Form;
	import org.aswing.geom.IntDimension;
	
	import ui.buttons.ColorButton;

	public class TextPanel extends ShapePanel
	{
		
		private var _textPanelController:TextPanelController
		private var _textColorButton:ColorButton
		private var _textArea:JTextArea;
		private var _textSize:JStepper
		public function TextPanel()
		{
			super();
			_textPanelController = new TextPanelController(this)
		}
		
		override protected function build():void{
			
			super.build();
			
			var form:Form = new Form();
			form.setPreferredSize(new IntDimension(245,250));
			this.appendForm(form);
			form.setVGap(10)
				
			_textColorButton = new ColorButton("Couleur du texte",0,100,updateTargetTextColor,"textC")
				
			form.append(_textColorButton);	
				
			_textSize = new JStepper();
			_textSize.setMaximum(200);
			_textSize.addActionListener(onUpdateSize);
			form.append(_textSize)
			
			form.append(new JLabel("Contenu:"));
			_textArea = new JTextArea();
			_textArea.setPreferredSize(new IntDimension(240,150));
			_textArea.addEventListener(TextEvent.TEXT_INPUT,onTextInput);
			form.append(_textArea);
			form.append(new JSeparator());
			
		}
		
		override public function updatePanel(obj:Object):void{
			super.updatePanel(obj);
			_textPanelController.updatePanel(obj);
		}
		
		protected function updateTargetTextColor(color:ASColor):void{
			_textPanelController.updateTargetTextColor(color);
		}
		
		protected function onTextInput(evt:TextEvent):void{
			_textPanelController.updateTargetText(_textArea.getText());
		}
		
		protected function onUpdateSize(evt:Event):void{
			_textPanelController.updateTargetTextSize(_textSize.getValue());
		}
										
		
		public function setTextSize(value:uint):void{
			_textSize.setValue(value)
		}
		
		public function setTextColor(color:uint,alpha:uint):void{
			_textColorButton.setColor(color,alpha,false)
		}
		
		public function setText(txt:String):void{
			_textArea.removeEventListener(TextEvent.TEXT_INPUT,onTextInput);
			_textArea.setText(txt);
			_textArea.addEventListener(TextEvent.TEXT_INPUT,onTextInput);
		}
		
		
	}
	
}