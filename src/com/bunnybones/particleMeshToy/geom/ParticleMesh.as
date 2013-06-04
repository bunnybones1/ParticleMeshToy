package com.bunnybones.particleMeshToy.geom 
{
	import com.bunnybones.particleMeshToy.Settings;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import com.bunnybones.particleMeshToy.Main;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ParticleMesh 
	{
		private var _distributionMap:BitmapData;
		private var _polygons:Vector.<Polygon>;
		private var _distributionIndex:Vector.<Vector.<Vertex>>;
		private var _distributionIndexLinear:Vector.<Vector.<Vertex>>;
		private var fudgeBox:BoundingBox = new BoundingBox();
		private var moireData:BitmapData;
		
		public function ParticleMesh() 
		{
			_polygons = new Vector.<Polygon>;
			newPolyFromCorners(	new Vertex( -1, -1, 0),
								new Vertex(1, -1, 0),
								new Vertex(-1, 1, 0),
								new Vertex(1, 1, 0));
			moireData = new BitmapData(2, 2, false, 0xffffff);
			moireData.setPixel(0, 0, 0);
			moireData.setPixel(1, 1, 0);
		}
		
		public function newPolyFromCorners(vertex1:Vertex, vertex2:Vertex, vertex3:Vertex, vertex4:Vertex):void 
		{
			var polygon:Polygon = new Polygon(vertex1, vertex2, vertex3, vertex4);
			_polygons.push(polygon);
		}
		
		public function draw(target:Sprite, viewMatrix:Matrix):void 
		{
			var vertex:Vertex;
			var p:Point;
			var g:Graphics = target.graphics;
			
			g.clear();
			g.beginBitmapFill(moireData);
			g.drawRect(0, 0, target.stage.stageWidth, target.stage.stageHeight);
			//triangles
			switch(Settings.meshType) {
				case Settings.TYPE_MESH:
					for each(var polygon:Polygon in _polygons) {
						for each(var triangle:Triangle in polygon.triangles) {
							vertex = triangle.vertices[0];
							p = viewMatrix.transformPoint(new Point(vertex.x, vertex.y));
							g.moveTo(p.x, p.y);
							g.beginFill(triangle.generateColor(), triangle.generateAlpha());
							for (var i:int = 1; i < triangle.vertices.length; ++i) {
								vertex = triangle.vertices[i];
								p = viewMatrix.transformPoint(new Point(vertex.x, vertex.y));
								g.lineTo(p.x, p.y);
							}
							g.endFill();
						}
					}
					break;
				default:
					switch(Settings.meshType) {
						case Settings.TYPE_PARTICLES_FROM_FACES_AND_VERTICES:
						case Settings.TYPE_PARTICLES_FROM_VERTICES:
							//vertices from vertices
							var verticesAlreadyRendered:Vector.<Vertex> = new Vector.<Vertex>;
							for each(var polygon:Polygon in _polygons) {
								for each(var triangle:Triangle in polygon.triangles) {
									for each(vertex in triangle.vertices) {
										var vertexSize:Number = vertex.getAverageEdgeLength() * .5 * Settings.particleScale;
										if(Settings.filterByParticleSizeLow <= vertexSize && vertexSize <= Settings.filterByParticleSizeHigh) {
											if (verticesAlreadyRendered.indexOf(vertex) == -1) {
												verticesAlreadyRendered.push(vertex);
												g.beginFill(0x0000ff, .5);
												p = viewMatrix.transformPoint(new Point(vertex.x, vertex.y));
												g.drawCircle(p.x, p.y, viewMatrix.a * vertexSize);
												g.endFill();
											}
										}
									}
								}
							}
							break;
					}
					switch(Settings.meshType) {
						case Settings.TYPE_PARTICLES_FROM_FACES_AND_VERTICES:
						case Settings.TYPE_PARTICLES_FROM_FACES:
							//vertices from traingles
							for each(var polygon:Polygon in _polygons) {
								for each(var triangle:Triangle in polygon.triangles) {
									var faceCenter:Vertex = triangle.getCenter();
									var faceSize:Number = Math.sqrt(triangle.getSurfaceArea() / Math.PI) * Settings.particleScale;
									if(Settings.filterByParticleSizeLow <= faceSize && faceSize <= Settings.filterByParticleSizeHigh) {
										g.beginFill(0x0000ff, .5);
										p = viewMatrix.transformPoint(new Point(faceCenter.x, faceCenter.y));
										g.drawCircle(p.x, p.y, viewMatrix.a * faceSize);
										g.endFill();
									}
								}
							}
							break;
					}
			}
		}
		
		public function addRandomVertices(total:int):void 
		{
			for (var i:int = 0; i < total; i++) 
			{
				if (_distributionMap) {
					_polygons[0].insertVertex(sampleDistributionMap().add(fudgeBox.randomVertex()).scale(2, 2).offset(-1,-1));
				} else {
					_polygons[0].insertVertex(new Vertex(Math.random() * 2 - 1, Math.random() * 2 -1));
				}
			}
		}
		
		private function sampleDistributionMap():Vertex
		{
			var vertex:Vertex;
			while(!vertex) {
				//var valueIndex:int = int((1 - Math.pow(Math.random(), 3)) * 256);
				var valueIndex:int = Math.random() * _distributionIndexLinear.length;
				//var vertices:Vector.<Vertex> = _distributionIndex[valueIndex];
				var vertices:Vector.<Vertex> = _distributionIndexLinear[valueIndex];
				if(vertices.length > 0) {
					vertex = vertices[int(Math.random() * vertices.length)];
				}
			}
			return vertex.clone();
		}
		
		public function retriangulate():void 
		{
			trace("retriangulating");
			for each(var polygon:Polygon in _polygons) {
				polygon.retriangulateAll();
			}
		}
		
		public function relax():void 
		{
			for each(var polygon:Polygon in _polygons) {
				polygon.relax();
			}
		}
		
		public function serialize(bytes:ByteArray):ByteArray
		{
			var header:String;
			switch(Settings.meshType) {
				case Settings.TYPE_PARTICLES_FROM_FACES_AND_VERTICES:
				case Settings.TYPE_PARTICLES_FROM_VERTICES:
				case Settings.TYPE_PARTICLES_FROM_FACES:
					header = "Particles.\n" +
					"Read uint for particleCount.\n" +
					"Then read uint for size of data block containing particle stream (float x, float y, float radius).\n" +
					"Then read particle data stream.";
					break;
				case Settings.TYPE_MESH:
					header = "Mesh.\n" +
					"Read uint for vertexCount.\n" +
					"Then read uint for size of data block containing vertex stream (float x, float y).\n" +
					"Then read vertex data stream.\n" +
					"Then read uint for size of data block containing index stream (uint i).\n" +
					"Then read index data stream."
					break;
			}
			var headerBytes:ByteArray = new ByteArray();
			headerBytes.endian = Settings.endian;
			headerBytes.writeUTF(header);
			bytes.writeBytes(headerBytes);
			var dataStreamBytes:ByteArray = new ByteArray();
			dataStreamBytes.endian = Settings.endian;
			switch(Settings.meshType) {
				case Settings.TYPE_PARTICLES_FROM_FACES_AND_VERTICES:
				case Settings.TYPE_PARTICLES_FROM_VERTICES:
				case Settings.TYPE_PARTICLES_FROM_FACES:
					for each(var polygon:Polygon in _polygons) {
						polygon.serializeParticles(dataStreamBytes);
					}
					var totalParticles:uint = dataStreamBytes.length / 12;
					trace(totalParticles);
					bytes.writeUnsignedInt(totalParticles);
					break;
				case Settings.TYPE_MESH:
					var vertices:Vector.<Vertex> = new Vector.<Vertex>;
					//TODO serialize each vertex
					var totalVertices:uint = vertices.length;
					var indices:Vector.<uint> = new Vector.<uint>;
					for each(var polygon:Polygon in _polygons) {
						for each(var vertex:Vertex in polygon.vertices) {
							if (vertices.indexOf(vertex) == -1) {
								vertices.push(vertex);
							}
						}
					}
					//serialize the indices
					var totalIndices:uint = 9999;
					break;
			}
			bytes.writeUnsignedInt(dataStreamBytes.length);
			trace(dataStreamBytes.length);
			bytes.writeBytes(dataStreamBytes);
			
			return bytes;
		}
		
		public function set distributionMap(mapData:BitmapData):void 
		{
			_distributionMap = mapData;
			_distributionIndex = new Vector.<Vector.<Vertex>>;
			var valueCounts:Vector.<int> = new Vector.<int>;
			for (var i:int = 0; i < 256; i++) {
				var valueIndex:Vector.<Vertex> = new Vector.<Vertex>;
				_distributionIndex.push(valueIndex);
				valueCounts[i] = 0;
			}
			var width:Number = _distributionMap.width;
			var height:Number = _distributionMap.height;
			for (var iy:int = 0; iy < height; ++iy) {
				for (var ix:int = 0; ix < width; ++ix) {
					var value:uint = (mapData.getPixel(ix, iy) >> 16 ) & 0xFF;
					_distributionIndex[value].push(new Vertex(ix / width, iy / height));
					valueCounts[value]++;
				}
			}
			
			_distributionIndexLinear = new Vector.<Vector.<Vertex>>;
			for (var j:int = 255; j >= 0; --j) {
				for (var k:int = 0; k < j; ++k) {
					for (var ivc:int = 0; ivc < valueCounts[j]; ++ivc) {
						_distributionIndexLinear.push(_distributionIndex[j]);
					}
				}
			}
			var fudgeVert:Vertex = new Vertex(1 / _distributionMap.width, 1 / _distributionMap.height).scale(.5, .5);
			fudgeBox.setFromTwoVertices(fudgeVert, fudgeVert.clone().invert());
		}
		
	}

}