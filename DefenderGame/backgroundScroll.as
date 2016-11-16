package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.display.Graphics;
	import fl.transitions.Tween;
	import fl.transitions.easing.Strong;
	import fl.motion.easing.Back;
	
	
	public class backgroundScroll extends MovieClip {
		
		private var thisBack1:back = new back();
		private var thisBack2:back = new back();
		private var thisFore1:fore = new fore();
		private var thisFore2:fore = new fore();
		private var _backfactor:Number = 0.1;
		private var _speed:Number = 1;
		
		
		public function backgroundScroll():void {
			// constructor code
			
			thisBack1.x = 0;
			thisBack1.y = 0;
			addChild(thisBack1);
			
			thisBack2.x = 0;
			thisBack2.y = 0;
			addChild(thisBack2);
			
			thisFore1.x = 0;
			thisFore1.y = 0;
			addChild(thisFore1);
			
			thisFore2.x = 0;
			thisFore2.y = 0;
			addChild(thisFore2);
			
			addEventListener(Event.ENTER_FRAME, update, false, 0, true);
		}
		
		private function update(evt:Event){
			
			var movement:Number = -1 * _speed;
			
			thisBack1.x += movement * _backfactor;
			thisBack2.x += movement * _backfactor;
			
			thisFore1.x += movement;
			thisFore2.x += movement;
			
			align(thisFore1, thisFore2);
			align(thisBack1, thisBack2);
		}
		
		private function align (clip1:MovieClip, clip2:MovieClip) {
			if (clip1.x < 0 && clip2.x < 0){
				if (clip1.x > clip2.x){
					clip2.x = clip1.x +clip1.width;
				}else {
					clip1.x = clip2.x + clip2.width;
				}
			}else if(clip1.x > 0 && clip2.x > 0) {
				if (clip1.x < clip2.x) {
					clip2.x = clip1.x - clip1.width;
				}else {
					clip1.x = clip2.x - clip2.width;
				}
			}
				
		}
		
	}
	
}
