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
		public static const JUMP:String  = "jump";
		public static const RIGHT:String = "right";
		public static const LEFT:String  = "left";
		
		public static const PAUSE:String = "pause";
		public static const MUTE:String  = "mute";
		
		
		public static function register():void
		{
			Input.define( JUMP,  Key.W, Key.UP, Key.Z, Key.X, Key.SPACE );
			Input.define( RIGHT, Key.D, Key.RIGHT );
			Input.define( LEFT,  Key.A, Key.LEFT  );
			
			Input.define( PAUSE, Key.P, Key.ESCAPE );
			Input.define( MUTE,  Key.M );
		}
	}
}
