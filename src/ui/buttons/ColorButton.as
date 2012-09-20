package ui.buttons
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import org.aswing.ASColor;
	import org.aswing.AsWingConstants;
	import org.aswing.BorderLayout;
	import org.aswing.FlowLayout;
	import org.aswing.Insets;
	import org.aswing.JButton;
	import org.aswing.JFrame;
	import org.aswing.JPanel;
	import org.aswing.JSpacer;
	import org.aswing.border.EmptyBorder;
	import org.aswing.colorchooser.JColorSwatches;
	import org.aswing.geom.IntDimension;
	import propertyWindow.PropertyWindow;
	
	public class ColorButton extends JButton
	{
		private var _icon:Sprite;
		private var _argb:ASColor;
		private var _colorsFrame:JFrame;
		private var _colorSwatche:JColorSwatches;
		
		private var _updateColorFunction:Function
		private var _id:String
		
		public function ColorButton(label:String,color:uint = 0xFFFFFF,alpha:uint = 100,updateFunction:Function=null,id:String="")
		{
			
			_icon = new Sprite();
			_icon.x = 3;
			_icon.y = 4;
			setColor(color,alpha);
			this.addChild(_icon);
			this.setHorizontalTextPosition(AsWingConstants.LEFT);
			super("      "+label, null);
			addEventListener(MouseEvent.CLICK,openPopUp_Color);
			
			if(id){
				_id = id
			}
			else{
				_id = label
			}
			if(updateFunction){
				_updateColorFunction = updateFunction 
			}
		}
		
		public function setColor(color:uint = 0xFFFFFF,alpha:uint = 100,update:Boolean=true):void{
			_argb = new ASColor(color,alpha/100);
			_icon.graphics.clear();
			_icon.graphics.beginFill(color);
			_icon.graphics.drawRoundRect(0,0,16,16,5,5);
			
			if(update && this.parent){
				if(_updateColorFunction){
					_updateColorFunction(_argb)	
				}
				
			}
		}
		
		public function getColor():ASColor{
			return _argb;
		}
		
		private function openPopUp_Color(evt:MouseEvent):void{
			_colorsFrame = new JFrame(stage,"Selectionnez une couleur",true);
			_colorsFrame.setSize(new IntDimension( 270, 260 ) );
			_colorsFrame.setLocationXY(1020,100);
			_colorsFrame.setClosable(false)
			_colorsFrame.setResizable(false);
			
			
			var pane : JPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
			pane.setBorder(new EmptyBorder(null, new Insets(10,5,10,5)));
			_colorsFrame.getContentPane().append(pane)
				
			_colorSwatche = new JColorSwatches();
			pane.append(_colorSwatche)
			
			
			var submitBtn:JButton = new JButton("Valider");
			submitBtn.addEventListener(MouseEvent.CLICK,onSubmit);
			var cancelBtn:JButton = new JButton("Annuler");
			cancelBtn.addEventListener(MouseEvent.CLICK,onClose);
			pane.appendAll(submitBtn,cancelBtn);

			_colorsFrame.show();
		}
		
		private function onSubmit(evt:MouseEvent):void{
			setColor(_colorSwatche.getSelectedColor().getRGB(),_colorSwatche.getSelectedColor().getAlpha()*100);
			onClose();
		}
		
		private function onClose(evt:MouseEvent=null):void{
			_colorsFrame.dispose();
			_colorsFrame.parent.removeChild(_colorsFrame);
		}
	}
}
