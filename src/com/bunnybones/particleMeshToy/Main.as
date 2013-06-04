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
	import flash.geom.Matrix;
	import flash.ui.Keyboard;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Main extends Sprite 
	{
		[Embed(source = "../../../../assets/test.png")]
		private static const distributionImage:Class;
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
			particleMesh.addRandomVertices(120 * 80 * .1);
			//particleMesh.addRandomVertices(3);
			
			drawMesh();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			ready = true;
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
			trace("saving");
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