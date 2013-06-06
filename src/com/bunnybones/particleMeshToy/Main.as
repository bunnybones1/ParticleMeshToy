package com.bunnybones.particleMeshToy
{
	import com.bunnybones.particleMeshToy.geom.ParticleMesh;
	import com.bunnybones.particleMeshToy.ui.Controls;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Main extends Sprite 
	{
		
		[Embed(source = "../../../../assets/test.png")]
		private static const distributionImage:Class;
		[Embed(source="../../../../assets/meshTemplate.h", mimeType="application/octet-stream")]
		private static const meshTemplate:Class;
		protected var particleMesh:ParticleMesh;
		private var viewMatrix:Matrix;
		private var iterations:int = 0;
		private var controls:Controls;
		private var canvas:Sprite;
		private var ready:Boolean;
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function init():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, onResize);
			
			canvas = new Sprite();
			addChild(canvas);
			
			controls = new Controls();
			controls.addEventListener(Event.CHANGE, onControlsChange);
			controls.addEventListener(Event.SELECT, onControlsSelect);
			addChild(controls);
			
			var distributionMap:Bitmap = new distributionImage();
			
			particleMesh = new ParticleMesh();
			particleMesh.distributionMap = distributionMap.bitmapData;
			//particleMesh.addRandomVertices(120 * 80 * .1);
			particleMesh.addRandomVertices(10);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			ready = true;
			drawMesh();
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
		}
		
		protected function save():void 
		{
			trace("saving PlanarParticleMesh (.ppm)");
		}
		
		protected function saveCPPHeader(ppmFile:File, ppmBytes:ByteArray):void 
		{
			trace("saving cpp header (.h)");
		}
		
		protected function generateCPPHeaderBytes(ppmBytes:ByteArray, baseName:String):ByteArray 
		{
			var template:String;
			ppmBytes.position = 0;
			var header:String = ppmBytes.readUTF();
			trace(header);
			var type:String = header.substr(0, header.indexOf("."));
			switch(type) {
				case "Mesh":
					var vertexCount:uint = ppmBytes.readUnsignedInt();
					var vertexDataLength:uint = ppmBytes.readUnsignedInt() / 4;
					if (vertexDataLength / vertexCount != 2) throw new Error("Mesh vertex data malformed");
					var vertexValues:Vector.<Number> = new Vector.<Number>;
					var vertexDataString:String = "";
					for (var i:int = 0; i < vertexDataLength; i++) {
						vertexValues[i] = ppmBytes.readFloat();
						if ((i % 2) == 0 && i != 0) vertexDataString += "\n";
						if (i % 2 == 0) vertexDataString += "\t";
						vertexDataString += vertexValues[i].toPrecision(5) + "f, ";
					}
					var indexCount:uint = ppmBytes.readUnsignedInt();
					var indexDataLength = ppmBytes.readUnsignedInt() / 4;
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
					template = template.replace("%%VERTEX_VALUES%%", vertexDataString);
					template = template.replace("%%INDEX_VALUES%%", indexDataString);
					template = StringUtils.replaceAllCases(template, "template", baseName);
					trace(template);
					break;
				case "Particles":
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
			if (iterations > 0) {
				trace("iterations left:", iterations);
				iterations--;
				particleMesh.retriangulate();
				particleMesh.relax();
				particleMesh.draw(canvas, viewMatrix);
			} else if (iterations == 0) {
				iterations--;
				stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
	}
	
}