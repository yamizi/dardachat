package ui
{
	import org.aswing.JPanel;
	import org.aswing.JTabbedPane;
	import org.aswing.LayoutManager;
	import org.aswing.geom.IntDimension;
	
	public class FileDetailsPanel extends JPanel
	{
		
		private var _generalPanel:JPanel;
		private var _previewPanel:JPanel;
		private var _sharePanel:JPanel
		public function FileDetailsPanel(fileId:String,size:IntDimension)
		{
			super(null);
			setPreferredSize(size);
			init();
		}
		
		private function init():void{
			var tabbedPane:JTabbedPane = new JTabbedPane();
			this.addChild(tabbedPane);
			
			tabbedPane.append(buildGeneralPanel())
			
		}
		
		private function buildGeneralPanel():JPanel{
			_generalPanel = new JPanel();
			
			_generalPanel.setName("Général");
			
			return _generalPanel;
		}
	}
}