package uk.co.homletmoo.ld28.world 
{
	import net.flashpunk.World;
	import uk.co.homletmoo.ld28.entity.IsoMap;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class LevelWorld extends World
	{
		public var ground:IsoMap;
		
		
		override public function begin():void
		{
			ground = new IsoMap( 4, 4 );
			ground.x = 250;
		}
	}
}
