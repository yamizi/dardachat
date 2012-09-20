package ui.windows
{
	import org.aswing.JPanel;
	
	import ui.buttons.IconButton;

	public class ContentWindow extends AlertWindow
	{
		private var _cancelFunction:Function;
		private var _submitFunction:Function;
		
		public function ContentWindow(title:String,contentPanel:JPanel,cancelLabel:String="",cancelFunction:Function=null,submitLabel:String="",submitFunction:Function=null)
		{
			
			this.getContentPane().append(contentPanel);
			
			if(cancelLabel){
				var cancelBtn:IconButton = new IconButton(cancelLabel,null,100,25,cancelFunction);
				this.getContentPane().append(cancelBtn);
			}
			
			if(submitLabel){
				var submitBtn:IconButton = new IconButton(submitLabel,null,100,25,submitFunction);
				this.getContentPane().append(submitBtn);
			}
			
			super(title, null);
		}
		
	}
}