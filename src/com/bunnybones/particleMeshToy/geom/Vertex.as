package com.bunnybones.particleMeshToy.geom 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Vertex 
	{
		private var _x:Number;
		private var _y:Number;
		private var _edges:Vector.<Edge>;
		private var _destroyer:Signal = new Signal(Vertex);
		private var _updater:Signal = new Signal(Vertex);
		
		public function Vertex(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
			_edges = new Vector.<Edge>;
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
		
		public function setXY(x:Number, y:Number):void
		{
			_x = x;
			_y = y;
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
			_edges.push(edge);
		}
		
		public function clone():Vertex 
		{
			return new Vertex(x, y);
		}
		
		public function scale(scaleX:Number, scaleY:Number):Vertex
		{
			x *= scaleX;
			y *= scaleY;
			return this;
		}
		
		public function offset(offsetX:Number, offsetY:Number):Vertex
		{
			x += offsetX;
			y += offsetY;
			return this;
		}
	}

}