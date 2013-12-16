package uk.co.homletmoo.ld28.world 
{
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.World;
	import uk.co.homletmoo.ld28.Assets;
	import uk.co.homletmoo.ld28.Display;
	import uk.co.homletmoo.ld28.level.IsoMap;
	import uk.co.homletmoo.ld28.level.Tile;
	import uk.co.homletmoo.ld28.player.Seed;
	import uk.co.homletmoo.ld28.player.Player;
	import uk.co.homletmoo.ld28.Sound;
	
	/**
	 * ...
	 * @author Homletmoo
	 */
	public class LevelWorld extends World
	{
		public var sheen:Image;
		public var dirt_0:Image, dirt_1:Image, dirt_2:Image;
		
		public var grid:IsoMap;
		public var ground:IsoMap;
		public var crop:IsoMap;
		
		public var width:int, depth:int, edge:int;
		
		public var player:Player;
		
		public var time:Number = 0.0;
		public var tint:Image;
		public var sun:Image, moon:Image;
		
		public var failed:Boolean = false;
		
		public var score:int = 0;
		public var scoreText:Text;
		public var coinImg:Image;
		public var weedRate:Number = 0.01;
		
		
		override public function begin():void
		{
			Sound.START.play( 0.5 );
			Sound.INTRO.play();
			
			addGraphic( createSky(), 100 );
			addGraphic( createSun(), 80 );
			addGraphic( createMoon(), 80 );
			addGraphic( createSheen(), -10 );
			addGraphic( createFloatingDirt(), 80 );
			addGraphic( createScore(), -200 );
			
			width = depth = 9;
			edge = 5;
			grid   = new IsoMap( width, depth, edge, IsoMap.GRID    );
			ground = new IsoMap( width, depth, edge, IsoMap.TERRAIN );
			crop   = new IsoMap( width, depth, edge, IsoMap.CROP    );
			
			player = new Player( ground, crop );
			
			tint = Image.createRect( Display.W, Display.H, 0x000030, 0 );
			tint.blend = BlendMode.MULTIPLY;
			addGraphic( tint, -20 );
		}
		
		private function createScore():Graphiclist
		{
			scoreText = new Text( "= " + score, Display.W - 36 * Display.SCALE, 2 * Display.SCALE );
			scoreText.size = 8;
			scoreText.scale = Display.SCALE;
			
			coinImg = new Image( Assets.COIN );
			coinImg.scale = Display.SCALE;
			coinImg.x = Display.W - 39 * Display.SCALE - coinImg.scaledWidth;
			coinImg.y = 2 * Display.SCALE;
			
			return new Graphiclist( scoreText, coinImg );
		}
		
		private function updateScore():void
		{
			scoreText.text = "= " + score;
		}
		
		private function createSky():Image
		{
			var w:int = Display.W / Display.SCALE;
			var h:int = Display.H / Display.SCALE;
			
			var sprite:Sprite = new Sprite();
			var g:Graphics = sprite.graphics;
			
			var gradMatrix:Matrix = new Matrix();
			gradMatrix.createGradientBox( w, h, 90 * FP.RAD );
			g.beginGradientFill( GradientType.LINEAR, [0x45b3e0, 0xc9e9f6], [1, 1], [0, 255], gradMatrix );
			g.drawRect( 0, 0, w, h );
			g.endFill();
			
			var bit:BitmapData = new BitmapData( w, h, true, 0 );
			bit.draw( sprite );
			
			var sky:Image = new Image( bit );
			sky.scale = Display.SCALE;
			return sky;
		}
		
		private function createSun():Image
		{
			sun = new Image( Assets.SUN );
			sun.scale = Display.SCALE * 3;
			sun.centerOrigin();
			sun.originY += ( Display.HW * 1.5 ) / sun.scale;
			sun.x = Display.HW;
			sun.y = Display.HH + 60 * Display.SCALE;
			
			return sun;
		}
		
		private function createMoon():Image
		{
			moon = new Image( Assets.MOON );
			moon.scale = Display.SCALE * 1.5;
			moon.centerOrigin();
			moon.originY -= ( Display.HW * 1.5 ) / moon.scale;
			moon.x = Display.HW;
			moon.y = Display.HH + 60 * Display.SCALE;
			
			return moon;
		}
		
		private function createSheen():Image
		{
			sheen = new Image( Assets.SHEEN );
			sheen.scale = Display.SCALE;
			positionSheen( IsoMap.pick( Input.mouseX, Input.mouseY ) );
			
			return sheen;
		}
		
		private function positionSheen( p:Point ):void
		{
			sheen.visible = ( Math.abs( p.x - p.y ) <= edge );
			if ( p.x < 0      || p.y < 0      ) sheen.visible = false;
			if ( p.x >= width || p.y >= depth ) sheen.visible = false;
			
			sheen.x = p.x * Tile.HW - p.y * Tile.HW + IsoMap.offset_x;
			sheen.y = p.x * Tile.HH + p.y * Tile.HH + IsoMap.offset_y;
		}
		
		private function createFloatingDirt():Graphiclist
		{
			dirt_0 = new Image( Assets.DIRT_0 );
			dirt_1 = new Image( Assets.DIRT_1 );
			dirt_2 = new Image( Assets.DIRT_2 );
			positionFloatingDirt( dirt_0, 0 );
			positionFloatingDirt( dirt_1, 0 );
			positionFloatingDirt( dirt_2, 0 );
			
			return new Graphiclist( dirt_2, dirt_1, dirt_0 );
		}
		
		private function positionFloatingDirt( dirt:Image, offset:Number ):void
		{		
			dirt.scale = Display.SCALE * 1.5;
			dirt.x = Display.HW - dirt.scaledWidth / 2;
			dirt.y = Display.H  - 105 * Display.SCALE + offset;
		}
		
		private function fail():void
		{
			Sound.END.play( 0.5 );
			
			failed = true;
			tint.color = 0;
			player.inv.frame.visible = false;
			player.inv.slider.visible = false;
			coinImg.visible = false;
			scoreText.visible = false;
			FP.tween( tint, { alpha: 1 }, 1.0, { complete: nextScreen } );
		}
		
		private function nextScreen():void
		{
			FP.world = new EndWorld( score );
		}
		
		override public function update():void
		{
			var seeds:Array = new Array();
			getClass( Seed, seeds );
			if ( seeds.length == 0 && !crop.findCrop() && !failed )
				fail();
			
			if ( !failed )
			{
				var picked:Point = IsoMap.pick( Input.mouseX, Input.mouseY );
				positionSheen( picked );
				
				if ( weedRate < 0.1 )
					weedRate += FP.elapsed * 0.00001;
				
				if ( Input.mouseReleased
				  && picked.x >= 0     && picked.y >= 0
				  && picked.x <  width && picked.y <  depth
				  && Math.abs( picked.x - picked.y ) <= edge )
					player.move( picked );
				
				var offset:Number = 8.0 * Math.sin( time );
				positionFloatingDirt( dirt_0, offset * 3 );
				positionFloatingDirt( dirt_1, offset * 2 );
				positionFloatingDirt( dirt_2, offset );
				player.y = player.flatPos.y + offset;
				IsoMap.offset_y = IsoMap.BASE_OFFSET_Y + offset;
				
				tint.alpha = 0.25 - Math.cos( time ) * 0.4;
				sun.angle  = time * FP.DEG;
				moon.angle = time * FP.DEG;
				time += FP.elapsed;
			}
			
			super.update();
			
			updateScore();
		}
	}
}
