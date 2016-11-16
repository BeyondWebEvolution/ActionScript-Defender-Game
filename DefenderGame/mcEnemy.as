package  {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	public class mcEnemy extends MovieClip {

		private var nSpeed:Number;

		
		public function mcEnemy() {
			// constructor code
			
			addEventListener(Event.ADDED_TO_STAGE, onAdd);


		}
		
		private function onAdd(evt:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, onAdd);
			init();
			
			
		}
		
		private function init():void {
			
			var nEnemies:Number = 3;
			//pick a random number
			var nRandom:Number = randomNumber(1, nEnemies);
			//set the timeline to the random number
			this.gotoAndStop(nRandom);
			
			//set the start point
			startPoint();
			startMoving();

			
		}
		
		private function startPoint():void {
			
			//set random speed
			nSpeed = randomNumber (2, 6);
			
			
			//start off stage
			this.x = stage.stageWidth + (this.width/2);
			
			//set random start height
			var minStart:Number = stage.stageHeight - (this.height/2);
			var maxStart:Number = (this.height/2);
			//set random point between min and max
			this.y = randomNumber(minStart, maxStart);
			
			
		}
		
		private function startMoving():void {
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame)
			
			
		}
		
		private function onEnterFrame(evt:Event):void {
			
			//move enemies to teh left
			this.x -= nSpeed;
			
						
		}
		
		//remove the enemy from the stage
		public function destroyEnemy():void {
			
			//remove this enemy from the stage
			parent.removeChild(this);
			//remove event listenter
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			
			
		}
		
		//random number generator with low to high range
		function randomNumber(low:Number=0, high:Number=1):Number {
			
			return Math.floor(Math.random() * (1+high-low)) + low;
		}

	}
	
}
