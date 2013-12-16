package uk.co.homletmoo.ld28.level 
{
	import com.greensock.easing.SteppedEase;
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.Graphic;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	import uk.co.homletmoo.ld28.Main;
	import uk.co.homletmoo.ld28.player.Seed;
	import uk.co.homletmoo.ld28.Sound;
	import uk.co.homletmoo.ld28.world.LevelWorld;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class IsoMap extends Entity
	{
		public static function pick( sx:int, sy:int ):Point
		{
			var p:Point = new Point();
			
			sx -= offset_x + Tile.HW;
			sy -= offset_y;
			
			p.x = Math.floor( ( sx / Tile.HW + sy / Tile.HH ) / 2 );
			p.y = Math.floor( ( sy / Tile.HH - sx / Tile.HW ) / 2 );
			
			return p;
		}
		
		public static function project( x:int, y:int ):Point
		{
			var p:Point = new Point();
			
			p.x = x * Tile.HW - y * Tile.HW + offset_x + Tile.HW;
			p.y = x * Tile.HH + y * Tile.HH + offset_y;
			
			return p;
		}
		
		public static const CROP:int    = 0;
		public static const GRID:int    = 1;
		public static const TERRAIN:int = 2;
		
		public static const BASE_OFFSET_X:int = Display.HW - Tile.HW;
		public static const BASE_OFFSET_Y:int = 25 * Display.SCALE;
		public static var offset_x:int = BASE_OFFSET_X;
		public static var offset_y:int = BASE_OFFSET_Y;
		
		public static var empty:Tile = new Tile( 0, 0, 0, Tile.NONE );
		
		public var data:Vector.<Vector.<Tile> >;
		public var data_width:int, data_depth:int, data_type:int;
		public var altitude:int;
		public var updating:Point;
		
		public var cropCount:int = 0;
		
		
		public function IsoMap( width:int, depth:int, edge:int = 0, type:int = TERRAIN ) 
		{
			super();
			
			this.data_width = width;
			this.data_depth = depth;
			this.data_type  = type;
			
			x = offset_x;
			y = offset_y;
			
			altitude = data_type == CROP ? 1 : 0;
			updating = new Point( 0, 0 );
			layer = type;
			
			data = new Vector.<Vector.<Tile> >( width );
			for ( var i:int = 0; i < data_width; i++ )
			{
				data[i] = new Vector.<Tile>( depth );
				for ( var j:int = 0; j < data_depth; j++ )
				{
					if ( edge > 0
					  && Math.abs( i - j ) > edge )
						continue;
					
					switch ( type )
					{
					case GRID:
						data[i][j] = new Tile( i, j, altitude, Tile.GRID );
						break;
						
					case TERRAIN:
						if ( i == 4 && j == 4 )
						{
							var t:int = ( i + j ) % 2 == 0 ? Tile.TILLED_L : Tile.TILLED_R;
							data[i][j] = new Tile( i, j, altitude, t );
						}
						else if ( Math.abs( i - j ) < 2 )
							data[i][j] = new Tile( i, j, altitude, Tile.DIRT );
						else if ( Math.random() < 0.2 )
							data[i][j] = new Tile( i, j, altitude, Tile.DIRT );
						else
							data[i][j] = new Tile( i, j, altitude, Tile.GRASS );
						break;
						
					case CROP:
						if ( i == 4 && j == 4 )
						{
							cropCount = 1;
							data[i][j] = new Tile( i, j, altitude, Tile.WHEAT );
						}
						else
							data[i][j] = new Tile( i, j, altitude, Tile.NONE );
					}
				}
			}
			
			fill();
			FP.world.add( this );
		}
		
		public function fill():void
		{
			graphic = null;
			
			for ( var i:int = 0; i < data_depth * 2; i++ )
			for ( var x:int = 0, y:int = i; y >= 0; x++, y-- )
				if ( x < data_width
				  && y < data_depth
				  && at( x, y ) != null
				  && at( x, y ).type != Tile.NONE )
				{
					if ( data_type == CROP )
						addGraphic( (data[x][y].img as Spritemap) );
					else
						addGraphic( at( x, y ).img );
				}
		}
		
		public function at( x:int, y:int ):Tile
		{
			x = Math.max( Math.min( x, data_width - 1 ), 0 );
			y = Math.max( Math.min( y, data_depth - 1 ), 0 );
			var t:Tile = data[x][y];
			if ( t == null )
				return empty;
			return t;
		}
		
		public function till( x:int, y:int ):void
		{
			if ( data_type != TERRAIN )
				return;
			
			if ( at( x, y ).type == Tile.DIRT
			  || at( x, y ).type == Tile.SEEDED_DIRT )
			{
				Sound.DIG.play( 0.5 );
				var type:int = ( x + y ) % 2 == 0 ? Tile.TILLED_L : Tile.TILLED_R;
				data[x][y] = new Tile( x, y, altitude, type );
			}
			
			fill();
		}
		
		public function clear( x:int, y:int ):void
		{
			if ( data_type != TERRAIN )
				return;
			
			if ( at( x, y ).type == Tile.GRASS )
			{
				Sound.DIG.play( 0.5 );
				data[x][y] = new Tile( x, y, altitude, Tile.DIRT );
			}
			
			fill();
		}
		
		public function plant( x:int, y:int, ground:IsoMap, seed:Seed ):void
		{
			if ( data_type != CROP
			  || ground.data_type != TERRAIN )
				return;
			
			if ( at( x, y ).type != Tile.NONE )
				return;
			
			var t:int = seed.plantOn( ground.at( x, y ) );
			if ( t != Tile.NONE )
			{
				Sound.DIG.play( 0.5 );
				cropCount++;
			}
			
			data[x][y] = new Tile( x, y, altitude, t );
			
			fill();
		}
		
		public function weed( x:int, y:int, ground:IsoMap, destructive:Boolean = false ):void
		{
			if ( data_type != CROP
			  || ground.data_type != TERRAIN )
				return
			
			if ( at( x, y ).type != Tile.NONE )
				if ( destructive )
					cropCount--;
				else
					return;
			
			
			data[x][y] = new Tile( x, y, altitude, Tile.WEED );				
			fill();
		}
		
		public function deweed( x:int, y:int ):void
		{
			if ( data_type != CROP )
				return
			
			if ( at( x, y ).type != Tile.WEED )
				return;
			
			var frame:int = (data[x][y].img as Spritemap).frame;
			if ( frame == 5 )
			{
				if ( Math.random() < 0.4 )
				{
					Sound.DESTROY.play( 0.6 );
					Main.quake.start( 0.2, 0.1 );
					data[x][y] = new Tile( x, y, altitude, Tile.NONE );
				} else
				{
					Sound.HIT.play( 0.6 );
					Main.quake.start( 0.1, 0.1 );
					return;
				}
			} else
			{
				var frameNew:int = frame - 1;
				if ( frameNew >= 0 )
				{
					Sound.HIT.play( 0.6 );
					Main.quake.start( 0.1, 0.1 );
					(data[x][y].img as Spritemap).play( "grow", true, frameNew );
				} else
				{
					Sound.DESTROY.play( 0.6 );
					Main.quake.start( 0.2, 0.1 );
					data[x][y] = new Tile( x, y, altitude, Tile.NONE );
				}
			}
			
			fill();
		}
		
		public function harvest( x:int, y:int, ground:IsoMap ):void
		{
			if ( data_type != CROP
			  || at( x, y ).type == Tile.NONE )
				return
			
			if ( Math.floor( (at( x, y ).img as Spritemap).frame % 5 ) >= 4 )
			{
				Main.quake.start( 0.2, 0.1 );
				Sound.HARVEST.play( 0.6 );
				Sound.DESTROY.play( 0.6 );
				cropCount--;
				
				var type:int = at( x, y ).type;
				(FP.world as LevelWorld).score += ( type + 1 - Tile.WHEAT ) * 10;
				
				data[x][y] = new Tile( x, y, 1, Tile.NONE );
				ground.data[x][y] = new Tile( x, y, 0, Tile.DIRT );
				
				var p:Point;
				switch ( type )
				{
				case Tile.WHEAT:
					p = project( x, y );
					new Seed( p.x, p.y, Seed.WHEAT, false );
					
					if ( Math.random() > 0.5 )
						new Seed( p.x + 10, p.y, Seed.random(), false );
					break;
				
				case Tile.RASPBERRY:
					if ( Math.random() > 0.5 )
					{
						p = project( x, y );
						new Seed( p.x, p.y, Seed.WHEAT, false );
					}
					break;
				
				case Tile.CARROT:
					if ( Math.random() > 0.3 )
					{
						p = project( x, y );
						new Seed( p.x, p.y, Seed.WHEAT, false );
					}
					break;
				}
				
				fill();
				ground.fill();
			}
		}
		
		public function findCrop():Boolean
		{
			return cropCount > 0;
		}
		
		override public function update():void
		{
			x = offset_x;
			y = offset_y;
			
			var i:int, j:int;
			
			switch ( data_type )
			{
			case CROP:
			case TERRAIN:
				i = updating.x;
				j = updating.y;
				
				updating.y++;
				if ( updating.y >= data_width )
				{
					updating.x++;
					updating.y = 0;
					
					if ( updating.x >= data_depth )
						updating.x = 0;
				}
				
				if ( data[i] != null
				  && data[i][j] != null )
				{
					data[i][j].update();
				}
				break;
				
			case GRID:
				for ( i = 0; i < data_width; i++ )
				for ( j = 0; j < data_depth; j++ )
					if ( data[i][j] != null
					  && data[i][j].type != Tile.NONE )
					{
						data[i][j].update();
					}
				break;
			}
			
			super.update();
		}
	}
}
