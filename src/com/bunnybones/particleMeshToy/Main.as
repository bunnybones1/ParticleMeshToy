package com.bunnybones.particleMeshToy
{
	import com.bunnybones.particleMeshToy.geom.ParticleMesh;
	import com.bunnybones.particleMeshToy.ui.Controls;
	import com.bunnybones.particleMeshToy.ui.ControlsEvent;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Main extends Sprite 
	{
		
		[Embed(source = "../../../../assets/leftMV.png")]
		private static const distributionImage:Class;
		[Embed(source = "../../../../assets/leftMask.png")]
		private static const heightImage:Class;
		[Embed(source = "../../../../assets/left.txt", mimeType="application/octet-stream")]
		private static const distributionUVTransform:Class;
		[Embed(source = "../../../../assets/meshTemplate.h", mimeType="application/octet-stream")]
		private static const meshTemplate:Class;
		[Embed(source = "../../../../assets/particleTemplate.h", mimeType="application/octet-stream")]
		private static const particleTemplate:Class;
		[Embed(source = "../../../../assets/motionVectorParticleTemplate.h", mimeType="application/octet-stream")]
		private static const motionVectorParticleTemplate:Class;
		[Embed(source = "../../../../assets/framesTemplate.h", mimeType="application/octet-stream")]
		private static const framesTemplate:Class;
		
		protected var particleMesh:ParticleMesh;
		private var viewMatrix:Matrix;
		private var iterations:int = 0;
		private var controls:Controls;
		private var canvas:Sprite;
		private var ready:Boolean;
		private var distributionMap:Bitmap;
		private var heightMap:Bitmap;
		protected var currentFrame:int = 0;
		protected var exportingFrames:Boolean = false;
		protected var baseFilePath:String;
		protected var baseFileName:String;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function init():void
		{
			Settings.uvPresetName = "left";
			//Settings.verticesTotalToInsert = 30;
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onResize);
			
			canvas = new Sprite();
			addChild(canvas);
			
			controls = new Controls();
			controls.addEventListener(Event.CHANGE, onControlsChange);
			controls.addEventListener(Event.SELECT, onControlsSelect);
			controls.addEventListener(ControlsEvent.RESET, onControlsReset);
			controls.addEventListener(ControlsEvent.GO, onControlsGo);
			
			addChild(controls);
			
			distributionMap = new distributionImage();
			heightMap = new heightImage();
			var uv:Matrix = matrixFromUVTransformTextFile(new distributionUVTransform());
			Settings.uvTransform = uv;
			var fixDisplaceUV:Matrix = new Matrix();
			switch(Settings.uvPresetName) {
				case "right":
					fixDisplaceUV.translate( -.5, -.5);
					//QUICKFIX?? not sure why commenting this out helps
					//fixDisplaceUV.rotate(Math.PI * -.5);
					//fixDisplaceUV.scale( 1, -2);
					//fixDisplaceUV.translate(0, -.5);
					fixDisplaceUV.translate(.5, .5);
				case "left":
					fixDisplaceUV.translate(-.5, -.5);
					fixDisplaceUV.rotate(Math.PI * -.5);
					fixDisplaceUV.scale( 1, -2);
					fixDisplaceUV.translate(0, .5);
					fixDisplaceUV.translate(.5, .5);
					break;
			}
			Settings.fixDisplaceUV = fixDisplaceUV;
			
			reset();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			ready = true;
		}
		
		private function onControlsGo(e:ControlsEvent):void 
		{
			if (exportingFrames) {
				trace("already going");
				return;
			}
			trace("go");
			exportingFrames = true;
			save();
			iterations = Settings.relaxIterations;
			Settings.interactiveMode = false;
		}
		
		protected function processFrames():void 
		{
			trace("processing " + Settings.totalFrames + " frames");
			var framesTemplate:String = new framesTemplate();
			var framesImportsString:String = "";
			var framesPointerStrings:String = "";
			for (var iFrame:int = 0; iFrame < Settings.totalFrames; iFrame++) {
				if (i != 0) framesPointerStrings += "\n";
				trace("processing frame:" + iFrame);
				currentFrame = iFrame;
				reset();
				for (var i:int = 0; i < Settings.relaxIterations; i++) {
					relaxIteration();
				}
				particleMesh.retriangulate();
				savePPM();
				framesImportsString += "#import \"" + baseFileName + currentFrame + ".h\"\n";
				framesPointerStrings += "\t&" + baseFileName.toLowerCase() + currentFrame + "GLBufferGroup,";
			}
			framesTemplate = StringUtils.replaceAllCases(framesTemplate, "template", baseFileName);
			framesTemplate = StringUtils.replaceAll(framesTemplate, "%%INCLUDE_HEADERS_LIST%%", framesImportsString);
			framesTemplate = StringUtils.replaceAll(framesTemplate, "%%FRAME_LIST%%", framesPointerStrings);
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Settings.endian;
			bytes.writeUTF(framesTemplate);
			saveCPPHeaderFrames(bytes);
			exportingFrames = false;
			Settings.interactiveMode = true;
		}
		
		private function onControlsReset(e:ControlsEvent):void 
		{
			reset();
		}
		
		private function matrixFromUVTransformTextFile(distributionUVTransformText:String):Matrix 
		{
			trace(distributionUVTransformText);
			var lines:Array = distributionUVTransformText.split(";");
			var matrix:Matrix = new Matrix();
			//go from -1,1 space to 0,1 space
			matrix.scale(.5, .5);
			matrix.translate(.5, .5);
			//
			for (var i:int = 0; i < lines.length; i++) {
				var operation:Array = String(lines[i]).split("=");
				if(operation.length == 2) {
					operation[0] = StringUtils.trimAway(operation[0], " ");
					operation[1] = StringUtils.trimAway(operation[1], " []");
					var values:Array = String(operation[1]).split(",");
					for (var j:int = 0; j < values.length; j++) {
						values[j] = Number(values[j]);
					}
					trace(operation[0], operation[1]);
					switch(operation[0]) {
						case "scale":
							matrix.scale(values[0], values[1]);
							break;
						case "offset":
						case "translate":
							matrix.translate(values[0], values[1]);
							break;
						case "rotate":
							matrix.rotate(values[0] / 180 * Math.PI);
					}
				}
			}
			return matrix;
		}
		
		private function onControlsSelect(e:Event):void 
		{
			if(ready) drawMesh();
		}
		
		private function onControlsChange(e:Event):void 
		{
			if(ready) drawMesh();
		}
		
		private function drawMesh():void 
		{
			viewMatrix = new Matrix();
			var minViewLength:Number = Math.min(stage.stageWidth , stage.stageHeight);
			viewMatrix.scale(minViewLength * .5, minViewLength * .5);
			viewMatrix.translate(stage.stageWidth * .5, stage.stageHeight * .5);
			//viewMatrix.translate(50, 50);
			particleMesh.draw(canvas, viewMatrix);
		}
		
		private function onResize(e:Event):void 
		{
			drawMesh();
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if (e.keyCode > 48 && e.keyCode < 58) {
				stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
				iterations = e.keyCode - 48;
			}
			if (e.ctrlKey) {
				switch(e.keyCode) {
					case Keyboard.S:
						save();
						break;
				}
			}
			if (e.keyCode == Keyboard.R) {
				reset();
			}
		}
		
		private function reset():void 
		{
			particleMesh = new ParticleMesh();
			particleMesh.distributionMap = distributionMap.bitmapData;
			particleMesh.heightMap = heightMap.bitmapData;
			trace(Settings.totalVerticesToInsert);
			particleMesh.addRandomVertices(Settings.totalVerticesToInsert);
			//particleMesh.addRandomVertices(10);
			drawMesh();
			iterations = Settings.relaxIterations;
		}
		
		protected function save():void 
		{
			trace("initializing save");
		}
		
		protected function savePPM():void 
		{
			trace("saving PlanarParticleMesh (.ppm)");
		}
		
		protected function saveCPPHeader(ppmFile:File, ppmBytes:ByteArray):void 
		{
			trace("saving cpp header (.h)");
		}
		
		protected function saveCPPHeaderFrames(bytes:ByteArray):void 
		{
			trace("saving cpp header frames(.h)");
		}
		
		protected function generateCPPHeaderBytes(ppmBytes:ByteArray, baseName:String):ByteArray 
		{
			baseName = StringUtils.replaceAll(baseName, ".", "_");
			var triangleOffsets:Vector.<Number> = new Vector.<Number>;
			for (var iTri:int = 0; iTri < 6; iTri+=2) {
				var ratio:Number = iTri / 6;
				var angle:Number = (ratio * Math.PI * 2) - Math.PI * .5;
				triangleOffsets[iTri] = Math.cos(angle);
				triangleOffsets[iTri+1] = Math.sin(angle);
			}
			var template:String;
			ppmBytes.position = 0;
			var header:String = ppmBytes.readUTF();
			trace(header);
			var type:String = header.substr(0, header.indexOf("."));
			switch(type) {
				case "Mesh":
					var vertexCount:uint = ppmBytes.readUnsignedInt();
					var vertexDataLength:uint = ppmBytes.readUnsignedInt() / 4;
					var valuesPerVertex:int = 3;
					if (vertexDataLength / vertexCount != valuesPerVertex) throw new Error("Mesh vertex data malformed");
					var vertexValues:Vector.<Number> = new Vector.<Number>;
					var vertexDataString:String = "";
					var texCoordDataString:String = "";
					var displaceDataString:String = "";
					var coordsForDisplaceLookupDataString:String = "";
					for (var i:int = 0; i < vertexDataLength; i += valuesPerVertex) {
						var p:Point = new Point(ppmBytes.readFloat(), ppmBytes.readFloat());
						var height:Number = ppmBytes.readFloat();
						//switcheroo
						var temp:Number = p.x;
						p.x = p.y;
						p.y = temp;
						//
						vertexDataString += "\t" + p.x.toPrecision(5) + "f, " + p.y.toPrecision(5) + "f, " + height.toPrecision(5) + "f,\n";
						var uvp:Point = Settings.uvTransform.transformPoint(p);
						texCoordDataString += "\t" + uvp.x.toPrecision(5) + "f, " + uvp.y.toPrecision(5) + "f,\n";
						uvp = Settings.fixDisplaceUV.transformPoint(uvp);
						coordsForDisplaceLookupDataString += "\t" + uvp.x.toPrecision(5) + "f, " + uvp.y.toPrecision(5) + "f,\n";
						displaceDataString += "\t0.0f,\n";
					}
					var indexCount:uint = ppmBytes.readUnsignedInt();
					var indexDataLength:uint = ppmBytes.readUnsignedInt() / 4;
					if (indexDataLength != indexCount) throw new Error("Mesh index data malformed");
					var indexValues:Vector.<uint> = new Vector.<uint>;
					var indexDataString:String = "";
					for (var i:int = 0; i < indexDataLength; i++) {
						indexValues[i] = ppmBytes.readUnsignedInt();
						if ((i % 3) == 0 && i != 0) indexDataString += "\n";
						if (i % 3 == 0) indexDataString += "\t";
						indexDataString += indexValues[i] + ", ";
					}
					template = new meshTemplate();
					template = StringUtils.replaceAll(template, "%%VERTEX_VALUES%%", vertexDataString);
					template = StringUtils.replaceAll(template, "%%INDEX_VALUES%%", indexDataString);
					template = StringUtils.replaceAll(template, "%%TEXCOORD_VALUES%%", texCoordDataString);
					template = StringUtils.replaceAll(template, "%%DISPLACE_VALUES%%", displaceDataString);
					template = StringUtils.replaceAll(template, "%%COORDS_FOR_DISPLACE_LOOKUP_VALUES%%", coordsForDisplaceLookupDataString);
					template = StringUtils.replaceAll(template, "%%VERTEX_TOTAL%%", String(vertexCount));
					template = StringUtils.replaceAll(template, "%%INDEX_TOTAL%%", String(indexCount));
					template = StringUtils.replaceAll(template, "%%VERTEX_SIZE%%", String(3));
					template = StringUtils.replaceAll(template, "%%TEXCOORD_SIZE%%", String(2));
					template = StringUtils.replaceAll(template, "%%DISPLACE_SIZE%%", String(1));
					template = StringUtils.replaceAll(template, "%%COORDS_FOR_DISPLACE_LOOKUP_SIZE%%", String(2));
					template = StringUtils.replaceAll(template, "%%COORDS_FOR_DISPLACE_LOOKUP_TOTAL%%", String(vertexCount));
					template = StringUtils.replaceAllCases(template, "template", baseName);
					//trace(template);
					break;
				case "Particles":
					var particleCount:uint = ppmBytes.readUnsignedInt();
					var vertexCount:uint = particleCount * 3;
					var uvScale:Point = new Point(.25, .5);
					var valuesPerVertex:int = 3;
					var vertexDataLength:uint = ppmBytes.readUnsignedInt() / 4;
					if (vertexDataLength / particleCount != valuesPerVertex) throw new Error("Particle vertex data malformed");
					var vertexValues:Vector.<Number> = new Vector.<Number>;
					var vertexDataString:String = "";
					var texCoordDataString:String = "";
					var displaceDataString:String = "";
					var coordsForDisplaceLookupDataString:String = "";
					var timeOffsetsDataString:String = "";
					for (var i:int = 0; i < vertexDataLength; i += valuesPerVertex) {
						var p:Point = new Point(ppmBytes.readFloat(), ppmBytes.readFloat());
						var radius:Number = ppmBytes.readFloat() * 2;
						//switcheroo
						var temp:Number = p.x;
						p.x = p.y;
						p.y = temp;
						//
						vertexDataString += "\t" + p.x.toPrecision(5) + "f, " + p.y.toPrecision(5) + "f, " + (triangleOffsets[0] * radius).toPrecision(5) + "f, " + (triangleOffsets[1] * radius).toPrecision(5) + "f,\n";
						vertexDataString += "\t" + p.x.toPrecision(5) + "f, " + p.y.toPrecision(5) + "f, " + (triangleOffsets[2] * radius).toPrecision(5) + "f, " + (triangleOffsets[3] * radius).toPrecision(5) + "f,\n";
						vertexDataString += "\t" + p.x.toPrecision(5) + "f, " + p.y.toPrecision(5) + "f, " + (triangleOffsets[4] * radius).toPrecision(5) + "f, " + (triangleOffsets[5] * radius).toPrecision(5) + "f,\n";
						var uvp:Point = Settings.uvTransform.transformPoint(p);
						texCoordDataString += "\t" + (uvp.x - triangleOffsets[0] * radius * uvScale.x).toPrecision(5) + "f, " + (uvp.y + triangleOffsets[1] * radius * uvScale.y).toPrecision(5) + "f, " + triangleOffsets[0].toPrecision(5) + "f, " + triangleOffsets[1].toPrecision(5) + "f,\n";
						texCoordDataString += "\t" + (uvp.x - triangleOffsets[2] * radius * uvScale.x).toPrecision(5) + "f, " + (uvp.y + triangleOffsets[3] * radius * uvScale.y).toPrecision(5) + "f, " + triangleOffsets[2].toPrecision(5) + "f, " + triangleOffsets[3].toPrecision(5) + "f,\n";
						texCoordDataString += "\t" + (uvp.x - triangleOffsets[4] * radius * uvScale.x).toPrecision(5) + "f, " + (uvp.y + triangleOffsets[5] * radius * uvScale.y).toPrecision(5) + "f, " + triangleOffsets[4].toPrecision(5) + "f, " + triangleOffsets[5].toPrecision(5) + "f,\n";
						uvp = Settings.fixDisplaceUV.transformPoint(uvp);
						coordsForDisplaceLookupDataString += "\t" + uvp.x.toPrecision(5) + "f, " + uvp.y.toPrecision(5) + "f,\n";
						if(Settings.isMotionVector) displaceDataString = StringUtils.addMultipleTimes(displaceDataString, "\t0.0f, 0.0f, 0.0f,\n", 3);
						else displaceDataString = StringUtils.addMultipleTimes(displaceDataString, "\t0.0f,\n", 3);
						var timeOffset:Number = Math.random();
						timeOffsetsDataString = StringUtils.addMultipleTimes(timeOffsetsDataString, "\t" + timeOffset.toPrecision(5) + "f,\n", 3);
					}
					var indexCount:uint = vertexCount;
					var indexValues:Vector.<uint> = new Vector.<uint>;
					var indexDataString:String = "";
					for (var i:int = 0; i < indexCount; i++) {
						indexValues[i] = i;
						if ((i % 3) == 0 && i != 0) indexDataString += "\n";
						if (i % 3 == 0) indexDataString += "\t";
						indexDataString += indexValues[i] + ", ";
					}
					if (Settings.isMotionVector) template = new motionVectorParticleTemplate();
					else template = new particleTemplate();
					template = StringUtils.replaceAll(template, "%%VERTEX_VALUES%%", vertexDataString);
					template = StringUtils.replaceAll(template, "%%INDEX_VALUES%%", indexDataString);
					template = StringUtils.replaceAll(template, "%%TEXCOORD_VALUES%%", texCoordDataString);
					template = StringUtils.replaceAll(template, "%%DISPLACE_VALUES%%", displaceDataString);
					template = StringUtils.replaceAll(template, "%%COORDS_FOR_DISPLACE_LOOKUP_VALUES%%", coordsForDisplaceLookupDataString);
					template = StringUtils.replaceAll(template, "%%TIME_OFFSETS_VALUES%%", timeOffsetsDataString);
					template = StringUtils.replaceAll(template, "%%VERTEX_TOTAL%%", String(vertexCount));
					template = StringUtils.replaceAll(template, "%%INDEX_TOTAL%%", String(indexCount));
					template = StringUtils.replaceAll(template, "%%VERTEX_SIZE%%", String(4));
					template = StringUtils.replaceAll(template, "%%TEXCOORD_SIZE%%", String(4));
					template = StringUtils.replaceAll(template, "%%DISPLACE_SIZE%%", String(Settings.isMotionVector ? 3 : 1));
					template = StringUtils.replaceAll(template, "%%TIME_OFFSETS_SIZE%%", String(1));
					template = StringUtils.replaceAll(template, "%%COORDS_FOR_DISPLACE_LOOKUP_SIZE%%", String(2));
					template = StringUtils.replaceAll(template, "%%COORDS_FOR_DISPLACE_LOOKUP_TOTAL%%", String(particleCount));
					template = StringUtils.replaceAllCases(template, "template", baseName);
					break;
				default:
					throw new Error("Unsupported type. Check the header!");
			}
			var cppHeaderBytes:ByteArray = new ByteArray()
			cppHeaderBytes.endian = Settings.endian;
			cppHeaderBytes.writeUTFBytes(template);
			trace(type);
			return cppHeaderBytes;
		}
		
		private function onEnterFrame(e:Event):void 
		{
			if (Settings.interactiveMode) {
				if (iterations > 0) {
					trace("iterations left:", iterations);
					iterations--;
					relaxIteration();
				} else if (iterations == 0) {
					if (exportingFrames) {
						if(baseFileName) savePPM();
					} else {
						iterations--;
						stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
					}
				}
			}
		}
		
		private function relaxIteration():void 
		{
			particleMesh.retriangulate();
			particleMesh.relax();
			if(Settings.interactiveMode) particleMesh.draw(canvas, viewMatrix);
		}
		
	}
	
}