package uk.co.homletmoo.ld28.level 
{
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import uk.co.homletmoo.ld28.player.Seed;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Tile 
	{
		public static const W:int  = 30 * Display.SCALE;
		public static const H:int  = 15 * Display.SCALE;
		public static const HW:int = 14 * Display.SCALE;
		public static const HH:int = 7  * Display.SCALE;
		
		// Empty.
		public static const NONE:int     = 0;
		public static const GRID:int     = 1;
		// Terrain.
		public static const GRASS:int    = 2;
		public static const DIRT:int     = 3;
		public static const TILLED_L:int = 4;
		public static const TILLED_R:int = 5;
		// Crops.
		public static const WHEAT:int    = 6;
		
		
		public var img:Image;
		public var parent:IsoMap;
		public var type:int;
		public var x:int, y:int, altitude:int;
		public var content:*;
		public var stage:int;
		
		public function Tile( x:int, y:int, altitude:int, parent:IsoMap, type:int )
		{
			this.x = x;
			this.y = y;
			this.altitude = altitude;
			this.parent = parent;
			this.type = type;
			this.stage = 0;
			
			switch ( type )
			{
			case NONE: break;
			case GRID:     img = image( Assets.TILE_GRID ); break;
			case GRASS:    img = image( Assets.TILE_GRASS ); break;
			case DIRT:     img = image( Assets.TILE_DIRT ); break;
			case TILLED_L: img = image( Assets.TILE_TILLED_L ); break;
			case TILLED_R: img = image( Assets.TILE_TILLED_R ); break;
			case WHEAT:
				img = new Spritemap( Assets.scaleGraphic( Assets.TILE_WHEAT_RAW, Display.SCALE ), 30 * Display.SCALE, 29 * Display.SCALE );
				(img as Spritemap).add( "grow", [0, 1, 2, 3, 4], 0.5, false );
				(img as Spritemap).play( "grow" );
				img.x = x * HW - y * HW;
				img.y = x * HH + y * HH - altitude * H;
				break;
			}
		}
		
		private function image( src:* ):Image
		{
			var img:Image = new Image( src );
			img.scale = Display.SCALE;
			img.x = x * HW - y * HW;
			img.y = x * HH + y * HH - altitude * H;
			if ( type == GRID ) img.alpha = 0.2;
			return img;
		}
		
		public function update():void
		{
			switch ( type )
			{
			case GRID:
				var mx:int = Input.mouseX;
				var my:int = Input.mouseY;
				var ix:int = img.x + IsoMap.offset_x + HW;
				var iy:int = img.y + IsoMap.offset_y + HH;
				(img as Image).alpha = 0.45 - Math.sqrt( Math.pow( mx - ix, 2 ) + Math.pow( ( my - iy ) * 2, 2 ) ) / 400.0;
				break;
			
			case DIRT:
				if ( Math.random() < 0.05
				 || ( Math.random() < 0.15
				  && ( parent.at( x + 1, y ).type == Tile.GRASS
				    || parent.at( x - 1, y ).type == Tile.GRASS
				    || parent.at( x, y + 1 ).type == Tile.GRASS
				    || parent.at( x, y - 1 ).type == Tile.GRASS ) ) )
					parent.data[x][y] = new Tile( x, y, altitude, parent, Tile.GRASS );
					parent.fill();
				break;
			
			case WHEAT:
				break;
			}
		}
	}
}
