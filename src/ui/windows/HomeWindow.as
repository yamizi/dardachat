package ui.windows
{
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	
	import org.aswing.ASColor;
	import org.aswing.AsWingConstants;
	import org.aswing.AsWingManager;
	import org.aswing.AssetBackground;
	import org.aswing.BoxLayout;
	import org.aswing.EmptyLayout;
	import org.aswing.FlowLayout;
	import org.aswing.GradientBackground;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.JSpacer;
	import org.aswing.geom.IntDimension;
	import org.aswing.geom.IntPoint;
	import ui.DocumentPanel;
	import ui.buttons.HomeFrameButtons;
	import ui.HomePanel;
	import ui.MediaPanel;
	import ui.RecycledPanel;
	import ui.SharedPanel;
	
	public class HomeWindow extends JFrame
	{
		private var _homeButton:HomeFrameButtons,_myDocuments:HomeFrameButtons,_sharedDocuments:HomeFrameButtons,_medias:HomeFrameButtons,_recycled:HomeFrameButtons;
		private var _lastSelection:HomeFrameButtons;
		private var _leftPanel:JPanel,_mainPanel:JPanel
		public function HomeWindow(owner:Main=null)
		{
			var nom:String = owner.login.split(".")[1];
			var prenom:String = owner.login.split(".")[0];
			nom = nom.toLocaleUpperCase()
			prenom = prenom.charAt(0).toUpperCase()+prenom.substr(1)
			super(owner, "Bievenue "+nom+ " "+prenom, true);
			this.setMideground(new ASColor(0xF2F2F2))
			setSize(new IntDimension( 1024, 660 ) );
			setClosable(false)
			setResizable(false)
			setDragable(false)
			this.getContentPane().setLayout(new EmptyLayout());
			buildMainPanel();
			buildLeftPanel()
			setLocation(new IntPoint((AsWingManager.getRoot().width-width)/2,(AsWingManager.getRoot().height-height)/2));
			
			show();	
			//addEventListener(Event.,onAdded);
		}
		
		private function buildMainPanel():void{
			_mainPanel = new JPanel(new FlowLayout(AsWingConstants.CENTER,5,40))
			_mainPanel.setSizeWH(945,650);
			_mainPanel.setLocationXY(150,0);
			var background:Sprite = new Sprite();
			_mainPanel.setBackgroundDecorator(new GradientBackground(GradientType.LINEAR,[0xFFFFFF,0xFFFFFF,0xFFFFFF,0xFFFFFF],[0,1,1,0],[10,25,200,250],Math.PI/2))
			background.graphics.lineStyle(1)
			background.graphics.drawRect(0,0,945,650);
			this.getContentPane().append(_mainPanel)
			setHomePanel()
		}
		
		private function buildLeftPanel():void{
			_leftPanel = new JPanel(new BoxLayout(AsWingConstants.VERTICAL))
			_leftPanel.setSizeWH(150,150);
			_leftPanel.setLocationXY(0,90);
			_homeButton = new HomeFrameButtons("Accueil");
			_myDocuments = new HomeFrameButtons("Mes documents");
			_sharedDocuments = new HomeFrameButtons("Documents partagés");
			_medias = new HomeFrameButtons("Librairie");
			_recycled = new HomeFrameButtons("Corbeille");
			_leftPanel.appendAll(_homeButton,_myDocuments,_sharedDocuments,_medias,new JSpacer(),_recycled);
			this.getContentPane().append(_leftPanel)
			_leftPanel.addEventListener(MouseEvent.CLICK,onElementClick);
			_homeButton.setSelected(true)
			_lastSelection= _homeButton
			
		}
		
		private function onElementClick(evt:MouseEvent):void{
			if(_lastSelection){
				_lastSelection.setSelected(false);
			}
			var target:HomeFrameButtons = evt.target as HomeFrameButtons
				if(target){
					target.setSelected(true);
					_lastSelection= target
					switch(target){
						case _homeButton: setHomePanel();
							break;
						case _myDocuments: setDocumentsPanel();
							break;
						case _medias: setMediaPanel();
							break;
						case _sharedDocuments: setSharedPanel();
							break;
						case _recycled: setRecycledPanel();
							break;	
					}
				}
			
		}
		
		private function onAdded(evt:Event):void{
			trace("added")
			_homeButton.setSelected(true);
			_lastSelection= _homeButton
		}
		
		private function setHomePanel():void{
			_mainPanel.removeAll();
			_mainPanel.append(new HomePanel())
		}
		
		private function setDocumentsPanel():void{
			_mainPanel.removeAll();
			_mainPanel.append(new DocumentPanel())
		}
		
		private function setSharedPanel():void{
			_mainPanel.removeAll();
			_mainPanel.append(new SharedPanel())
		}
		
		private function setMediaPanel():void{
			_mainPanel.removeAll();
			_mainPanel.append(new MediaPanel())
		}
		
		private function setRecycledPanel():void{
			_mainPanel.removeAll();
			_mainPanel.append(new RecycledPanel())
		}
	}
}