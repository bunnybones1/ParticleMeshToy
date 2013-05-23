package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Polygon 
	{
		private var _triangles:Vector.<Triangle>;
		private var boundingBox:BoundingBox;
		
		public function Polygon(triangle1:Triangle, triangle2:Triangle) 
		{
			_triangles = new Vector.<Triangle>;
			_triangles.push(triangle1, triangle2);
			boundingBox = new BoundingBox();
		}
		
		public function updateBoundingBox():void 
		{
			boundingBox.copyFrom(_triangles[0].boundingBox);
			for (var i:int = 1; i < _triangles.length; ++i) {
				boundingBox.union(_triangles[i].boundingBox);
			}
		}
		
		public function insertVertex(vertex:Vertex):void 
		{
			var containers:Vector.<Triangle> = new Vector.<Triangle>;
			for each(var triangle:Triangle in _triangles) {
				if (triangle.containsVertex(vertex)) {
					containers.push(containers);
				}
			}
			
			switch(containers.length) {
				case 1:
					containers[0].insertVertex(vertex);
					break;
				case 0:
					trace("No triangles contain this vertex");
					break;
				default:
					throw new Error("vertex is contained by multiple triangles. You have overlapping triangles, apparently.");
			}
		}
		
		public function get triangles():Vector.<Triangle> 
		{
			return _triangles;
		}
		
	}

}