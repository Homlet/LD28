package uk.co.homletmoo.ld28.player 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import uk.co.homletmoo.ld28.player.Seed;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Inventory extends Entity
	{
		public var seeds:Array;
		public var selected:Seed;
		
		public function Inventory() 
		{
			super( 0, 0, Image.createRect( 550, 50, 0xFF0000, 1 ) );
			
			layer = -100;
			
			seeds = new Array();
			seeds[0] = new Seed( 20, 20, Seed.WHEAT, true );
			selected = seeds[0];
			
			FP.world.add( this );
		}
		
		override public function update():void
		{
			
			
			super.update();
		}
	}
}
