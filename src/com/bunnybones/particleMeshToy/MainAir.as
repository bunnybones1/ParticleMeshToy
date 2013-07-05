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
			if (exportingFrames) exportingFrames = false;
		}
		
		private function onSaveFileSelect(e:Event):void 
		{
			var file:File = e.target as File;
			file.removeEventListener(Event.CANCEL, onSaveFileCancel);
			file.removeEventListener(Event.SELECT, onSaveFileSelect);
			if (file.url.indexOf(".ppm") == -1) {
				file = new File(StringUtils.replaceAll(file.url, ".", "_"));
				file = new File(file.url + ".ppm");
			}
			baseFilePath = file.url.substring(0, file.url.lastIndexOf("/") + 1);
			baseFileName = file.url.substring(file.url.lastIndexOf("/") + 1, file.url.lastIndexOf("."));
			if (!exportingFrames) savePPM();
			else processFrames();
		}
		
		override protected function savePPM():void 
		{
			var file:File = new File(baseFilePath + baseFileName + ".ppm");
			if (exportingFrames) file = new File(file.url.replace(".ppm", currentFrame+".ppm"));
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(file, FileMode.WRITE);
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.LITTLE_ENDIAN;
			fileStream.writeBytes(particleMesh.serialize(bytes));
			fileStream.close();
			trace("saving " + file.url);
			saveCPPHeader(file, bytes);
		}
		
		override protected function saveCPPHeader(ppmFile:File, ppmBytes:ByteArray):void 
		{
			var file:File;
			file = new File(ppmFile.url.replace(".ppm", ".h"));
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(file, FileMode.WRITE);
			trace("saving " + file.url);
			if(exportingFrames) fileStream.writeBytes(generateCPPHeaderBytes(ppmBytes, baseFileName + currentFrame));
			else fileStream.writeBytes(generateCPPHeaderBytes(ppmBytes, baseFileName));
			fileStream.close();
		}
		
		override protected function saveCPPHeaderFrames(bytes:ByteArray):void 
		{
			var file:File = new File(baseFilePath + baseFileName + ".h");
			var fileStream:FileStream = new FileStream();
			fileStream.openAsync(file, FileMode.WRITE);
			trace("saving " + file.url);
			fileStream.writeBytes(bytes);
			fileStream.close();
		}
	}

}

