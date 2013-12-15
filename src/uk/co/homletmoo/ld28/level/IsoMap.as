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
	import uk.co.homletmoo.ld28.player.Seed;
	
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
		
		public static var empty:Tile = new Tile( 0, 0, 0, null, Tile.NONE );
		
		public var data:Vector.<Vector.<Tile> >;
		public var data_width:int, data_depth:int, data_type:int;
		public var altitude:int;
		public var updating:Point;
		
		
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
						data[i][j] = new Tile( i, j, altitude, this, Tile.GRID );
						break;
						
					case TERRAIN:
						if ( Math.random() < 0.7 )
							data[i][j] = new Tile( i, j, altitude, this, Tile.GRASS );
						else
							data[i][j] = new Tile( i, j, altitude, this, Tile.DIRT );
						break;
						
					case CROP:
						data[i][j] = new Tile( i, j, altitude, this, Tile.NONE );
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
			
			if ( at( x, y ).type == Tile.DIRT )
			{
				var type:int = ( x + y ) % 2 == 0 ? Tile.TILLED_L : Tile.TILLED_R;
				data[x][y] = new Tile( x, y, altitude, this, type );
			}
			
			fill();
		}
		
		public function clear( x:int, y:int ):void
		{
			if ( data_type != TERRAIN )
				return;
			
			if ( at( x, y ).type == Tile.GRASS )
				data[x][y] = new Tile( x, y, altitude, this, Tile.DIRT );
			
			fill();
		}
		
		public function plant( x:int, y:int, ground:IsoMap, seed:Seed ):void
		{
			if ( data_type != CROP
			  || ground.data_type != TERRAIN )
				return;
			
			if ( at( x, y ).type != Tile.NONE )
				return;
			
			data[x][y] = new Tile( x, y, altitude, this, seed.plantOn( ground.at( x, y ) ) );
			
			fill();
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
				  && data[i][j] != null
				  && data[i][j].type != Tile.NONE )
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
