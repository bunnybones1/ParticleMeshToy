package com.bunnybones.particleMeshToy.ui 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class SubControls extends Sprite 
	{
		static public const MARGIN:Number = 10;
		static public const PADDING:Number = 6;
		private var align:String;
		private var bg:Shape;
		
		public function SubControls(align:String = StageAlign.TOP_LEFT) 
		{
			this.align = align;
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
			bg = new Shape();
			addChild(bg);
			stage.addEventListener(Event.RESIZE, onResize);
			onResize(null);
		}
		
		private function onResize(e:Event):void 
		{
			var left:Boolean = false;
			var top:Boolean = false;
			switch(align) {
				case StageAlign.TOP_LEFT:
				case StageAlign.BOTTOM_LEFT:
					left = true;
					break;
			}
			switch(align) {
				case StageAlign.TOP_LEFT:
				case StageAlign.TOP_RIGHT:
					top = true;
					break;
			}
			
			var cursorY:Number = top ? MARGIN : -MARGIN;
			for (var i:int = 0; i < numChildren; i++) 
			{
				if ((getChildAt(i) is Sprite)) {
					var child:Sprite = getChildAt(i) as Sprite;
					if (left) child.x = MARGIN;
					else child.x = -child.width - MARGIN;
					if (!top) cursorY -= child.height + PADDING;
					child.y = cursorY;
					if (top) cursorY += child.height + PADDING;
				}
			}
			bg.graphics.clear();
			bg.graphics.beginFill(0xffffff, .7);
			var b:Rectangle = this.getBounds(this);
			b = b.union(new Rectangle(0, 0, 1, 1));
			b.inflate(MARGIN, MARGIN);
			bg.graphics.drawRoundRect(b.x, b.y, b.width, b.height, 6, 6);
			bg.graphics.endFill();
		}
		
		override public function addChild(child:DisplayObject):DisplayObject 
		{
			var displayObject:DisplayObject = super.addChild(child);
			onResize(null);
			return displayObject;
		}
		
	}

}