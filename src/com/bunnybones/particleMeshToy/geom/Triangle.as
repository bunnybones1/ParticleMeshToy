package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Triangle 
	{
		private var _vertices:Vector.<Vertex>;
		private var _edges:Vector.<Edge>;
		//private var polygon:Polygon;
		public var boundingBox:BoundingBox;
		public function Triangle(edge:Edge, vertex:Vertex) 
		{
			_vertices = new Vector.<Vertex>;
			_edges = new Vector.<Edge>;
			_vertices.push(edge.vertex1, edge.vertex2, vertex);
			_edges.push(edge, new Edge(edge.vertex1, vertex), new Edge(edge.vertex2, vertex));
			boundingBox = new BoundingBox();
			updateBoundingBox();
		}
		
		public function updateBoundingBox():void 
		{
			boundingBox.copyFrom(_edges[0].boundingBox).union(_edges[1].boundingBox).union(_edges[2].boundingBox);
			//polygon.updateBoundingBox();
		}
		
		public function insertVertex(vertex:Vertex):void 
		{
			//disassemble the current triangle
			//replace it with 3 triangles that reuse the old outer edges
			//check the triangles adjacent to the outer border of the old triangle and retriangulate if necessary
		}
		
		public function containsVertex(vertex:Vertex):Boolean 
		{
			//check if vertex contained within the triangle. Being exactly on the border does not count.
			return false;
		}
		
		public function get vertices():Vector.<Vertex> 
		{
			return _vertices;
		}
		
		public function get edges():Vector.<Edge> 
		{
			return _edges;
		}
		
	}

}