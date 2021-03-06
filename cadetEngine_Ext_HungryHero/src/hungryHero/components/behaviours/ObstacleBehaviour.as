package hungryHero.components.behaviours
{
	import cadet.core.Component;
	
	import cadet2D.components.skins.ImageSkin;
	import cadet2D.components.skins.MovieClipSkin;
	import cadet2D.components.transforms.Transform2D;
	
	public class ObstacleBehaviour extends Component
	{
		private var _speed:int;				// Speed of the obstacle.
		private var _distance:int; 			// Distance after which the obstacle should appear on screen.
		private var _showLookOut:Boolean; 	// Look out sign status.
		private var _alreadyHit:Boolean; 	// Has the hero already collided with the obstacle?
		private var _position:String; 		// Vertical position of the obstacle.
		
		[Serializable][Inspectable( editor="ComponentList", scope="parent", priority="50") ]
		public var defaultSkin	:ImageSkin;
		[Serializable][Inspectable( editor="ComponentList", scope="parent", priority="51") ]
		public var crashSkin	:ImageSkin;
		[Serializable][Inspectable( editor="ComponentList", scope="scene", priority="52") ]
		public var warningSkin	:MovieClipSkin;
		
		public var transform	:Transform2D;
		
		public function ObstacleBehaviour( name:String = "ObstacleBehaviour" )
		{
			super( name );
		}
		
		public function init():void
		{
			alreadyHit = false;
			lookOut = true;
			if (transform)	transform.rotation = 0;
		}
		
		override protected function addedToScene():void
		{
			addSiblingReference(Transform2D, "transform");
		}
		
		/**
		 * Look out sign status. 
		 * 
		 */
		public function get lookOut():Boolean { return _showLookOut; }
		public function set lookOut(value:Boolean):void
		{
			_showLookOut = value;
			
			if (warningSkin) {
				if (_showLookOut) {
					warningSkin.visible = true;
				} else {
					warningSkin.visible = false;
				}
			}
		}
		
		/**
		 * Has the hero collided with the obstacle? 
		 * 
		 */
		public function get alreadyHit():Boolean { return _alreadyHit; }
		public function set alreadyHit(value:Boolean):void
		{
		//	if ( _alreadyHit != value ) {
				if ( value ) {
					defaultSkin.visible = false;
					crashSkin.visible = true;
	/*				obstacleCrashImage.visible = true;
					if (_type == GameConstants.OBSTACLE_TYPE_4)
					{
						obstacleAnimation.visible = false;
					}
					else
					{
						obstacleImage.visible = false;
						Starling.juggler.remove(obstacleAnimation);
					}*/
				} else {
					defaultSkin.visible = true;
					crashSkin.visible = false;
				}
			//}
			
			_alreadyHit = value;
		}
		
		// Speed of the obstacle.
		public function get speed():int { return _speed; }
		public function set speed(value:int):void { _speed = value; }
		
		// Distance after which the obstacle should appear on screen.
		public function get distance():int { return _distance; }
		public function set distance(value:int):void { _distance = value; }
		
		// Vertical position of the obstacle. 
		public function get position():String { return _position; }
		public function set position(value:String):void { _position = value; }
	}
}