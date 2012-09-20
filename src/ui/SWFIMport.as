package ui
{
	import Components.Picture;
	import Components.SWFContainer;
	
	import flash.events.Event;
	
	public class SWFIMport extends PictureImport
	{
		public function SWFIMport(target:Picture)
		{
			super(target);
		}
		
		override protected function buildContainer(w:uint,h:uint,posx:uint,posy:uint):void{
			_container = new SWFContainer(w,h,true);
			_container.x = posx;
			_container.y = posy;
		}
		
		override protected function update(evt:Event):void{
			var txt:String = _adress.getText();
			if(_src!=txt){
				var extension:String = txt.substr(txt.lastIndexOf(".")+1).toLocaleLowerCase()
				trace("extension "+extension);
				if(_src!=txt && (extension=="swf")){
					//_container.loadUrl(txt);
					submitButton.setEnabled(true);
					_type = "local";
					_src = txt;
				}
				else{
					submitButton.setEnabled(false);
				}
			}
			
		}
	}
}