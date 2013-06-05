package com.bunnybones.particleMeshToy 
{
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class MainAir extends Main 
	{
		
		public function MainAir() 
		{
			
		}
		
		override protected function save():void 
		{
			super.save();
			var file:File = new File();
			file.addEventListener(Event.CANCEL, onSaveFileCancel);
			file.addEventListener(Event.SELECT, onSaveFileSelect);
			file.browseForSave("Save buffer");
		}
		
		private function onSaveFileCancel(e:Event):void 
		{
			var file:File = e.target as File;
			file.removeEventListener(Event.CANCEL, onSaveFileCancel);
			file.removeEventListener(Event.SELECT, onSaveFileSelect);
		}
		
		private function onSaveFileSelect(e:Event):void 
		{
			var file:File = e.target as File;
			if (file.url.indexOf(".ppm") == -1) {
				file = new File(file.url + ".ppm");
			}
			file.removeEventListener(Event.CANCEL, onSaveFileCancel);
			file.removeEventListener(Event.SELECT, onSaveFileSelect);
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(file, FileMode.WRITE);
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			fileStream.writeBytes(particleMesh.serialize(bytes));
			fileStream.close();
			
			saveCPPHeader(file, bytes);
		}
		
		override protected function saveCPPHeader(ppmFile:File, ppmBytes:ByteArray):void 
		{
			var file:File = new File(ppmFile.url.replace(".ppm", ".h"));
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(file, FileMode.WRITE);
			fileStream.writeBytes(generateCPPHeaderBytes(ppmBytes));
			fileStream.close();
		}
	}

}