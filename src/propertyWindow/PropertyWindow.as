package propertyWindow
{
	
	import flash.events.Event;
	
	import logic.AnimationManager;
	
	import org.aswing.ASColor;
	import org.aswing.AsWingConstants;
	import org.aswing.AsWingManager;
	import org.aswing.BorderLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JList;
	import org.aswing.JPanel;
	import org.aswing.JScrollPane;
	import org.aswing.JTabbedPane;
	import org.aswing.JViewport;
	import org.aswing.event.SelectionEvent;
	import org.aswing.geom.IntDimension;
	import org.aswing.geom.IntPoint;
	
	import propertyWindow.panels.MinimalPanel;

	
	public class PropertyWindow extends JFrame
	{
		
		private var _propertyWindowController:PropertyWindowController;
		private var _editPanel:JPanel;
		private var _animationPanel:JPanel
		private var _animationList:JList
		
		public function PropertyWindow(w:uint,h:uint,posx:uint):void{
			super(null, "Barre d'outils");
			
			setSize(new IntDimension( w, h ) );
			setLocation(new IntPoint(posx,0));
			setClosable(false);
			setResizable(false)
			this.setMideground(new ASColor(0xF2F2F2))
				
			var tabbedPane:JTabbedPane = new JTabbedPane();
			this.getContentPane().append(tabbedPane);
			
			_editPanel = new JPanel(new BorderLayout());
			_editPanel.setName("Propriétés");
			
			tabbedPane.append(_editPanel);
			
			_animationPanel = new JPanel();
			_animationPanel.setName("Animations");
			tabbedPane.append(_animationPanel);
			buildAnimationList();
			
			_propertyWindowController = new PropertyWindowController(this);
		}
		
		public function setProperties(obj:Object):void{
			_propertyWindowController.setProperties(obj);
		}
		
		public function setPanel(panel:MinimalPanel):void{
			_editPanel.removeAll();
			_editPanel.append(panel);
			trace("ajout panel" +panel)
		}
		
		public function getCurrentPanel():MinimalPanel{
			return _editPanel.getComponent(0) as MinimalPanel;
		}
		
		private function buildAnimationList():void{
			
			_animationList = new JList(AnimationManager.getElementsId());
			_animationList.addEventListener(SelectionEvent.LIST_SELECTION_CHANGED,onAnimatedElementSelected);
			var scrollPane:JScrollPane = new JScrollPane();
			scrollPane.setViewport(_animationList);
			scrollPane.setPreferredSize(new IntDimension(250,600));
			
			var addButton:JButton = new JButton("Ajouter à l'animation");
			addButton.addActionListener(onAddAnimation)
				
			var removeButton:JButton = new JButton("Retirer l'animation");
			removeButton.addActionListener(onRemoveAnimation)
				
			_animationPanel.append(removeButton);	
			_animationPanel.append(addButton);
			_animationPanel.append(scrollPane);
		}
		
		private function onAnimatedElementSelected(evt:SelectionEvent):void{
			_propertyWindowController.onSelectedAnimatedElement(evt.getFirstIndex());
		}
		
		private function onRemoveAnimation(evt:Event):void{
			AnimationManager.removeElementbyIndex(_animationList.getSelectedIndex());
		}
		
		private function onAddAnimation(evt:Event):void{
			var main:Main = AsWingManager.getRoot() as Main;
			if(main.selection){
				AnimationManager.appendElement(main.selection);	
			}
			
		}
	}
	
		
	
}