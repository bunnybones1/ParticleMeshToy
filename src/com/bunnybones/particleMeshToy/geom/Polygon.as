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
					//throw new Error("vertex is contained by multiple triangles. You have overlapping triangles, apparently.");
			}
		}
		
		public function retriangulateAll():void 
		{
			var oldTriangles:Vector.<Triangle> = _triangles.slice(0, _triangles.length);
			for (var i:int = 0; i < oldTriangles.length ; i++) {
				var triangle:Triangle = oldTriangles[i];
				if (triangle.status == Triangle.STATUS_GOOD) {
					for each (var edge:Edge in triangle.edges) {
						retriangulate(edge);
					}
				}
			}
		}
		
		public function relax():void 
		{
			for each(var triangle:Triangle in _triangles) {
				triangle.relax();
			}
		}
		
		private function subdivideTriangle(triangle:Triangle, vertex:Vertex):void 
		{
			var edge:Edge;
			//replace it with 3 triangles that reuse the old outer edges
			for each(edge in triangle.edges) {
				var newTriangle:Triangle = new Triangle(edge, vertex);
				newTriangle.destroyer.add(onTriangleDestroyed);
				_triangles.push(newTriangle);
			}
			
			//save the old edges
			var oldEdges:Vector.<Edge> = triangle.edges.slice(0, 3);
			//destroy the old triangle
			triangle.destroy();
			
			//check the triangles adjacent to the outer border of the old triangle and retriangulate if necessary
			for each(edge in oldEdges) {
				retriangulate(edge);
			}
		}
		
		private function retriangulate(edge:Edge):void 
		{
			if (!edge) return;
			if (!edge.hasTwoTriangles) return;
			var newEdge:Edge = new Edge(edge.triangles[0].vertexOppositeEdge(edge), edge.triangles[1].vertexOppositeEdge(edge));
			if (newEdge.length < edge.length) {
				//check for concave polygons
				var oldVertex1:Vertex = edge.vertex1;
				var oldVertex2:Vertex = edge.vertex2;
				if (MathUtils.edgeIsFlanked(newEdge, oldVertex1, oldVertex2)) {
					edge.destroy();
					var triangle1:Triangle = new Triangle(newEdge, oldVertex1);
					var triangle2:Triangle = new Triangle(newEdge, oldVertex2);
					triangle1.destroyer.add(onTriangleDestroyed);
					triangle2.destroyer.add(onTriangleDestroyed);
					_triangles.push(triangle1, triangle2);
				} else {
					//trace("New edge was not flanked, so not retriangulated.");
				}
			}
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