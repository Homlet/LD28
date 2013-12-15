package uk.co.homletmoo.ld28 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Assets 
	{
		public static function scaleGraphic( img:*, sf:uint ):BitmapData
		{
			var bit:BitmapData = FP.getBitmap( img );
			
			var width:int  = ( bit.width * sf  ) || 1;
			var height:int = ( bit.height * sf ) || 1;
			
			var result:BitmapData = new BitmapData( width, height, true, 0 );
			var matrix:Matrix = new Matrix();
			matrix.scale( sf, sf );
			result.draw( bit, matrix );
			
			return result;
		}
		
		
		// Graphics
		[Embed (source = "res/HMV4.png")]
		public static const HM_LOGO_RAW:Class;
		public static const HM_LOGO:BitmapData = FP.getBitmap( HM_LOGO_RAW );
		
		[Embed (source = "res/flashpunk.png")]
		public static const FP_LOGO_RAW:Class;
		public static const FP_LOGO:BitmapData = FP.getBitmap( FP_LOGO_RAW );
		
		[Embed (source = "res/sheen.png")]
		public static const SHEEN_RAW:Class;
		public static const SHEEN:BitmapData = FP.getBitmap( SHEEN_RAW );
		
		[Embed (source = "res/dirt_0.png")]
		public static const DIRT_0_RAW:Class;
		public static const DIRT_0:BitmapData = FP.getBitmap( DIRT_0_RAW );
		
		[Embed (source = "res/dirt_1.png")]
		public static const DIRT_1_RAW:Class;
		public static const DIRT_1:BitmapData = FP.getBitmap( DIRT_1_RAW );
		
		[Embed (source = "res/dirt_2.png")]
		public static const DIRT_2_RAW:Class;
		public static const DIRT_2:BitmapData = FP.getBitmap( DIRT_2_RAW );
		
		[Embed (source = "res/sun.png")]
		public static const SUN_RAW:Class;
		public static const SUN:BitmapData = FP.getBitmap( SUN_RAW );
		
		[Embed (source = "res/moon.png")]
		public static const MOON_RAW:Class;
		public static const MOON:BitmapData = FP.getBitmap( MOON_RAW );
		
		
		// Tiles
		[Embed (source = "res/tile_grid.png")]
		public static const TILE_GRID_RAW:Class;
		public static const TILE_GRID:BitmapData = FP.getBitmap( TILE_GRID_RAW );
		
		[Embed (source = "res/tile_grass.png")]
		public static const TILE_GRASS_RAW:Class;
		public static const TILE_GRASS:BitmapData = FP.getBitmap( TILE_GRASS_RAW );
		
		[Embed (source = "res/tile_dirt.png")]
		public static const TILE_DIRT_RAW:Class;
		public static const TILE_DIRT:BitmapData = FP.getBitmap( TILE_DIRT_RAW );
		
		[Embed (source = "res/tile_tilled_l.png")]
		public static const TILE_TILLED_L_RAW:Class;
		public static const TILE_TILLED_L:BitmapData = FP.getBitmap( TILE_TILLED_L_RAW );
		
		[Embed (source = "res/tile_tilled_r.png")]
		public static const TILE_TILLED_R_RAW:Class;
		public static const TILE_TILLED_R:BitmapData = FP.getBitmap( TILE_TILLED_R_RAW );
		
		[Embed (source = "res/tile_wheat.png")]
		public static const TILE_WHEAT_RAW:Class;
		public static const TILE_WHEAT:BitmapData = FP.getBitmap( TILE_WHEAT_RAW );
	}
}
