package com.bunnybones.particleMeshToy.ui 
{
	import com.bit101.components.LabelledRangeSlider;
	import com.bit101.components.LabelledSlider;
	import com.bit101.components.RadioButton;
	import com.bit101.components.Slider;
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
			new LabelledSlider(bl, 0, 0, onParticleScaleChange, "Particle Scale");
			var rs:LabelledRangeSlider = new LabelledRangeSlider(bl, 0, 0, onFilterByParticleSizeChange, "Filter by Particle Size");
			rs.lowValue = Settings.filterByParticleSizeLow;
			rs.highValue = Settings.filterByParticleSizeHigh;
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