package com.bunnybones.particleMeshToy 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class StringUtils 
	{
		
		public function StringUtils() 
		{
		}
		
		static public function replaceAll(string:String, match:String, replacement:String):String
		{
			if (replacement.indexOf(match) != -1) throw new Error("Potential recursive request: Don't replace match with something that also could match");
			var index:int = string.indexOf(match);
			while (index != -1)
			{
				string = string.replace(match, replacement);
				index = string.indexOf(match);
			}
			return string;
		}
		
		static public function replaceAllCases(string:String, match:String, replacement:String):String {
			string = replaceAll(string, match.toUpperCase(), replacement.toUpperCase());
			string = replaceAll(string, match.toLowerCase(), replacement.toLowerCase());
			return string;
		}
	}

}