package uk.co.homletmoo.ld28 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.utils.Dictionary;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Assets 
	{
		public static var cache:Dictionary;
		public static function scaleGraphic( img:*, sf:uint ):BitmapData
		{
			if ( cache == null )
				cache = new Dictionary();
			
			if ( cache[img] != null )
				return cache[img];
			
			var bit:BitmapData = FP.getBitmap( img );
			
			var width:int  = ( bit.width * sf  ) || 1;
			var height:int = ( bit.height * sf ) || 1;
			
			var result:BitmapData = new BitmapData( width, height, true, 0 );
			var matrix:Matrix = new Matrix();
			matrix.scale( sf, sf );
			result.draw( bit, matrix );
			
			cache[img] = result;
			
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
		
		[Embed (source = "res/seeds.png")]
		public static const SEEDS_RAW:Class;
		public static const SEEDS:BitmapData = FP.getBitmap( SEEDS_RAW );
		
		[Embed (source = "res/player.png")]
		public static const PLAYER_RAW:Class;
		public static const PLAYER:BitmapData = FP.getBitmap( PLAYER_RAW );
		
		[Embed (source = "res/inv_frame.png")]
		public static const INV_FRAME_RAW:Class;
		public static const INV_FRAME:BitmapData = FP.getBitmap( INV_FRAME_RAW );
		
		[Embed (source = "res/inv_slider.png")]
		public static const INV_SLIDER_RAW:Class;
		public static const INV_SLIDER:BitmapData = FP.getBitmap( INV_SLIDER_RAW );
		
		[Embed (source = "res/coin.png")]
		public static const COIN_RAW:Class;
		public static const COIN:BitmapData = FP.getBitmap( COIN_RAW );
		
		[Embed (source = "res/title.png")]
		public static const TITLE_RAW:Class;
		public static const TITLE:BitmapData = FP.getBitmap( TITLE_RAW );
		
		[Embed (source = "res/end.png")]
		public static const END_RAW:Class;
		public static const END:BitmapData = FP.getBitmap( END_RAW );
		
		
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
		
		[Embed (source = "res/tile_seeded_dirt.png")]
		public static const TILE_SEEDED_DIRT_RAW:Class;
		public static const TILE_SEEDED_DIRT:BitmapData = FP.getBitmap( TILE_SEEDED_DIRT_RAW );
		
		[Embed (source = "res/tile_tilled_l.png")]
		public static const TILE_TILLED_L_RAW:Class;
		public static const TILE_TILLED_L:BitmapData = FP.getBitmap( TILE_TILLED_L_RAW );
		
		[Embed (source = "res/tile_tilled_r.png")]
		public static const TILE_TILLED_R_RAW:Class;
		public static const TILE_TILLED_R:BitmapData = FP.getBitmap( TILE_TILLED_R_RAW );
		
		[Embed (source = "res/tile_crop.png")]
		public static const TILE_CROP_RAW:Class;
		public static const TILE_CROP:BitmapData = FP.getBitmap( TILE_CROP_RAW );
		
		[Embed (source = "res/tile_weed.png")]
		public static const TILE_WEED_RAW:Class;
		public static const TILE_WEED:BitmapData = FP.getBitmap( TILE_WEED_RAW );
	}
}
