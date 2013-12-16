package uk.co.homletmoo.ld28.player 
{
	import net.flashpunk.graphics.Spritemap;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	import uk.co.homletmoo.ld28.level.Tile;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import uk.co.homletmoo.ld28.Sound;
	import uk.co.homletmoo.ld28.world.LevelWorld;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Seed extends Entity
	{
		public static const WHEAT:int     = 0;
		public static const RASPBERRY:int = 1;
		public static const CARROT:int    = 2;
		
		public static function random():int
		{
			return int( Math.floor( Math.random() * 0.99999 * 3 ) )
		}
		
		public var crop:int;
		public var inInv:Boolean;
		
		public var lostTimer:Number = 0.0;
		
		
		public function Seed( x:int, y:int, crop:int, inInv:Boolean ) 
		{
			super( x, y );
			
			var img:Spritemap = new Spritemap( Assets.SEEDS, 10, 10 );
			img.scale = Display.SCALE;
			img.add( "seed", [crop] );
			img.play( "seed" );
			graphic = img;
			
			setHitbox( img.scaledWidth + 20, img.scaledHeight + 20, 10, 10 );
			
			layer = inInv ? -110 : -1;
			
			this.crop = crop;
			this.inInv = inInv;
			
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
					(FP.world as LevelWorld).player.inv.seeds.pop();
					return Tile.WHEAT;
				break;
				
			case RASPBERRY:
				if ( base.type == Tile.TILLED_L
				  || base.type == Tile.TILLED_R )
					FP.world.remove( this );
					(FP.world as LevelWorld).player.inv.seeds.pop();
					return Tile.RASPBERRY;
				break;
				
			case CARROT:
				if ( base.type == Tile.TILLED_L
				  || base.type == Tile.TILLED_R )
					FP.world.remove( this );
					(FP.world as LevelWorld).player.inv.seeds.pop();
					return Tile.CARROT;
				break;
			}
			
			return Tile.NONE;
		}
		
		override public function update():void
		{
			if ( !inInv )
			{
				lostTimer += FP.elapsed;
				
				if ( lostTimer > 3.0 )
					FP.tween( this, { y: this.y - 15, alpha: 0 }, 1.0, { complete: kill } );
				else
				{
					var e:Player = (collide( "player", x, y ) as Player);
					if ( e != null && !e.inv.full() )
					{
						Sound.SEED.play( 0.5 );
						e.inv.seeds.push( this );
						inInv = true;
						layer = -110;
					}
				}
			}
		}
		
		public function set alpha( value:Number ):void
		{
			(graphic as Image).alpha = value;
		}
		
		public function get alpha():Number
		{
			return (graphic as Image).alpha;
		}
		
		private function kill():void
		{
			FP.world.remove( this );
		}
	}
}
	