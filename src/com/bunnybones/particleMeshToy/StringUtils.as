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
		
		static public function trimAway(string:String, charsToTrim:String):String 
		{
			for (var i:int = 0; i < charsToTrim.length; i++) 
			{
				string = string.split(charsToTrim.substr(i, 1)).join("");
				trace(string);
			}
			string = string.replace(/[\u000d\u000a\u0008\u0020]+/g,""); 
			return string;
		}
		
		static public function addMultipleTimes(string:String, addition:String, times:int):String 
		{
			for (var i:int = 0; i < times; i++) 
			{
				string += addition;
			}
			return string;
		}
	}

}