package ui
{
	import org.aswing.Icon;
	import org.aswing.JMenu;
	import org.aswing.JMenuItem;
	
	public class Menu extends JMenu
	{
		public function Menu(text:String, subMenu:Array,icon:Icon=null)
		{
			super(text, icon);
			
			if(subMenu.length ==1){
				this.addActionListener(subMenu[0]);
			}
			for(var i:uint=0;i<subMenu.length-1;i+=2){
				var Jmenu:JMenuItem = this.addMenuItem(subMenu[i]);
				if(subMenu[i+1]){
					Jmenu.addActionListener(subMenu[i+1]);
				}
			}
			
		}
	}
}