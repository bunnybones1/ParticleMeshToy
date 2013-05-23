package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Edge 
	{
		public var vertex1:Vertex;
		public var vertex2:Vertex;
		private var triangles:Vector.<Triangle>;
		public var boundingBox:BoundingBox;
		
		public function Edge(vertex1:Vertex, vertex2:Vertex) 
		{
			this.vertex1 = vertex1;
			this.vertex2 = vertex2;
			triangles = new Vector.<Triangle>;
			boundingBox = new BoundingBox();
			updateBoundingBox();
		}
		
		public function updateBoundingBox():void 
		{
			boundingBox.setFromTwoVertices(vertex1, vertex2);
			for each(var triangle:Triangle in triangles) triangle.updateBoundingBox();
		}
		
	}

}