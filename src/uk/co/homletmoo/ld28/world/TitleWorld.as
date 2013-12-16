package uk.co.homletmoo.ld28.world 
{
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class TitleWorld extends World
	{
		public var fader:Image = Image.createRect( Display.W, Display.H );
		
		public function TitleWorld() 
		{
			var img:Image = new Image( Assets.TITLE );
			img.scale = Display.SCALE;
			
			addGraphic( img );
		}
		
		override public function begin():void
		{
			FP.tween( fader, { alpha: 0 }, 1.0 );
		}
		
		override public function update():void
		{
			if ( Input.mouseReleased )
				FP.world = new LevelWorld();
		}
	}
}
