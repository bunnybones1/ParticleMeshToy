package com.bunnybones.particleMeshToy.geom 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class MathUtils 
	{
		
		public function MathUtils() 
		{
			
		}
		
		private static function sign(v1:Vertex, v2:Vertex, v3:Vertex):Number
		{
		  return (v1.x - v3.x) * (v2.y - v3.y) - (v2.x - v3.x) * (v1.y - v3.y);
		}

		public static function pointInTriangle(p:Vertex, triangle:Triangle):Boolean
		{
			var b1:Boolean = sign(p, triangle.vertices[0], triangle.vertices[1]) < 0;
			var b2:Boolean = sign(p, triangle.vertices[1], triangle.vertices[2]) < 0;
			var b3:Boolean = sign(p, triangle.vertices[2], triangle.vertices[0]) < 0;
			
			return ((b1 == b2) && (b2 == b3));
		}
	}

}