package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Triangle 
	{
		private var vertices:Vector<Vertex>;
		private var edges:Vector.<Edge>;
		private var polygon:Polygon;
		public var boundingBox:BoundingBox;
		public function Triangle(edge:Edge, vertex:Vertex) 
		{
			vertices = new Vector.<Vertex>;
			edges = new Vector.<Edge>;
			boundingBox = new BoundingBox();
			updateBoundingBox();
		}
		
		public function updateBoundingBox():void 
		{
			boundingBox = edges[0].boundingBox.union(edges[1].boundingBox).union(edges[2].boundingBox);
			polygon.updateBoundingBox();
		}
		
	}

}