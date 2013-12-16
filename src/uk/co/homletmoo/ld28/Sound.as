package uk.co.homletmoo.ld28 
{
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Sound 
	{
		[Embed (source = "res/start.mp3")]
		public static const START_RAW:Class;
		public static var START:Sfx;
		
		[Embed (source = "res/end.mp3")]
		public static const END_RAW:Class;
		public static var END:Sfx;
		
		[Embed (source = "res/hit.mp3")]
		public static const HIT_RAW:Class;
		public static var HIT:Sfx;
		
		[Embed (source = "res/destroy.mp3")]
		public static const DESTROY_RAW:Class;
		public static var DESTROY:Sfx;
		
		[Embed (source = "res/dig.mp3")]
		public static const DIG_RAW:Class;
		public static var DIG:Sfx;
		
		[Embed (source = "res/harvest.mp3")]
		public static const HARVEST_RAW:Class;
		public static var HARVEST:Sfx;
		
		[Embed (source = "res/seed.mp3")]
		public static const SEED_RAW:Class;
		public static var SEED:Sfx;
		
		[Embed (source = "res/intro.mp3")]
		public static const INTRO_RAW:Class;
		public static var INTRO:Sfx;
		
		[Embed (source = "res/loop.mp3")]
		public static const LOOP_RAW:Class;
		public static var LOOP:Sfx;
		
		
		public static function initialize():void
		{
			START = new Sfx( START_RAW );
			END = new Sfx( END_RAW );
			HIT = new Sfx( HIT_RAW );
			DESTROY = new Sfx( DESTROY_RAW );
			DIG = new Sfx( DIG_RAW );
			HARVEST = new Sfx( HARVEST_RAW );
			SEED = new Sfx( SEED_RAW );
			
			INTRO = new Sfx( INTRO_RAW, loopMusic );
			LOOP  = new Sfx( LOOP_RAW );
		}
		
		private static function loopMusic():void
		{
			LOOP.loop( 0.6 );
		}
	}
}
