package ui.windows
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.aswing.ASColor;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JTextField;
	import org.aswing.geom.IntDimension;

	public class InputWindow extends AlertWindow
	{
		private var _submitButton:JButton
		private var _submitMessage:JLabel;
		private var _submitInput:JTextField;
		private var _submitFunction:Function
		public function InputWindow(title:String, params:Object)
		{
			super(title, {width:320,height:110});
			this.getContentPane().mouseChildren = true	
			this.getContentPane().setLayout(new FlowLayout(FlowLayout.CENTER));
			_submitMessage = new JLabel(params.submitMessage);
			_submitMessage.setPreferredSize(new IntDimension(120,25));
			
			_submitInput = new JTextField(params.submitText);
			_submitInput.setPreferredSize(new IntDimension(150,25));
			
			_submitButton = new JButton("Valider");
			_submitButton.setBackground(new ASColor(0x0084ad))
			_submitButton.setPreferredSize(new IntDimension(100,25));
			
			_submitFunction = params.submitFunction
			_submitButton.addEventListener(MouseEvent.CLICK,submit);
			
			this.getContentPane().appendAll(_submitMessage,_submitInput,_submitButton);
		}
		
		private function submit(evt:Event):void{
			var button:JButton = evt.target as JButton;
			button.removeEventListener(MouseEvent.CLICK,submit);
			_submitFunction(_submitInput.getText());
			
		}
		
		
	}
}