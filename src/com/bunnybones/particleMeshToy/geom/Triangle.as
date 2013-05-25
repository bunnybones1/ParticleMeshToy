package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Triangle 
	{
		private var _vertices:Vector.<Vertex>;
		private var _edges:Vector.<Edge>;
		//private var polygon:Polygon;
		private var _boundingBox:BoundingBox;
		private var _destroyer:Signal = new Signal(Triangle);
		private var _updater:Signal = new Signal(Triangle);
		public function Triangle(edge:Edge, vertex:Vertex) 
		{
			_vertices = new Vector.<Vertex>;
			_edges = new Vector.<Edge>;
			_vertices.push(edge.vertex1, edge.vertex2, vertex);
			_edges.push(edge, edge.vertex1.connect(vertex), edge.vertex2.connect(vertex));
			for each(var edge:Edge in _edges) {
				edge.registerTriangle(this);
				edge.updater.add(onEdgeUpdated);
				edge.destroyer.add(onEdgeDestroyed);
			}
			_boundingBox = new BoundingBox();
			updateBoundingBox();
		}
		
		private function onEdgeDestroyed(edge:Edge):void 
		{
			destroy();
		}
		
		private function onEdgeUpdated(edge:Edge):void 
		{
			updateBoundingBox();
			_updater.dispatch(this);
		}
		
		public function updateBoundingBox():void 
		{
			_boundingBox.copyFrom(_edges[0].boundingBox).union(_edges[1].boundingBox).union(_edges[2].boundingBox);
		}
		
		public function destroy():void 
		{
			_destroyer.dispatch(this);
			_destroyer.removeAll();
			_updater.removeAll();
			_destroyer = null;
			_updater = null;
			
			var i:int;
			for (i = 0; i < _edges.length; ++i) {
				_edges[i].updater.remove(onEdgeUpdated);
				_edges[i].destroyer.remove(onEdgeDestroyed);
				_edges[i] = null;
			}
			for (i = 0; i < _vertices.length; ++i) {
				_vertices[i] = null;
			}
			
			_boundingBox = null;
		}
		
		public function vertexOppositeEdge(edge:Edge):Vertex
		{
			for each(var vertex:Vertex in _vertices) {
				if (edge.vertex1 != vertex && edge.vertex2 != vertex) return vertex;
			}
			return null;
		}
		
		public function get vertices():Vector.<Vertex> 
		{
			return _vertices;
		}
		
		public function get edges():Vector.<Edge> 
		{
			return _edges;
		}
		
		public function get boundingBox():BoundingBox 
		{
			return _boundingBox;
		}
		
		public function get destroyer():Signal 
		{
			return _destroyer;
		}
		
		public function get updater():Signal 
		{
			return _updater;
		}
		
	}

}