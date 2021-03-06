package hungryHero.controller
{
	import flash.events.Event;
	
	import hungryHero.Main;
	import hungryHero.components.processes.GlobalsProcess;
	import hungryHero.events.NavigationEvent;
	import hungryHero.model.IGameModel;
	import hungryHero.sound.Sounds;
	import hungryHero.view.GameView;
	import hungryHero.view.WelcomeView;
	
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;

	public class GameViewController implements IController
	{
		private var _view			:GameView;
		
		// Tween object for game over container.
		private var tween_gameOverContainer:Tween;
		
		private var _gameModel		:IGameModel;
		
		public function GameViewController()
		{
		}
		
		public function init(view:DisplayObjectContainer):void
		{
			_view	= GameView(view);
			_gameModel = Main.gameModel;
			
			_gameModel.globalsProcess.addEventListener( GlobalsProcess.GAME_STATE_ENDED, gameEndedHandler );
			
			enable();
		}
		
		public function reInit():void
		{
			enable();
		}
		
		public function dispose():void
		{
			disable();
		}
		
		public function enable():void
		{
			_gameModel.soundProcess.muted = Sounds.muted;
			_gameModel.soundProcess.playSound(_gameModel.soundProcess.music);

			_gameModel.globalsProcess.paused = true;
			
			Sounds.instance.addEventListener( flash.events.Event.CHANGE, toggleMuteHandler );
			
			_view.visible = true;
			
			_view.initialize();
			
			_view.pauseButton.addEventListener(starling.events.Event.TRIGGERED, onPauseButtonClick);
			_view.startButton.addEventListener(starling.events.Event.TRIGGERED, onStartButtonClick);
			_view.gameOverContainer.addEventListener(NavigationEvent.CHANGE_SCREEN, onInGameNavigation);
			_view.addEventListener(starling.events.Event.ENTER_FRAME, enterFrameHandler);
		}
		
		public function disable():void
		{
			_gameModel.globalsProcess.paused = true;
			
			Sounds.instance.removeEventListener( flash.events.Event.CHANGE, toggleMuteHandler );
			
			_gameModel.soundProcess.stopSound(_gameModel.soundProcess.music);
			
			_view.visible = false;
			
			_view.disposeTemporarily();
			
			_view.pauseButton.removeEventListener(starling.events.Event.TRIGGERED, onPauseButtonClick);
			_view.startButton.removeEventListener(starling.events.Event.TRIGGERED, onStartButtonClick);
			_view.gameOverContainer.removeEventListener(NavigationEvent.CHANGE_SCREEN, onInGameNavigation);
			_view.removeEventListener(starling.events.Event.ENTER_FRAME, enterFrameHandler);
		}
		
		private function enterFrameHandler( event:starling.events.Event ):void
		{
			if (!_gameModel.globalsProcess) return;
			_view.hud.distance = Math.round(_gameModel.globalsProcess.scoreDistance);
			_view.hud.foodScore = _gameModel.globalsProcess.scoreItems;
			_view.hud.lives = _gameModel.globalsProcess.currentLives;
		}
		
		private function toggleMuteHandler( event:flash.events.Event ):void
		{
			_gameModel.soundProcess.muted = Sounds.muted;
		}
		
		// On click of pause button. 
		// @param event
		private function onPauseButtonClick(event:starling.events.Event):void
		{
			event.stopImmediatePropagation();
			
			_gameModel.globalsProcess.paused = ! _gameModel.globalsProcess.paused;
		}
		
		// On navigation from different screens. 
		// @param event
		private function onInGameNavigation(event:NavigationEvent):void	
		{
			if (event.params.id == "playAgain") {
				tween_gameOverContainer = new Tween(_view.gameOverContainer, 1);
				tween_gameOverContainer.fadeTo(0);
				tween_gameOverContainer.onComplete = gameOverFadedOut;
				Starling.juggler.add(tween_gameOverContainer);
			} else if ( event.params.id == "mainMenu" ) {
				Main.viewManager.changeView( WelcomeView );
			} else if ( event.params.id == "about" ) {
				Main.viewManager.changeView( WelcomeView );
				var wvController:WelcomeViewController = WelcomeViewController(Main.viewManager.currentController);
				wvController.showAboutScreen();
			}
		}
		
		// On game over screen faded out.
		private function gameOverFadedOut():void
		{
			_gameModel.globalsProcess.paused = true;
			_gameModel.reset();
			
			_view.gameOverContainer.visible = false;
			_view.initialize();
		}
		
		// On start button click. 
		//  @param event
		private function onStartButtonClick(event:starling.events.Event):void
		{
			// Play coffee sound for button click.
			if (!Sounds.muted) Sounds.sndCoffee.play();
			
			// Hide start button.
			_view.startButton.visible = false;
			
			// Show pause button since the game is started.
			_view.pauseButton.visible = true;
			
			_gameModel.globalsProcess.paused = false;
			_gameModel.reset();
		}
		
		private function gameEndedHandler(event:flash.events.Event):void
		{
			_view.setChildIndex(_view.gameOverContainer, _view.numChildren-1);
			_view.gameOverContainer.initialize(_gameModel.globalsProcess.scoreItems, Math.round(_gameModel.globalsProcess.scoreDistance));
			
			tween_gameOverContainer = new Tween(_view.gameOverContainer, 1);
			tween_gameOverContainer.fadeTo(1);
			Starling.juggler.add(tween_gameOverContainer);
		}
	}
}







