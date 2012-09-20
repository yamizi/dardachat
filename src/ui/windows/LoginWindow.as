package ui.windows
{
	import flash.events.Event;
	
	import logic.ServerFunctions;
	
	import org.aswing.ASColor;
	import org.aswing.ASFont;
	import org.aswing.AsWingManager;
	import org.aswing.EmptyLayout;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JLabel;
	import org.aswing.JTextField;
	import org.aswing.event.AWEvent;
	import org.aswing.geom.IntDimension;
	import org.aswing.geom.IntPoint;
	
	public class LoginWindow extends JFrame
	{
		private var _login:JTextField,_password:JTextField;
		public var submitBtn:JButton
		public function LoginWindow(owner:Main=null)
		{
			super(owner, "Identification", true);
			setSize(new IntDimension( 320, 240 ) );
			setClosable(false)
			setResizable(false)
			this.setMideground(new ASColor(0xF2F2F2))
			//setDragable(false);
			getContentPane().setLayout(new EmptyLayout());
			addEventListener(Event.ADDED_TO_STAGE,init);
			show();	
		}
		
		private function init(evt:Event):void{
			
			var label1:JLabel = new JLabel("Addresse institutionnelle");
			label1.setFont(new ASFont("Tahoma",14,true))
			label1.setLocationXY(20,20);
			label1.setSizeWH(280,20);
			_login = new JTextField("admin.cpp");
			_login.setLocationXY(30,60);
			_login.setSizeWH(120,25);
			//_login.setA
			var label2:JLabel = new JLabel("@etu.grenoble-inp.fr");
			label2.setSizeWH(120,20);
			label2.setLocationXY(150,60);
			
			var label3:JLabel = new JLabel("Mot de passe (=admin)");
			label3.setFont(new ASFont("Tahoma",14,true))
			label3.setLocationXY(60,100);
			label3.setSizeWH(180,20);
			_password = new JTextField("admin");
			_password.setLocationXY(90,130);
			_password.setSizeWH(120,25);
			_password.setDisplayAsPassword(true);
			
			
			
			submitBtn = new JButton("Entrer");
			submitBtn.setBackground(new ASColor(0x0084ad))
			submitBtn.setSizeWH(120,25);
			submitBtn.setLocationXY(90,170);
			submitBtn.addActionListener(onSubmit);
			this.getContentPane().appendAll(label1,_login,label2,label3,_password,submitBtn)
			setLocation(new IntPoint((AsWingManager.getRoot().width-width)/2,(AsWingManager.getRoot().height-height)/2));
		}
		
		private function onSubmit(evt:AWEvent):void{
			var id:String = _login.getText().toLocaleLowerCase();
			if(id.indexOf(".")>3){
				(AsWingManager.getRoot() as Main).id = id
				ServerFunctions.connect(id,_password.getText());
			}
			else{
				//_log.setText("Adresse mail invalide");
			}
		}
	}
}