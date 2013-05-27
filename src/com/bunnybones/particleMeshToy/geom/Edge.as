package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Edge 
	{
		private var _vertex1:Vertex;
		private var _vertex2:Vertex;
		private var _boundingBox:BoundingBox;
		private var _destroyer:Signal = new Signal(Edge);
		private var _updater:Signal = new Signal(Edge);
		private var _triangles:Vector.<Triangle>;
		
		public function Edge(vertex1:Vertex, vertex2:Vertex) 
		{
			this._vertex1 = vertex1;
			this._vertex2 = vertex2;
			_triangles = new Vector.<Triangle>;
			_vertex1.registerEdge(this);
			_vertex2.registerEdge(this);
			vertex1.updater.add(onVertexUpdated);
			vertex2.updater.add(onVertexUpdated);
			vertex1.destroyer.add(onVertexDestroyed);
			vertex2.destroyer.add(onVertexDestroyed);
			_boundingBox = new BoundingBox();
			updateBoundingBox();
		}
		
		private function onVertexUpdated(vertex:Vertex):void 
		{
			updateBoundingBox();
			_updater.dispatch();
		}
		
		private function onVertexDestroyed(vertex:Vertex):void 
		{
			destroy();
		}
		
		public function destroy():void 
		{
			_destroyer.dispatch(this);
			_updater.removeAll();
			_destroyer.removeAll();
			_destroyer = null;
			_updater = null;
			
			_vertex1 = null;
			_vertex2 = null;
			
			_boundingBox = null;
		}
		
		public function updateBoundingBox():void 
		{
			_boundingBox.setFromTwoVertices(_vertex1, _vertex2);
		}
		
		public function connects(vertex1:Vertex, vertex2:Vertex):Boolean
		{
			if (_vertex1 == vertex1 && _vertex2 == vertex2) return true;
			else if (_vertex1 == vertex2 && _vertex2 == vertex1) return true;
			return false;
		}
		
		public function registerTriangle(triangle:Triangle):void 
		{
			triangle.destroyer.add(onTriangleDestroyed);
			_triangles.push(triangle);
		}
		
		private function onTriangleDestroyed(triangle:Triangle):void 
		{
			_triangles.splice(_triangles.indexOf(triangle), 1);
		}
		
		public function get destroyer():Signal 
		{
			return _destroyer;
		}
		
		public function get updater():Signal 
		{
			return _updater;
		}
		
		public function get boundingBox():BoundingBox 
		{
			return _boundingBox;
		}
		
		public function get vertex2():Vertex 
		{
			return _vertex2;
		}
		
		public function get vertex1():Vertex 
		{
			return _vertex1;
		}
		
		public function get hasTwoTriangles():Boolean 
		{
			if (_triangles.length != 2) return false;
			if (_triangles[0].status == Triangle.STATUS_GOOD && _triangles[1].status == Triangle.STATUS_GOOD) return true;
			else return false;
		}
		
		public function get triangles():Vector.<Triangle> 
		{
			return _triangles;
		}
		
		public function get length():Number 
		{
			return Math.sqrt(Math.pow(vertex1.x - vertex2.x, 2) + Math.pow(vertex1.y - vertex2.y, 2));
		}
		
	}

}