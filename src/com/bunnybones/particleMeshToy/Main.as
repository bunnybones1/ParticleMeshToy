package com.bunnybones.particleMeshToy
{
	import com.bunnybones.particleMeshToy.geom.ParticleMesh;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			var particleMesh:ParticleMesh = new ParticleMesh();
			particleMesh.addRandomVertices(120*80 * .1);
			particleMesh.retriangulate();
			particleMesh.retriangulate();
			particleMesh.retriangulate();
			particleMesh.retriangulate();
			particleMesh.retriangulate();
			var viewMatrix:Matrix = new Matrix();
			viewMatrix.translate(1, 1);
			viewMatrix.scale(400, 400);
			viewMatrix.translate(50, 50);
			particleMesh.draw(this, viewMatrix);
		}
		
	}
	
}