package uk.co.homletmoo.ld28.player 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.Input;
	import uk.co.homletmoo.ld28.level.IsoMap;
	import uk.co.homletmoo.ld28.level.Tile;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Player extends Entity
	{
		public static const SPEED:Number = 30.0;
		
		public var inv:Inventory;
		
		public var flatPos:Point;
		
		private var pos:Point;
		private var target:Point;
		
		private var ground:IsoMap;
		private var crop:IsoMap;
		
		
		public function Player( ground:IsoMap, crop:IsoMap ) 
		{
			super( 0, 0, Image.createRect( 16, 28, 0xFF0000, 1 ) );
			
			layer = -10;
			
			this.ground = ground;
			this.crop = crop;
			
			inv = new Inventory();
			
			flatPos = new Point();
			
			pos    = new Point();
			target = new Point();
			
			FP.world.add( this );
		}
		
		public function move( p:Point ):void
		{
			target = p;
		}
		
		override public function update():void
		{
			var moving:Boolean = false;
			
			if ( target.x != pos.x
			  || target.y != pos.y )
			{
				var p:Point = IsoMap.project( target.x, target.y );
				moveTowards( p.x, p.y, SPEED );
				
				moving = true;
				pos = IsoMap.pick( x, y );
				flatPos = new Point( x, y );
			}
			
			if ( ( moving || Input.mouseReleased )
			  && target.x == pos.x
			  && target.y == pos.y )
			{
				var type:int = ground.at( pos.x, pos.y ).type;
				
				switch ( type )
				{
				case Tile.GRASS:
					ground.clear( pos.x, pos.y );
					break;
					
				case Tile.DIRT:
					ground.till( pos.x, pos.y );
					break;
					
				case Tile.TILLED_R:
				case Tile.TILLED_L:
					crop.plant( pos.x, pos.y, ground, inv.selected );
					break;
				}
				
			}
			
			super.update();
		}
	}
}
