package uk.co.homletmoo.ld28.world 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	import uk.co.homletmoo.ld28.Sound;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class EndWorld extends World
	{
		public var fader:Image = Image.createRect( Display.W, Display.H );
		
		public var scoreText:Text;
		public var coinImg:Image;
		
		public var timer:Number = 0.0;
		
		public function EndWorld( score:int ) 
		{
			Sound.INTRO.stop();
			Sound.LOOP.stop();
			
			var img:Image = new Image( Assets.END );
			img.scale = Display.SCALE;
			
			scoreText = new Text( "= " + score, Display.HW - 16 * Display.SCALE, Display.HH );
			scoreText.size = 8;
			scoreText.scale = Display.SCALE;
			
			coinImg = new Image( Assets.COIN );
			coinImg.scale = Display.SCALE;
			coinImg.x = Display.HW - 19 * Display.SCALE - coinImg.scaledWidth;
			coinImg.y = Display.HH + 4 * Display.SCALE;
			
			addGraphic( img );
			addGraphic( scoreText );
			addGraphic( coinImg );
		}
		
		override public function begin():void
		{
			FP.tween( fader, { alpha: 0 }, 1.0 );
		}
		
		override public function update():void
		{
			timer += FP.elapsed;
			
			if ( timer > 1.5 && Input.mouseReleased )
				FP.world = new LevelWorld();
		}
	}
}
