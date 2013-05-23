package com.bunnybones.particleMeshToy.geom 
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import com.bunnybones.particleMeshToy.Main;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ParticleMesh 
	{
		private var _polygons:Vector.<Polygon>;
		private var _vertices:Vector.<Vertex>;
		
		
		public function ParticleMesh() 
		{
			_polygons = new Vector.<Polygon>;
			_vertices = new Vector.<Vertex>;
			newPolyFromCorners(	new Vertex( -1, -1),
								new Vertex(1, -1),
								new Vertex(-1, 1),
								new Vertex(1, 1));
		}
		
		public function newPolyFromCorners(vertex1:Vertex, vertex2:Vertex, vertex3:Vertex, vertex4:Vertex):void 
		{
			_vertices.push(vertex1, vertex2, vertex3, vertex4);
			var polygon:Polygon = new Polygon(	new Triangle(	new Edge(vertex1, vertex2),
																vertex3),
												new Triangle(	new Edge(vertex3, vertex4),
																vertex2));
			_polygons.push(polygon);
		}
		
		public function draw(target:Sprite, viewMatrix:Matrix):void 
		{
			var v:Vertex;
			var p:Point;
			var g:Graphics = target.graphics;
			
			//triangles
			for each(var polygon:Polygon in _polygons) {
				for each(var triangle:Triangle in polygon.triangles) {
					v = triangle.vertices[0];
					p = viewMatrix.transformPoint(new Point(v.x, v.y));
					g.moveTo(p.x, p.y);
					g.beginFill(Math.random() * 0xffffff, .5);
					for (var i:int = 1; i < triangle.vertices.length; ++i) {
						v = triangle.vertices[i];
						p = viewMatrix.transformPoint(new Point(v.x, v.y));
						g.lineTo(p.x, p.y);
					}
					g.endFill();
				}
			}
			
			//vertices
			g.lineStyle(3, 0x0000ff, 1);
			for each(v in _vertices) {
				p = viewMatrix.transformPoint(new Point(v.x, v.y));
				g.moveTo(p.x, p.y);
				g.lineTo(p.x + 1, p.y);
			}
			g.lineStyle(0, 0, 0);
		}
		
		public function addRandomVertices(total:int):void 
		{
			_polygons[0].insertVertex(new Vertex(Math.random() * 2 - 1, Math.random() * 2 -1));
		}
		
	}

}