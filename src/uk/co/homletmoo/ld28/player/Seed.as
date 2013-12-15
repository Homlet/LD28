package uk.co.homletmoo.ld28.player 
{
	import uk.co.homletmoo.ld28.level.Tile;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Seed extends Entity
	{
		public static const WHEAT:int = 0;
		
		public var crop:int;
		
		
		public function Seed( x:int, y:int, crop:int, inInv:Boolean ) 
		{
			super( x, y, Image.createCircle( 10, 0xFF00, 1 ) );
			
			layer = inInv ? -110 : -1;
			
			this.crop = crop;
			
			FP.world.add( this );
		}
		
		public function plantOn( base:Tile ):int
		{
			switch ( crop )
			{
			case WHEAT:
				if ( base.type == Tile.TILLED_L
				  || base.type == Tile.TILLED_R )
					FP.world.remove( this );
					delete this;
					return Tile.WHEAT;
				break;
			}
			
			return Tile.NONE;
		}
	}
}
	