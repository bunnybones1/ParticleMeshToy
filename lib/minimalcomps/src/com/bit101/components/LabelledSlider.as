package com.bit101.components 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class LabelledSlider extends HSlider
	{
		
		public function LabelledSlider(parent:DisplayObjectContainer = null, xpos:Number = 0, ypos:Number =  0, defaultHandler:Function = null, label:String = null)
		{
			super(parent, xpos, ypos, defaultHandler);
		}
		
	}

}