package uk.co.homletmoo.ld28.entity 
{
	import net.flashpunk.graphics.Image;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Tile
	{
		public static function img( type:*, x:int, y:int ):Image
		{
			var img:Image = new Image( type );
			img.scale = Display.SCALE;
			img.x = x;
			img.y = y;
			return img;
		}
		
		public static const W:int  = 30 * Display.SCALE;
		public static const H:int  = 15 * Display.SCALE;
		public static const HW:int = 14 * Display.SCALE;
		public static const HH:int = 7  * Display.SCALE;
		
		public static const TILE_NONE:*  = Assets.TILE_NONE;
		public static const TILE_GRASS:* = Assets.TILE_GRASS;
	}
}
