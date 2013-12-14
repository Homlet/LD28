package uk.co.homletmoo.ld28 
{
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Sound 
	{
//		[Embed (source = "...")] public static const INTRO_RAW:Class;
//		[Embed (source = "...")] public static const LOOP_RAW:Class;
		public static var INTRO:Sfx;
		public static var LOOP:Sfx;
		
		
		public static function initialize():void
		{
//			INTRO = new Sfx( INTRO_RAW, loopMusic );
//			LOOP  = new Sfx( LOOP_RAW );
		}
		
		private static function loopMusic():void
		{
			LOOP.loop( 0.6 );
		}
	}
}
