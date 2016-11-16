package {

	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Sprite;


	public class myGame extends MovieClip {

		
		private var touchLayer: Sprite;

		private var moveUp: Boolean;
		private var moveDown: Boolean;
		private var moveLeft: Boolean;
		private var moveRight: Boolean;

		private var laserArray: Array;
		private var laserArray2: Array;
		public var enemyArray: Array;
		private var enemyLaserArray: Array;

		private var enemyTimer: Timer;

		public var scoreText: TextField;
		public var ammoText: TextField;

		public var menuEnd: mcEndGameScreen;

		private var numScore: Number;
		private var numAmmo: Number;
		
		public var mcPlayer: MovieClip;






		public function myGame() {
			// constructor code

			menuEnd.hideScreen();
			

			
			scoreText.visible = false;
			ammoText.visible = false;

			addBackground();
			//
			touchLayer = new Sprite();
			


			addEventListener(Event.ADDED_TO_STAGE, setupTouchLayer);
			touchLayer.addEventListener(MouseEvent.CLICK, startFiring);

			//initilize variables
			laserArray = new Array();
			laserArray2 = new Array();
			enemyArray = new Array();
			enemyLaserArray = new Array();

			//set the starting score and ammo count
			numScore = 0;
			numAmmo = 20;
			healthBar.width = 180;

			
			scoreText.visible = true;
			ammoText.visible = true;
			addChild(touchLayer);



			//tells flash to listen for when a key is pressed
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);

			//adds a listenr to do something on every frame
			addEventListener(Event.ENTER_FRAME, onEnterFrame);

			//timer to add enemys
			enemyTimer = new Timer(1000);
			//listens for the time intervals
			enemyTimer.addEventListener(TimerEvent.TIMER, addEnemy);
			enemyTimer.addEventListener(TimerEvent.TIMER, enemyFire);
			//start the timer
			enemyTimer.start();

			updateScore();
			updateAmmo();
			updateHealthBar();

		}

		private function setupTouchLayer(evt: Event): void {
			touchLayer.graphics.beginFill(0x000000, 0);
			touchLayer.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			touchLayer.graphics.endFill();
		}
		
		

		private function startFiring(evt: MouseEvent): void {

			fireLaser();
		}


		private function addBackground(): void {

			var newBack: backgroundScroll = new backgroundScroll();
			stage.addChild(newBack);
			parent.setChildIndex(newBack, 0);

		}


		private function updateScore(): void {

			scoreText.text = "Score: " + numScore;



		}

		private function updateAmmo(): void {

			ammoText.text = "HEAVY AMMO: " + numAmmo;


		}


		private function updateHealthBar(): void {

			healthBar.width = 180;


		}


		private function addEnemy(evt: TimerEvent): void {

			//create new enemy object
			var newEnemy: mcEnemy = new mcEnemy();
			//add enemies to the stage
			stage.addChild(newEnemy);
			//add enemies to an array for garbage collection
			enemyArray.push(newEnemy);

			//count the enemies in the stage
			//trace(enemyArray.length);


		}

		private function enemyFire(evt: TimerEvent): void {

			for (var i: int = 0; i < enemyArray.length; i++) {

				var enemyLaser: mcLaser = new mcLaser();
				var currentEnemy: mcEnemy = enemyArray[i];
				enemyLaser.x = currentEnemy.x;
				enemyLaser.y = currentEnemy.y;
				stage.addChild(enemyLaser);
				enemyLaser.xVel = -8;
				enemyLaser.gotoAndStop(3);

				//set up array garbage collection and hit detection
				enemyLaserArray.push(enemyLaser);

			}

		}


		private function onEnterFrame(evt: Event): void {

			//check for these things every frame

			movePlayer();
			makeBoundry();
			killLaser();
			killLaser2();
			killEnemy();
			enemyHitTest();
			enemyHitTest2();
			endGame();
			playerHitTest();




		}


		private function endGame(): void {

			//check for the conditions to end the game
			if (healthBar.width < 1 && enemyArray.length == 0) {

				//stop player movement
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
				stage.removeEventListener(KeyboardEvent.KEY_UP, keyUp);

				//hide the player


				//stop adding enemies
				enemyTimer.stop();

				//clear enemies from the stage
				for each(var enemy: mcEnemy in enemyArray) {

					//destroy current enemy in the for loop
					enemy.destroyEnemy();
					//remove it from the array
					enemyArray.splice(0, 1);
					trace(enemyArray.length);

				}

				//stop the game loop
				if (enemyArray.length == 0) {

					trace("enemy length 0");

					removeEventListener(Event.ENTER_FRAME, onEnterFrame);


				}

				//show the end game screen
				menuEnd.showScreen();

				//remove the touch layer
				removeChild(touchLayer);


			}

		}

		private function enemyHitTest(): void {

			//loop through current lasers
			for (var i: int = 0; i < laserArray.length; i++) {

				//check current laser
				var currentLaser: mcLaser = laserArray[i];

				//loop through enemies
				for (var j: int = 0; j < enemyArray.length; j++) {

					//check current enemy
					var currentEnemy: mcEnemy = enemyArray[j];

					//check if current laser is touching current enemy
					if (currentLaser.hitTestObject(currentEnemy)) {

						//create an explosion animation
						//create a new instance of the explosion object
						var newExplosion: mcExplosion = new mcExplosion();
						//add it to the stage
						stage.addChild(newExplosion);
						//position it over the current enemy
						newExplosion.x = currentEnemy.x;
						newExplosion.y = currentEnemy.y;

						//remove the lasers and enemies from the stage and arrays
						currentLaser.destroyLaser();
						laserArray.splice(i, 1);
						currentEnemy.destroyEnemy();
						enemyArray.splice(j, 1);

						//increase score on enemy kill
						numScore++;
						updateScore();


					}

				}
			}

		}

		private function playerHitTest(): void {

			//loop through current lasers
			for (var i: int = 0; i < enemyLaserArray.length; i++) {

				//check current laser
				var currentLaser: mcLaser = enemyLaserArray[i];

				//check if current laser is touching current enemy
				if (currentLaser.hitTestObject(mcPlayer)) {

					//create an explosion animation
					//create a new instance of the explosion object
					var newExplosion: mcExplosion = new mcExplosion();
					//add it to the stage
					stage.addChild(newExplosion);
					//position it over the current enemy
					newExplosion.x = mcPlayer.x;
					newExplosion.y = mcPlayer.y;
					//scale the explosion down
					newExplosion.width = (newExplosion.width / 2);
					newExplosion.height = (newExplosion.height / 2);
					//remove the lasers and enemies from the stage and arrays
					currentLaser.destroyLaser();
					enemyLaserArray.splice(i, 1);

					//decrease health bar
					healthBar.width -= 60;



				}

			}


		}

		private function enemyHitTest2(): void {

			//loop through current lasers
			for (var i: int = 0; i < laserArray2.length; i++) {

				//check current laser
				var currentLaser2: mcLaser = laserArray2[i];

				//loop through enemies
				for (var j: int = 0; j < enemyArray.length; j++) {

					//check current enemy
					var currentEnemy: mcEnemy = enemyArray[j];

					//check if current laser is touching current enemy
					if (currentLaser2.hitTestObject(currentEnemy)) {

						//create an explosion animation
						//create a new instance of the explosion object
						var newExplosion: mcExplosion = new mcExplosion();
						//add it to the stage
						stage.addChild(newExplosion);
						//position it over the current enemy
						newExplosion.x = currentEnemy.x;
						newExplosion.y = currentEnemy.y;

						//remove the lasers and enemies from the stage and arrays
						currentLaser2.destroyLaser();
						laserArray2.splice(i, 1);
						currentEnemy.destroyEnemy();
						enemyArray.splice(j, 1);

						//increase score on enemy kill
						numScore++;
						updateScore();


					}

				}
			}

		}
		private function killEnemy(): void {

			//get rid of enemies that are off screen
			for (var i: int = 0; i < enemyArray.length; i++) {

				//get the next enemy in the array
				var currentEnemy: mcEnemy = enemyArray[i];

				//check the position of the enemy
				if (currentEnemy.x < -(currentEnemy.width / 2)) {

					//remove current enemy from the array
					enemyArray.splice(i, 1);

					//remove current enemy from the stage
					currentEnemy.destroyEnemy();
					//this calls the destroyEnemy function from the enemy class

				}
			}

		}


		private function killLaser(): void {
			//get rid of lasers off screen
			for (var i: int = 0; i < laserArray.length; i++) {
				//get the next laser in teh array
				var currentLaser: mcLaser = laserArray[i];
				//check the position of the current laser
				if (currentLaser.x > 550) {
					//remove current laser from the array
					laserArray.splice(i, 1);
					//remove current laser from the stage
					currentLaser.destroyLaser();

				}
			}

		}

		private function killLaser2(): void {
			//get rid of lasers off screen
			for (var i: int = 0; i < enemyLaserArray.length; i++) {
				//get the next laser in teh array
				var currentLaser: mcLaser = enemyLaserArray[i];
				//check the position of the current laser
				if (currentLaser.x < 0) {
					//remove current laser from the array
					enemyLaserArray.splice(i, 1);
					//remove current laser from the stage
					currentLaser.destroyLaser();
				}
			}
		}
		//create a boundry to keep the player from going off the stage

		private function makeBoundry(): void {

			if (mcPlayer.y < mcPlayer.height / 2) {
				mcPlayer.y = mcPlayer.height / 2;
			} else if (mcPlayer.y > stage.stageHeight - (mcPlayer.height / 2)) {
				mcPlayer.y = stage.stageHeight - (mcPlayer.height / 2);
			}

			if (mcPlayer.x < mcPlayer.width / 2) {
				mcPlayer.x = mcPlayer.width / 2;
			} else if (mcPlayer.x > stage.stageWidth - (mcPlayer.width / 2)) {
				mcPlayer.x = stage.stageWidth - (mcPlayer.width / 2);
			}



		}

		private function movePlayer(): void {

			if (moveUp == true) {
				mcPlayer.y -= 5;
			}

			if (moveDown == true) {
				mcPlayer.y += 5;
			}

			if (moveLeft == true) {
				mcPlayer.x -= 5;
			}

			if (moveRight == true) {
				mcPlayer.x += 5;
			}

		}

		private function keyUp(evt: KeyboardEvent): void {

			//trace(evt.keyCode);

			if (evt.keyCode == 87) {
				moveUp = false;
			}


			if (evt.keyCode == 83) {
				moveDown = false;
			}

			if (evt.keyCode == 65) {
				moveLeft = false;
			}


			if (evt.keyCode == 68) {
				moveRight = false;
			}

			if (evt.keyCode == 32) {

				//test if ammo available
				if (numAmmo > 0) {

					numAmmo--;
					updateAmmo();

					fireLaser2();

				}

			}

		}

		private function fireLaser(): void {

			var newLaser: mcLaser = new mcLaser();
			//creates a new laser object
			stage.addChild(newLaser);

			newLaser.gotoAndStop(1);
			//adds a laser object to the stage
			newLaser.x = mcPlayer.x;
			newLaser.y = mcPlayer.y;
			//position the laser on the player


			newLaser.xVel = 10;

			//add lasers to an array for garbage collection
			laserArray.push(newLaser);
			//trace(laserArray.length);

		}

		private function fireLaser2(): void {

			var newLaser2: mcLaser = new mcLaser();
			//creates a new laser object
			stage.addChild(newLaser2);

			newLaser2.gotoAndStop(2);
			//adds a laser object to the stage
			newLaser2.x = mcPlayer.x;
			newLaser2.y = mcPlayer.y;
			//position the laser on the player

			newLaser2.xVel = 8;

			//add lasers to an array for garbage collection
			laserArray2.push(newLaser2);
			//trace(laserArray.length);

		}

		private function keyDown(evt: KeyboardEvent): void {

			if (evt.keyCode == 87) {
				moveUp = true;
			}


			if (evt.keyCode == 83) {
				moveDown = true;
			}

			if (evt.keyCode == 65) {
				moveLeft = true;
			}


			if (evt.keyCode == 68) {
				moveRight = true;
			}

		}

	}
}