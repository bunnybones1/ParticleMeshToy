package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Polygon 
	{
		private var _vertices:Vector.<Vertex>;
		private var _triangles:Vector.<Triangle>;
		private var boundingBox:BoundingBox;
		
		public function Polygon(vertex1:Vertex, vertex2:Vertex, vertex3:Vertex, vertex4:Vertex) 
		{
			_vertices = new Vector.<Vertex>;
			_vertices.push(vertex1, vertex2, vertex3, vertex4);
			for each(var vertex:Vertex in _vertices) {
				vertex.destroyer.add(onVertexDestroyed);
			}
			
			_triangles = new Vector.<Triangle>;
			_triangles.push(	new Triangle(	new Edge(vertex1, vertex2), vertex3),
								new Triangle(	new Edge(vertex3, vertex4), vertex2));
			for each(var triangle:Triangle in _triangles) {
				triangle.destroyer.add(onTriangleDestroyed);
			}
			boundingBox = new BoundingBox();
			updateBoundingBox();
		}
		
		private function onVertexDestroyed(vertex:Vertex):void 
		{
			_vertices.splice(_vertices.indexOf(vertex), 1);
		}
		
		private function onTriangleDestroyed(triangle:Triangle):void 
		{
			_triangles.splice(_triangles.indexOf(triangle), 1);
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
			_vertices.push(vertex);
			vertex.destroyer.add(onVertexDestroyed);
			var containers:Vector.<Triangle> = new Vector.<Triangle>;
			for each(var triangle:Triangle in _triangles) {
				if (MathUtils.pointInTriangle(vertex, triangle)) {
					containers.push(triangle);
				}
			}
			
			switch(containers.length) {
				case 1:
					subdivideTriangle(containers[0], vertex);
					break;
				case 0:
					trace("No triangles contain this vertex");
					break;
				default:
					throw new Error("vertex is contained by multiple triangles. You have overlapping triangles, apparently.");
			}
		}
		
		private function subdivideTriangle(triangle:Triangle, vertex:Vertex):void 
		{
			//replace it with 3 triangles that reuse the old outer edges
			for each(var edge:Edge in triangle.edges) {
				var newTriangle:Triangle = new Triangle(edge, vertex);
				newTriangle.destroyer.add(onTriangleDestroyed);
				_triangles.push(newTriangle);
			}
			//check the triangles adjacent to the outer border of the old triangle and retriangulate if necessary
			
			//destroy the old triangle
			triangle.destroy();
		}
		
		public function get triangles():Vector.<Triangle> 
		{
			return _triangles;
		}
		
		public function get vertices():Vector.<Vertex> 
		{
			return _vertices;
		}
		
	}

}