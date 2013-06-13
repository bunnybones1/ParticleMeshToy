package com.bit101.components 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LabelledSlider extends HSlider
	{
		private var label:Label;
		private var defaultHandler:Function;
		private var labelString:String;
		
		public function LabelledSlider(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, defaultHandler:Function = null, label:String = null, defaultValue:Number = 0, sliderWidth:Number = NaN)
		{
			super(parent, xpos, ypos, midHandler);
			this.defaultHandler = defaultHandler;
			this.labelString = label;
			value = defaultValue;
			if (!isNaN(sliderWidth)) {
				width = sliderWidth;
			}
			if (label != null) {
				this.label = new Label(this, width + 5, -5, labelString + " " + String(value));
			}
			
		}
		
		private function midHandler(e:Event):void 
		{
			label.text = labelString + " " + String(value);
			defaultHandler(e);
		}
		
	}

}