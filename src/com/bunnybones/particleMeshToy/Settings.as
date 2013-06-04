package com.bunnybones.particleMeshToy 
{
	/**
	 * ...
	 * @author Tomasz Dysinski
	 */
	public class Settings 
	{
		static public const SIZE_THRESHOLD:Number = .18;
		static public const TYPE_MESH:String = "typeMesh";
		static public const TYPE_PARTICLES_FROM_VERTICES:String = "typeParticlesFromVertices";
		static public const TYPE_PARTICLES_FROM_FACES:String = "typeParticlesFromFaces";
		static public const TYPE_PARTICLES_FROM_FACES_AND_VERTICES:String = "typeParticlesFromFacesAndVertices";
		static public var meshType:String;
		static public var filterByParticleSizeLow:Number = 0.0;
		static public var filterByParticleSizeHigh:Number = 100.0;
		static public var particleScale:Number = 1.0;
		
		public function Settings() 
		{
			
		}
		
	}

}