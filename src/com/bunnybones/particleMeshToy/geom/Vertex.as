package com.bunnybones.particleMeshToy.geom 
{
	import flash.utils.ByteArray;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Vertex 
	{
		static private var _ID:uint = 0;
		private var _x:Number;
		private var _y:Number;
		private var _z:Number;
		private var _edges:Vector.<Edge>;
		private var _destroyer:Signal = new Signal(Vertex);
		private var _updater:Signal = new Signal(Vertex);
		private var _weight:Number;
		private var _id:uint;
		
		public function Vertex(x:Number, y:Number, z:Number, weight:Number = 1) 
		{
			_x = x;
			_y = y;
			_z = z;
			_weight = weight;
			_edges = new Vector.<Edge>;
			_id = Vertex.ID;
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
			_updater.dispatch(this);
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
			_updater.dispatch(this);
		}
		
		public function get z():Number 
		{
			return _z;
		}
		
		public function set z(value:Number):void 
		{
			_z = value;
			_updater.dispatch(this);
		}
		
		public function destroy():void
		{
			_destroyer.dispatch(this);
			_destroyer.removeAll();
			_updater.removeAll();
			_destroyer = null;
			_updater = null;
		}
		
		public function get destroyer():Signal 
		{
			return _destroyer;
		}
		
		public function get updater():Signal 
		{
			return _updater;
		}
		
		public function get weight():Number 
		{
			return _weight;
		}
		
		static public function get ID():uint 
		{
			_ID++;
			return _ID;
		}
		
		public function get id():uint 
		{
			return _id;
		}
		
		public function setXYZ(x:Number, y:Number, z:Number):void
		{
			_x = x;
			_y = y;
			_z = z;
			_updater.dispatch(this);
		}
		
		public function connect(vertex:Vertex):Edge 
		{
			for each(var edge:Edge in _edges) {
				if (edge.connects(this, vertex)) {
					return edge;
				}
			}
			return new Edge(vertex, this);
		}
		
		public function registerEdge(edge:Edge):void 
		{
			edge.destroyer.add(onEdgeDestroyed);
			_edges.push(edge);
		}
		
		private function onEdgeDestroyed(edge:Edge):void 
		{
			_edges.splice(_edges.indexOf(edge), 1);
		}
		
		public function clone():Vertex 
		{
			return new Vertex(x, y, z);
		}
		
		public function scale(scaleX:Number, scaleY:Number, scaleZ:Number):Vertex
		{
			x *= scaleX;
			y *= scaleY;
			z *= scaleZ;
			return this;
		}
		
		public function offset(offsetX:Number, offsetY:Number, offsetZ:Number):Vertex
		{
			x += offsetX;
			y += offsetY;
			z += offsetZ;
			return this;
		}
		
		public function invert():Vertex
		{
			x = -x;
			y = -y;
			z = -z;
			return this;
		}
		
		public function add(vertex:Vertex):Vertex
		{
			this.x += vertex.x;
			this.y += vertex.y;
			this.z += vertex.z;
			return this;
		}
		
		public function subtract(vertex:Vertex):Vertex
		{
			this.x -= vertex.x;
			this.y -= vertex.y;
			this.z -= vertex.z;
			return this;
		}
		
		public function normalize(value:Number = 1):void 
		{
			var magnitude:Number = Math.sqrt(Math.pow(_x, 2) + Math.pow(_y, 2));
			x *= value / magnitude;
			y *= value / magnitude;
		}
		
		public function serializeParticles(bytes:ByteArray):ByteArray
		{
			bytes.writeFloat(_x);
			bytes.writeFloat(_y);
			bytes.writeFloat(_z);
			return bytes;
		}
		
		public function getAverageEdgeLength():Number
		{
			var length:Number = 0;
			for (var i:int = _edges.length - 1; i >= 0;--i) {
				var e:Edge = _edges[i];
				if(e.vertex1 != null) {
					length += e.length;
				} else {
					//hotfix: for some reason some edges are not being destroyed properly
					trace("hotfix");
					_edges.splice(i, 1);
				}
			}
			return length/_edges.length;
		}
		
		public function subtractVxy(vertex:Vertex):Vertex
		{
			this.x -= vertex.x;
			this.y -= vertex.y;
			return this;
		}
		
		public function addVxy(vertex:Vertex):Vertex
		{
			this.x += vertex.x;
			this.y += vertex.y;
			return this;
		}
	}

}