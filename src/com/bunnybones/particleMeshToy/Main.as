package com.bunnybones.particleMeshToy
{
	import com.bunnybones.particleMeshToy.geom.ParticleMesh;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
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
		public function Main():void 
		{
			var distributionMap:Bitmap = new distributionImage();
			particleMesh = new ParticleMesh();
			particleMesh.distributionMap = distributionMap.bitmapData;
			particleMesh.addRandomVertices(120 * 80*.1);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			particleMesh.retriangulate();
			var viewMatrix:Matrix = new Matrix();
			viewMatrix.translate(1, 1);
			viewMatrix.scale(400, 400);
			viewMatrix.translate(50, 50);
			particleMesh.draw(this, viewMatrix);
		}
		
	}
	
}