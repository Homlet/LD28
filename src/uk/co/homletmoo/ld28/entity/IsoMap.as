package uk.co.homletmoo.ld28.entity 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class IsoMap extends Entity
	{
		public var data:Array;
		public var data_width:int, data_depth:int;
		public var tile_width:int, tile_height:int;
		
		public function IsoMap( width:int, depth:int ) 
		{
			this.data_width = width;
			this.data_depth = depth;
			
			data = new Array();
			for ( var i:int = 0; i < data_width; i++ )
			{
				data[i] = new Array();
				for ( var j:int = 0; j < data_depth; j++ )
				{
					data[i][j] = Tile.TILE_GRASS;
					
					var x:int = i * Tile.HW - j * Tile.HW;
					var y:int = i * Tile.HH + j * Tile.HH;
					addGraphic( Tile.img( data[i][j], x, y ) );
				}
			}
			
			FP.world.add( this );
		}
	}
}
