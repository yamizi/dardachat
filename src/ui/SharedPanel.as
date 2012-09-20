package ui
{
	import logic.ServerFunctions;
	
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
	import ui.buttons.IconButton;
	
	public class SharedPanel extends JPanel
	{
		private var _documents:Array = new Array();
		
		public function SharedPanel()
		{
			super(new FlowLayout());
			var label0:JLabel = new JLabel("Documents partagés par mes groupes:")
			label0.setPreferredSize(new IntDimension(800,30));
			label0.setHorizontalAlignment(AsWingConstants.LEFT)
			append(label0)
			getLastSharedFiles()
			setPreferredSize(new IntDimension(850,500));
			setLocationXY(20,20);		
		}
		
		private function getLastSharedFiles():void{
			var button:IconButton = new IconButton("Chargement...",new ProgressIcon(),120,140);
			append(button)
			ServerFunctions.getFiles({order:"last",number:20,type:"shared"},onGet_LastSharedFiles,onFailure_LastSharedFiles)	
		}
		
		
		public function onGet_LastSharedFiles(list:Array):void{
			removeAll()
			
			var label0:JLabel = new JLabel("Documents partagés par mes groupes:")
			label0.setPreferredSize(new IntDimension(800,30));
			label0.setHorizontalAlignment(AsWingConstants.LEFT)
			append(label0)
			
			if(!list.length){
				var button:IconButton = new IconButton("Aucun fichier\npartagé",new LoadIcon("assets/ui/notFound.png"),120,140);
				append(button)
			}
		}
		
		public function onFailure_LastSharedFiles(msg:String):void{
			
		}
	}
}