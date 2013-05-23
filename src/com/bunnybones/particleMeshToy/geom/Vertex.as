package com.bunnybones.particleMeshToy.geom 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Vertex 
	{
		private var _x:Number;
		private var _y:Number;
		private var _edges:Vector.<Edge>;
		
		public function Vertex(x:Number, y:Number) 
		{
			this.x = x;
			this.y = y;
			_edges = new Vector.<Edge>;
		}
		
		public function get edges():Vector.<Edge> 
		{
			return _edges;
		}
		
		public function get x():Number 
		{
			return _x;
		}
		
		public function set x(value:Number):void 
		{
			_x = value;
			updateBoundingBox();
		}
		
		private function updateBoundingBox():void 
		{
			for each(var edge:Edge in _edges) edge.updateBoundingBox();
		}
		
		public function get y():Number 
		{
			return _y;
		}
		
		public function set y(value:Number):void 
		{
			_y = value;
			updateBoundingBox();
		}
		
	}

}