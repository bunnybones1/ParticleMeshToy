package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Polygon 
	{
		private var triangles:Vector.<Triangle>;
		private var boundingBox:BoundingBox;
		
		public function Polygon(triangle1:Triangle, triangle2:Triangle) 
		{
			triangles = new Vector.<Triangle>;
			triangles.push(triangle1, triangle2);
			boundingBox = new BoundingBox();
		}
		
		public function updateBoundingBox():void 
		{
			boundingBox.copyFrom(triangles[0].boundingBox);
			for (var i:int = 1; i < triangles.length; ++i) {
				boundingBox.union(triangles[i].boundingBox);
			}
		}
		
	}

}