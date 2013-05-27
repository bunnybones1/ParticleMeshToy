package com.bunnybones.particleMeshToy
{
	import com.bunnybones.particleMeshToy.geom.ParticleMesh;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Main extends Sprite 
	{
		[Embed(source = "../../../../bin/distribution.png")]
		private static const distributionImage:Class;
		private var particleMesh:ParticleMesh;
		private var viewMatrix:Matrix;
		private var iterations:int = 0;
		public function Main():void 
		{
			viewMatrix = new Matrix();
			viewMatrix.translate(1, 1);
			viewMatrix.scale(400, 400);
			viewMatrix.translate(50, 50);
			
			var distributionMap:Bitmap = new distributionImage();
			
			particleMesh = new ParticleMesh();
			particleMesh.distributionMap = distributionMap.bitmapData;
			particleMesh.addRandomVertices(120 * 80 * .01);
			particleMesh.draw(this, viewMatrix);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode > 48 && e.keyCode < 58) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				iterations = e.keyCode - 48;
			}
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (iterations > 0) {
				trace("iterations left:", iterations);
				iterations--;
				particleMesh.retriangulate();
				particleMesh.relax();
				particleMesh.draw(this, viewMatrix);
			} else if (iterations == 0) {
				iterations--;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
	}
	
}