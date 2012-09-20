package ui
{
	import org.aswing.ASColor;
	import org.aswing.AbstractButton;
	import org.aswing.AsWingConstants;
	import org.aswing.FlowLayout;
	import org.aswing.JButton;
	import org.aswing.JLabel;
	import org.aswing.JPanel;
	import org.aswing.LayoutManager;
	import org.aswing.LoadIcon;
	import org.aswing.geom.IntDimension;
	
	public class RecycledPanel extends JPanel
	{
		private var _documents:Array = new Array();
		
		public function RecycledPanel()
		{
			super(new FlowLayout());
			
			setPreferredSize(new IntDimension(850,500));
			setLocationXY(20,20);
			
			
			var label0:JLabel = new JLabel("Corbeille:")
			label0.setPreferredSize(new IntDimension(800,30));
			label0.setHorizontalAlignment(AsWingConstants.LEFT)
			append(label0)
			getDocuments();
			
			for(var i:uint = 0;i<_documents.length;i++){
				var button:JButton = new JButton(_documents[i].title,new LoadIcon("assets/ui/"+_documents[i].src));
				button.setToolTipText(_documents[i].title);
				button.setPreferredSize(new IntDimension(120,140));
				button.setVerticalTextPosition(AbstractButton.BOTTOM);
				button.setHorizontalTextPosition(AbstractButton.CENTER);
				button.setBackground(new ASColor(0x2F2F2F));
				this.append(button)
				button.buttonMode = true	
			}
		}
		
		private function getDocuments():void{
			
		}
	}
}