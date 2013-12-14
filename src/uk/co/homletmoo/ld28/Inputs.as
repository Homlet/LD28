package uk.co.homletmoo.ld28 
{
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Inputs 
	{
		public static const PAUSE:String = "pause";
		public static const MUTE:String  = "mute";
		
		
		public static function register():void
		{
			Input.define( PAUSE, Key.P, Key.ESCAPE );
			Input.define( MUTE,  Key.M );
		}
	}
}
