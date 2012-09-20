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
	
	public class DocumentPanel extends JPanel
	{
		private var _documents:Array = new Array({title:"Modèle Vide",src:"EmptyModel.png"});
		
		public function DocumentPanel()
		{
			super(new FlowLayout());
			
			setPreferredSize(new IntDimension(850,500));
			setLocationXY(20,20);

			
			var label0:JLabel = new JLabel("Mes documents:")
			label0.setPreferredSize(new IntDimension(800,30));
			label0.setHorizontalAlignment(AsWingConstants.LEFT)
			append(label0)
			getDocuments();
			
			/*for(var i:uint = 0;i<_documents.length;i++){
				var fileName:String = elements[i].filename;
				//var extension:String = elements[i].extension;
				var button:IconButton = new IconButton(fileName,new LoadIcon("assets/ui/"+_documents[i].src),120,140);
				this.append(button)
				button.buttonMode = true	
			}*/
		}
		
		private function getDocuments():void{
			
		}
	}
}