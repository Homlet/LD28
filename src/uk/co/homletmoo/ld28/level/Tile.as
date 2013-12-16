package uk.co.homletmoo.ld28.level 
{
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Spritemap;
	import uk.co.homletmoo.ld28.player.Seed;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	import uk.co.homletmoo.ld28.world.LevelWorld;
	
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
		public static const NONE:int        = 0;
		public static const GRID:int        = 1;
		// Terrain.
		public static const GRASS:int       = 2;
		public static const DIRT:int        = 3;
		public static const TILLED_L:int    = 4;
		public static const TILLED_R:int    = 5;
		public static const SEEDED_DIRT:int = 6;
		// Crops.
		public static const WHEAT:int       = 7;
		public static const RASPBERRY:int   = 8;
		public static const CARROT:int      = 9;
		// Yucky weeds.
		public static const WEED:int        = 20;
		
		
		public var img:Image;
		public var type:int;
		public var x:int, y:int, altitude:int;
		public var content:*;
		public var stage:int;
		
		public function Tile( x:int, y:int, altitude:int, type:int )
		{
			this.x = x;
			this.y = y;
			this.altitude = altitude;
			this.type = type;
			this.stage = 0;
			
			switch ( type )
			{
			case NONE: break;
			case GRID:        img = image( Assets.TILE_GRID ); break;
			case GRASS:       img = image( Assets.TILE_GRASS ); break;
			case DIRT:        img = image( Assets.TILE_DIRT ); break;
			case SEEDED_DIRT: img = image( Assets.TILE_SEEDED_DIRT ); break;
			case TILLED_L:    img = image( Assets.TILE_TILLED_L ); break;
			case TILLED_R:    img = image( Assets.TILE_TILLED_R ); break;
			case WEED:
				img = new Spritemap( Assets.scaleGraphic( Assets.TILE_WEED_RAW, Display.SCALE ), 30 * Display.SCALE, 29 * Display.SCALE, spreadWeed );
				(img as Spritemap).add( "grow", [0, 1, 2, 3, 4], 2, false );
				(img as Spritemap).add( "dead", [5], 0, false );
				(img as Spritemap).play( "grow" );
				img.x = x * HW - y * HW;
				img.y = x * HH + y * HH - altitude * H;
				break;
			default:
				var t5:int = (type - WHEAT) * 5;
				var frames:Array = [t5, t5 + 1, t5 + 2, t5 + 3, t5 + 4];
				img = new Spritemap( Assets.scaleGraphic( Assets.TILE_CROP_RAW, Display.SCALE ), 30 * Display.SCALE, 29 * Display.SCALE );
				(img as Spritemap).add( "grow", frames, 0.5, false );
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
		
		public function spreadWeed( depth:int = 0 ):void
		{
			if ( depth > 5 )
				return;
			
			var sx:int = Math.round( Math.random() * 2.0 - 1.0 );
			var sy:int = Math.round( Math.random() * 2.0 - 1.0 );
			
			if ( sx == 0 && sy == 0 )
				sx = 1;
			
			var level:LevelWorld = (FP.world as LevelWorld);
			
			for ( var i:int = 0; i < 8; i++ ) // Dodgy code here.
			{
				if ( level.ground.at( x + sx, y + sy ).type != NONE )
				{
					var nx:int = x + sx;
					var ny:int = x + sy;
					
					if ( level.crop.at( nx, ny ).type == WEED )
					{
						level.crop.at( nx, ny ).spreadWeed( depth + 1 );
						break;
					}
					
					if ( nx >= 0           && ny >= 0
					  && nx <  level.width && ny <  level.depth
					  && Math.abs( nx - ny ) <= level.edge )
					{
						level.crop.weed( nx, ny, level.ground, true );
						level.ground.data[nx][ny] = new Tile( nx, ny, 0, GRASS );
						level.ground.fill();
					}
					break;
				}
				
				sx = Math.round( Math.random() * 2.0 - 1.0 );
				sy = Math.round( Math.random() * 2.0 - 1.0 );
			
				if ( sx == 0 && sy == 0 )
					sx = 1;
			}
			
			(img as Spritemap).play( "dead" );
		}
		
		public function update():void
		{
			var level:LevelWorld = (FP.world as LevelWorld);
			switch ( type )
			{
			case GRID:
				var mx:int = Input.mouseX;
				var my:int = Input.mouseY;
				var ix:int = img.x + IsoMap.offset_x + HW;
				var iy:int = img.y + IsoMap.offset_y + HH;
				(img as Image).alpha = 0.45 - Math.sqrt( Math.pow( mx - ix, 2 ) + Math.pow( ( my - iy ) * 2, 2 ) ) / 400.0;
				(img as Image).visible = (img as Image).alpha > 0.2;
				break;
			
			case DIRT:
				if ( Math.random() < 0.05
				 || ( Math.random() < 0.15
				  && ( level.ground.at( x + 1, y ).type == Tile.GRASS
				    || level.ground.at( x - 1, y ).type == Tile.GRASS
				    || level.ground.at( x, y + 1 ).type == Tile.GRASS
				    || level.ground.at( x, y - 1 ).type == Tile.GRASS ) ) )
					level.ground.data[x][y] = new Tile( x, y, 0, Tile.GRASS );
					level.ground.fill();
				break;
			
			case TILLED_R:
			case TILLED_L:
				if ( level.crop.at( x, y ).type == NONE
				  && ( ( Math.random() < 0.1
				  && ( level.ground.at( x + 1, y ).type == Tile.GRASS
				    || level.ground.at( x - 1, y ).type == Tile.GRASS
				    || level.ground.at( x, y + 1 ).type == Tile.GRASS
				    || level.ground.at( x, y - 1 ).type == Tile.GRASS ) )
				  || Math.random() < 0.015 ) )
					level.ground.data[x][y] = new Tile( x, y, 0, Tile.SEEDED_DIRT );
					level.ground.fill();
				break;
			
			case SEEDED_DIRT:
				level.ground.data[x][y] = new Tile( x, y, 0, Tile.GRASS );
				level.ground.fill();
				break;
			
			case NONE:
				if ( Math.random() < level.weedRate
				  && level.ground.at( x, y ).type == Tile.GRASS )
					level.crop.weed( x, y, level.ground );
				break;
				
			case WEED:
				if ( (img as Spritemap).frame == 5
				  && Math.random() < level.weedRate )
				{
					spreadWeed();
				}
				break;
			}
		}
	}
}
