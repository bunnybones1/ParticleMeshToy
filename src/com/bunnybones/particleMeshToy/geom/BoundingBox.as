package com.bunnybones.particleMeshToy.geom 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class BoundingBox 
	{
		public var xMin:Number = 0;
		public var xMax:Number = 0;
		public var yMin:Number = 0;
		public var yMax:Number = 0;
		
		public function BoundingBox() 
		{
		}
		
		public function setFromTwoVertices(vertex1:Vertex, vertex2:Vertex):void 
		{
			if (vertex1.x < vertex2.x) {
				xMin = vertex1.x;
				xMax = vertex2.x;
			} else {
				xMin = vertex2.x;
				xMax = vertex1.x;
			}
			if (vertex1.y < vertex2.y) {
				yMin = vertex1.y;
				yMax = vertex2.y;
			} else {
				yMin = vertex2.y;
				yMax = vertex1.y;
			}
		}
		
		public function copyFrom(boundingBox:BoundingBox):BoundingBox 
		{
			xMin = boundingBox.xMin;
			xMax = boundingBox.xMax;
			yMin = boundingBox.yMin;
			yMax = boundingBox.yMax;
			return this;
		}
		
		public function union(boundingBox:BoundingBox):BoundingBox 
		{
			xMin = Math.min(xMin, boundingBox.xMin);
			xMax = Math.max(xMax, boundingBox.xMax);
			yMin = Math.min(yMin, boundingBox.yMin);
			yMax = Math.max(yMax, boundingBox.yMax);
			return this;
		}
		
		public function contains(p:Vertex):Boolean 
		{
			if (xMin < p.x && p.x <= xMax) {
				if (yMin < p.y && p.y <= yMax) return true;
				else return false;
			} else {
				return false;
			}
		}
		
		public function randomVertex():Vertex
		{
			return new Vertex(xMin + Math.random() * (xMax - xMin), yMin + Math.random() * (yMax - yMin));
		}
		
	}

}