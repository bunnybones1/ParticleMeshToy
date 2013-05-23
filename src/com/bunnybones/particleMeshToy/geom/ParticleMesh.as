package com.bunnybones.particleMeshToy.geom 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ParticleMesh 
	{
		private var _polygons:Vector.<Polygon>;
		
		public function ParticleMesh() 
		{
			_polygons = new Vector.<Polygon>;
			newPolyFromCorners(	new Vertex( -1, -1),
								new Vertex(1, -1),
								new Vertex(-1, 1),
								new Vertex(1, 1));
		}
		
		public function newPolyFromCorners(vertex1:Vertex, vertex2:Vertex, vertex3:Vertex, vertex4:Vertex):void 
		{
			var polygon:Polygon = new Polygon(	new Triangle(	new Edge(vertex1, vertex2),
																vertex3),
												new Triangle(	new Edge(vertex3, vertex4),
																vertex2));
		}
		
	}

}