package uk.co.homletmoo.ld28.player 
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.utils.Input;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	import uk.co.homletmoo.ld28.level.IsoMap;
	import uk.co.homletmoo.ld28.level.Tile;
	import uk.co.homletmoo.ld28.Main;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Player extends Entity
	{
		public static const SPEED:Number = 900.0;
		
		public var img:Spritemap;
		
		public var inv:Inventory;
		
		public var flatPos:Point;
		
		private var pos:Point;
		private var target:Point;
		
		private var ground:IsoMap;
		private var crop:IsoMap;
		
		
		public function Player( ground:IsoMap, crop:IsoMap ) 
		{
			super( 0, 0, Image.createRect( 16, 28, 0xFF0000, 1 ) );
			
			img = new Spritemap( Assets.scaleGraphic( Assets.PLAYER_RAW, 4 ), 9 * Display.SCALE, 14 * Display.SCALE );
			img.add( "still", [0, 1, 0, 0], 2 );
			img.add( "right",  [2, 3, 4, 5], 10 );
			img.add( "left", [6, 7, 8, 9], 10 );
			img.play( "still" );
			graphic = img;
			
			var p:Point = IsoMap.project( 5, 5 );
			x = p.x;
			y = p.y;
			
			layer = -20;
			type = "player";
			setHitboxTo( img );
			
			this.ground = ground;
			this.crop = crop;
			
			inv = new Inventory();
			
			flatPos = new Point( x, y );
			
			pos    = IsoMap.pick( x, y );
			target = IsoMap.pick( x, y );
			
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
				moveTowards( p.x - img.width / 2.0, p.y - img.height + 20, SPEED * FP.elapsed );
				img.play( p.x - x >= 0 ? "right" : "left" );
				
				moving = true;
				pos = IsoMap.pick( x + img.width / 2.0, y + img.height - 20 );
				flatPos = new Point( x, y );
			} else
				img.play( "still" );
			
			if ( ( moving || Input.mouseReleased )
			  && target.x == pos.x
			  && target.y == pos.y )
			{				
				var type:int = ground.at( pos.x, pos.y ).type;
				
				switch ( type )
				{
				case Tile.GRASS:
					if ( crop.at( pos.x, pos.y ).type == Tile.WEED )
						crop.deweed( pos.x, pos.y );
					else
						ground.clear( pos.x, pos.y );
					break;
				
				case Tile.DIRT:
				case Tile.SEEDED_DIRT:
					ground.till( pos.x, pos.y );
					break;
				
				case Tile.TILLED_R:
				case Tile.TILLED_L:
					if ( inv.seeds.length > 0 )
						crop.plant( pos.x, pos.y, ground, inv.seeds[inv.seeds.length - 1] );
					
					crop.harvest( pos.x, pos.y, ground );
					break;
				}
			}
			
			super.update();
		}
	}
}
