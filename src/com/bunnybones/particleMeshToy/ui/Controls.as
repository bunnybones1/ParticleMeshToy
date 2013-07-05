package com.bunnybones.particleMeshToy.ui 
{
	import com.bit101.components.CheckBox;
	import com.bit101.components.HSlider;
	import com.bit101.components.LabelledRangeSlider;
	import com.bit101.components.LabelledSlider;
	import com.bit101.components.PushButton;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Slider;
	import com.bit101.components.VSlider;
	import com.bunnybones.particleMeshToy.Settings;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Controls extends Sprite
	{
		public var tl:SubControls;
		public var tr:SubControls;
		public var bl:SubControls;
		public var br:SubControls;
		
		public function Controls() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			init();
		}
		
		private function init():void 
		{
			stage.addEventListener(Event.RESIZE, onStageResize);
			tl = new SubControls(StageAlign.TOP_LEFT);
			tr = new SubControls(StageAlign.TOP_RIGHT);
			bl = new SubControls(StageAlign.BOTTOM_LEFT);
			br = new SubControls(StageAlign.BOTTOM_RIGHT);
			addChild(tl);
			addChild(tr);
			addChild(bl);
			addChild(br);
			new RadioButton(br, 0, 0, "particles from faces and vertices", true, onTypeSelectParticlesFromFacesAndVertices);
			new RadioButton(br, 0, 0, "particles from faces", true, onTypeSelectParticlesFromFaces);
			new RadioButton(br, 0, 0, "particles from vertices", true, onTypeSelectParticlesFromVertices);
			new RadioButton(br, 0, 0, "mesh", true, onTypeSelectMesh);
			new CheckBox(br, 0, 0, "is Motion Vector Buffer", onTypeSelectIsMotionVector);
			new LabelledSlider(bl, 0, 0, onParticleScaleChange, "Particle Scale");
			var rs:LabelledRangeSlider = new LabelledRangeSlider(bl, 0, 0, onFilterByParticleSizeChange, "Filter by Particle Size");
			rs.tick = .1;
			rs.lowValue = Settings.filterByParticleSizeLow;
			rs.highValue = Settings.filterByParticleSizeHigh * 100;
			
			var totalVerticesToInsertSlider:LabelledSlider = new LabelledSlider(tl, 0, 0, onTotalVerticesToInsertChanged, "Total Vertices To Insert", Settings.totalVerticesToInsert, 200);
			totalVerticesToInsertSlider.tick = 10;
			totalVerticesToInsertSlider.minimum = 10;
			totalVerticesToInsertSlider.maximum = 120 * 80;
			totalVerticesToInsertSlider.value = Settings.totalVerticesToInsert;
			var totalFramesSlider:LabelledSlider = new LabelledSlider(tl, 0, 0, onTotalFramesChanged, "Total Frames", Settings.totalFrames);
			totalFramesSlider.tick = 1;
			totalFramesSlider.minimum = 1;
			totalFramesSlider.maximum = 30;
			var relaxIterationsSlider:LabelledSlider = new LabelledSlider(tl, 0, 0, onRelaxIterationsChanged, "Relax Iterations", Settings.relaxIterations);
			relaxIterationsSlider.tick = 1;
			relaxIterationsSlider.minimum = 0;
			relaxIterationsSlider.maximum = 10;
			
			new PushButton(tl, 0, 0, "RESET", onClickReset);
			new PushButton(tl, 0, 0, "GO", onClickGo);
		}
		
		private function onTotalVerticesToInsertChanged(e:Event = null):void 
		{
			//trace(e);
			var slider:LabelledSlider = e.target as LabelledSlider;
			Settings.totalVerticesToInsert = slider.value;
		}
		
		private function onTotalFramesChanged(e:Event = null):void 
		{
			trace(e);
			var slider:LabelledSlider = e.target as LabelledSlider;
			Settings.totalFrames = slider.value;
			trace(slider.value);
		}
		
		private function onRelaxIterationsChanged(e:Event = null):void 
		{
			//trace(e);
			var slider:LabelledSlider = e.target as LabelledSlider;
			Settings.relaxIterations = slider.value;
		}
		
		private function onClickGo(e:Event = null):void 
		{
			dispatchEvent(new ControlsEvent(ControlsEvent.GO));
		}
		
		private function onClickReset(e:Event = null):void 
		{
			dispatchEvent(new ControlsEvent(ControlsEvent.RESET));
		}
		
		private function onTypeSelectMesh(e:Event):void 
		{
			Settings.meshType = Settings.TYPE_MESH;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		private function onTypeSelectParticlesFromVertices(e:Event):void 
		{
			Settings.meshType = Settings.TYPE_PARTICLES_FROM_VERTICES;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		private function onTypeSelectParticlesFromFaces(e:Event):void 
		{
			Settings.meshType = Settings.TYPE_PARTICLES_FROM_FACES;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		private function onTypeSelectParticlesFromFacesAndVertices(e:Event):void 
		{
			Settings.meshType = Settings.TYPE_PARTICLES_FROM_FACES_AND_VERTICES;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		private function onTypeSelectIsMotionVector(e:Event):void 
		{
			var checkBox:CheckBox = e.target as CheckBox;
			Settings.isMotionVector = checkBox.selected;
			dispatchEvent(new Event(Event.SELECT));
		}
		
		private function onStageResize(e:Event):void 
		{
			tr.x = stage.stageWidth;
			bl.y = stage.stageHeight;
			br.x = stage.stageWidth;
			br.y = stage.stageHeight;
		}
		
		private function onFilterByParticleSizeChange(e:Event):void 
		{
			var slider:LabelledRangeSlider = e.target as LabelledRangeSlider;
			Settings.filterByParticleSizeLow = slider.lowValue * .01;
			Settings.filterByParticleSizeHigh = slider.highValue * .01;
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		private function onParticleScaleChange(e:Event):void 
		{
			Settings.particleScale = (e.target as LabelledSlider).value * .05;
			dispatchEvent(new Event(Event.CHANGE));
		}
	}

}