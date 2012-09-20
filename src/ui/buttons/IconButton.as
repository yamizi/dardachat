package ui.buttons
{
	import org.aswing.ASColor;
	import org.aswing.AbstractButton;
	import org.aswing.Icon;
	import org.aswing.JButton;
	import org.aswing.event.AWEvent;
	import org.aswing.geom.IntDimension;
	
	public class IconButton extends JButton
	{
		private var _id:String;
		public function IconButton(text:String="", icon:Icon=null,w:uint=100,h:uint=120,clicFunction:Function=null)
		{
			super(text, icon);
			setVerticalTextPosition(AbstractButton.BOTTOM);
			setHorizontalTextPosition(AbstractButton.CENTER);
			setBackground(new ASColor(0x2F2F2F));
			setToolTipText(text);
			setPreferredSize(new IntDimension(w,h));
			if(clicFunction){
				this.addEventListener(AWEvent.ACT,clicFunction);
				this.buttonMode = true
			}
		}
		
		public function setId(value:String):void{
			_id = value;
		}
		
		public function getId():String{
			return _id;
		}
		
	}
}