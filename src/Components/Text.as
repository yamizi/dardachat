package Components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import org.aswing.ASColor;
	import org.aswing.ASFont;
	import org.aswing.AsWingManager;
	import org.aswing.JTextArea;
	import org.aswing.border.BevelBorder;
	import org.aswing.border.EmptyBorder;
	import org.aswing.border.LineBorder;
	import org.aswing.ext.MultilineLabel;
	
	public class Text extends RichMedia
	{

		/*[Embed(systemFont="Tahoma", fontName="Tahoma", mimeType="application/x-font-truetype", 
    embedAsCFF="false", unicodeRange="U+0020-007E")]
	*/
	[Embed(systemFont='Throw My Hands Up in the Air', fontName = 'handFont', mimeType="application/x-font")]
private var arial:Class;
		private var handFont:Class;
		
		private var _fillColor:uint=0xFFFFFF;
		private var _fillAlpha:uint =100;
		private var _lineColor:uint = 0;
		private var _lineAlpha:uint = 100;
		private var _lineThick:uint = 0;
		private var _textField:MultilineLabel;
		private var _borderEnabled:Boolean=true;
		private var _fillEnabled:Boolean=true;
		private var _currentBorder:String = "";
		private var _textColor:uint = 0;
		private var _textSize:uint=16;
		private var _selected:Boolean
		
		public function Text(coord:Rectangle,id:String=null)
		{
			_content = new Sprite();
			addChildAt(_content,0);
			_content.doubleClickEnabled = true
				
			_textField = new MultilineLabel();
			_textField.setText("Double clic pour modifier");
			_textField.setFont(new ASFont("handFont",16,true,false,false,true));
			_textField.setForeground(new ASColor());
			setBackgroundFill();
			setBorder();
			setColor();
			_content.addChild(_textField)
				
			this.doubleClickEnabled = true;
			this.mouseChildren = false;
			
			super(coord,id);
		}
		
		
		override public function elementDoubleClick(evt:MouseEvent=null):void{
			_selected = true
			trace("Edit text")
			_textField.setEditable(true);
			setBorder()
			this.mouseChildren = true;
			_textField.getTextField().setSelection(0,_textField.getTextField().length-1)
				
				
		}
		
		private function setBorder():void{
			if(_selected){
				_textField.setBorder(new BevelBorder(null,BevelBorder.RAISED));
			}
			else{
				switch (_currentBorder){
					
					case "line":
						_textField.setBorder(new LineBorder());
					break;
					
					default:
						_textField.setBorder(new EmptyBorder());
					break;
				}
					
			
			}
		} 
		
		private function setBackgroundFill():void{
			if(_fillEnabled){
				_textField.getTextField().backgroundColor = _fillColor;
				_textField.getTextField().background = true;
			}
			
			else{
				_textField.getTextField().background = false;
			}
			
		}
		
		private function setColor():void{
			_textField.setForeground(new ASColor(_textColor));
			//_textField.getTextField().embedFonts = true;
		}
		
		private function setFontSize():void{
			_textField.setFont(new ASFont("handFont",_textSize,true,false,false,true));
			
		}
		
		override public function unSelect():void{
			super.unSelect()
			_selected = false
			_textField.setEditable(false);
			setBorder();
			this.mouseChildren = false;
			
		}
		
		override public function setProperties(obj:Object):void{
			var txt:MultilineLabel = _content.getChildAt(0) as MultilineLabel;
			var props:Object = getProperties();
			super.setProperties(obj);
			
			if(obj.fillColor!=undefined){
				_fillColor = obj.fillColor;
			}
			
			if(obj.fillAlpha!=undefined){
				_fillEnabled = obj.fillAlpha;
				_fillAlpha = obj.fillAlpha
			}
			
			if(obj.fillEnabled!=undefined){
				_fillEnabled = obj.fillEnabled;
				
			}
			setBackgroundFill()
			
			if(obj.border!=undefined){
				_currentBorder  = obj.border;
				setBorder();
			}
			
			if(obj.textColor!=undefined){
				_textColor  = obj.textColor;
				setColor();
			}
			
			if(obj.textSize !=undefined){
				_textSize = obj.textSize
				setFontSize();
			}
			
			trace("text modifié par"+obj.txt)
			trace("ancien: "+_textField.getText())
			if(obj.txt!=undefined){
				_textField.setText(obj.txt);	
				//_textField.revalidate()
			}
			trace("nouveau: "+_textField.getText())
			
			
			
		} 
		

		override public function getProperties():Object{
			var obj:Object = super.getProperties();
			obj.border = _currentBorder
			obj.fillEnabled = _fillEnabled;
			obj.fillColor = _fillColor;
			obj.fillAlpha = _fillAlpha;
			obj.lineColor = _lineColor;
			obj.lineAlpha = _lineAlpha;
			obj.lineThick = _lineThick;
			obj.type = "text";
			obj.txt = _textField.getText();
			obj.textSize = _textSize
			obj.textColor = _textColor;
			return obj
		}
		
		
		override protected function setSize(w:Number, h:Number, center:Boolean=false):void{ 
			//super.setSize(w,h)
			if(!stage){
				h = Math.max(50,h);
				w = Math.max(70,w)	
			}
			_textField.setSizeWH(w,h)

			
			_content.x = -w/2;
			_content.y = -h/2;
		}
		
		
	}
}