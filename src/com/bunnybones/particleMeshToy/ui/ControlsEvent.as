package com.bunnybones.particleMeshToy.ui 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class ControlsEvent extends Event 
	{
		static public const RESET:String = "reset";
		static public const GO:String = "go";
		
		public function ControlsEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			GO
		} 
		
		public override function clone():Event 
		{ 
			return new ControlsEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("ControlsEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}