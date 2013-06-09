package com.bit101.components 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LabelledRangeSlider extends HRangeSlider 
	{
		
		public function LabelledRangeSlider(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number = 0, defaultHandler:Function = null, label:String = null)
		{
			super(parent, xpos, ypos, defaultHandler);
			width = 200;
			labelPrecision = 1;
			if (label != null) {
				new Label(this, width + 5, -5, label);
			}
		}
		
	}

}