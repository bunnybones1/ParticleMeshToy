package com.bunnybones.particleMeshToy.geom 
{
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Triangle 
	{
		public var status:String;
		static public const STATUS_GOOD:String = "statusGood";
		static public const STATUS_DEAD:String = "statusDead";
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
			status = STATUS_GOOD;
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
			
			status = STATUS_DEAD;
		}
		
		public function vertexOppositeEdge(edge:Edge):Vertex
		{
			for each(var vertex:Vertex in _vertices) {
				if (edge.vertex1 != vertex && edge.vertex2 != vertex) return vertex;
			}
			return null;
		}
		
		public function generateColor():uint 
		{
			var a:Vertex = _vertices[0];
			var b:Vertex = _vertices[1];
			var c:Vertex = _vertices[2];
			return 0xffffff * ((a.id * b.id * c.id * .000001) % 1);
			//return 0xffffff * (Math.sin(a.x +b.x + c.x + a.y + b.y + c.y) * .5 + .5);
			//return Math.random() * 0xffffff;
		}
		
		public function generateAlpha():Number 
		{
			return 1;
			//return 1-Math.pow(1-Math.min(1, .0001/generateArea()), 6);
		}
		
		public function relax():void 
		{
			for each(var edge:Edge in _edges) {
				edge.relax(averageEdgeLength);
			}
		}
		
		public function serialize(bytes:ByteArray):ByteArray
		{
			//3 floats (x, y, radius)
			//position
			getCenter().serialize(bytes);
			//radius
			bytes.writeFloat(averageEdgeLength);
			return bytes;
		}
		
		private function getCenter():Vertex
		{
			return _vertices[0].clone().add(_vertices[1]).add(_vertices[2]).scale(MathUtils.A_THIRD, MathUtils.A_THIRD);
		}
		
		private function generateArea():Number
		{
			var a:Vertex = _vertices[0];
			var b:Vertex = _vertices[1];
			var c:Vertex = _vertices[2];
			return Math.abs((a.x - c.x) * (b.y - a.y) - (a.x - b.x) * (c.y - a.y)) * .5;
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
		
		public function get averageEdgeLength():Number 
		{
			return (_edges[0].length + _edges[1].length + _edges[2].length) / 3;
		}
		
	}

}