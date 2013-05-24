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
		
		public function Edge(vertex1:Vertex, vertex2:Vertex) 
		{
			this._vertex1 = vertex1;
			this._vertex2 = vertex2;
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
			_destroyer.dispatch();
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
		
	}

}