package uk.co.homletmoo.ld28
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.StageQuality;
	import flash.utils.getTimer;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import net.flashpunk.Tweener;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import uk.co.homletmoo.ld28.world.LevelWorld;
	import uk.co.homletmoo.ld28.world.SplashWorld;
	
	[SWF (width = "800", height = "700", backgroundColor = "#000000")]
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Main extends Engine
	{
		public static var quake:Quake;
		
		public static var isPaused:Boolean = false;
		public static var isMuted:Boolean = false;
		public static var introComplete:Boolean = false;
		
		public static var pauseFader:DisplayObject;
		
		
		public function Main():void
		{
			super(
				Display.W,
				Display.H,
				Display.FRAME_RATE,
				Display.USE_FIXED_TIME
			);
			
			stage.quality = StageQuality.LOW;
			
			quake = new Quake();
			
			FP.screen.color = 0xFF000000
			
			pauseFader = new Bitmap( new BitmapData( Display.W, Display.H, true, 0x88000000 ) );
			addChild( pauseFader );
			
			if ( CONFIG::debug )
			{
				FP.console.enable();
				FP.console.toggleKey = Key.TAB;
			}
		}
		
		override public function init():void
		{
			Sound.initialize();
			Inputs.register();
			
			FP.world = new SplashWorld();
		}
		
		override public function update():void
		{
			if ( FP.elapsed < 1.0 / Display.FRAME_RATE )
			{
				var start:int = getTimer();
				while ( getTimer() - start >= 1.0 / Display.FRAME_RATE * 1000 ) {}
			}
			
			quake.update();
			
			if ( !( FP.world is LevelWorld ) )
			{
				isMuted = false;
			} else if ( Input.pressed( Inputs.MUTE ) )
			{
				if ( !isMuted )
				{
					if ( !isPaused )
						stopMusic();
					isMuted = true;
				} else
				{
					if ( !isPaused )
						resumeMusic();
					isMuted = false;
				}
			}
			
			if ( !( FP.world is LevelWorld ) )
			{
				isPaused = false;
				pauseFader.visible = false;
				FP.world.active = true;
			} else if ( Input.pressed( Inputs.PAUSE ) )
			{
				if ( !isPaused )
				{
					FP.world.active = false;
					
					if ( !isMuted )
						stopMusic();
					
					isPaused = true;
					pauseFader.visible = true;
				} else
				{
					FP.world.active = true;
					
					if ( !isMuted )
						resumeMusic();
					
					isPaused = false;
					pauseFader.visible = false;
				}
			} else if ( isPaused )
				FP.world.active = false;
			
			super.update();
		}
		
		public static function startMusic():void
		{
			Sound.LOOP.stop();
			Sound.INTRO.play( 0.6 );
		}
		
		public static function stopMusic():void
		{
			introComplete = Sound.LOOP.playing;
			introComplete ?
				Sound.LOOP.stop() :
				Sound.INTRO.stop();
		}
		
		public static function resumeMusic():void
		{
			introComplete ?
				Sound.LOOP.resume() :
				Sound.INTRO.resume();
		}
	}
}
