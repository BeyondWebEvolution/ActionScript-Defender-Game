package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class mcLaser extends MovieClip {
		
		public var xVel:Number;

		public function mcLaser() {
			// constructor code
			
			//listen for the event that adds the laser to the stage
			addEventListener(Event.ADDED_TO_STAGE, onAdd);
		}
		
		private function onAdd(evt:Event):void{
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			
			init();
			
		}
		
		private function init():void {
			
			addEventListener(Event.ENTER_FRAME, laserGo);
			
		}
		
		private function laserGo(evt:Event):void {
			
			
			this.x += xVel;
			
			
		}
				
		public function destroyLaser():void {
			
			//remove object from the stage
			parent.removeChild(this);
			
			//remove event listeners
			removeEventListener(Event.ENTER_FRAME, laserGo);
			
		}

	}
	
}
