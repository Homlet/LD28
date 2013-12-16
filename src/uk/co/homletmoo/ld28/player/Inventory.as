package uk.co.homletmoo.ld28.player 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.tweens.misc.MultiVarTween;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	import uk.co.homletmoo.ld28.player.Seed;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class Inventory extends Entity
	{
		public static const SIZE:int = 10;
		
		
		public var seeds:Array;
		public var seedsLenOld:int = 0;
		
		public var slider:Image;
		public var frame:Image;
		
		public var tween:MultiVarTween;
		
		public function Inventory() 
		{
			super();
			
			seeds = new Array();
			
			slider = new Image( Assets.INV_SLIDER );
			slider.scale = Display.SCALE;
			var notches:int = Math.max( 1, seeds.length );
			slider.x = -slider.scaledWidth + 11 * Display.SCALE * notches + 3 * Display.SCALE;
			graphic = slider;
			
			frame = new Image( Assets.INV_FRAME );
			frame.scale = Display.SCALE;
			FP.world.addGraphic( frame, -400 );
			
			layer = -100;
			
			FP.world.add( this );
		}
		
		public function full():Boolean
		{
			return seeds.length >= 10;
		}
		
		override public function update():void
		{
			if ( seeds.length != seedsLenOld )
			{
				var notches:int = Math.max( 1, seeds.length );
				tween = FP.tween( slider, { x: -slider.scaledWidth + 11 * Display.SCALE * notches + 3 * Display.SCALE }, 0.25 );
				
				for ( var i:int = 0; i < seeds.length; i++ )
					FP.tween(
						seeds[i],
						{
							x: 11 * Display.SCALE * ( seeds.length - i - 1 ) + 2 * Display.SCALE,
							y:  2 * Display.SCALE
						},
						0.25
					);
			}
			
			seedsLenOld = seeds.length;
			
			super.update();
		}
	}
}
