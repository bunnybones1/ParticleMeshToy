package com.bunnybones.particleMeshToy 
{
	import flash.geom.Matrix;
	import flash.utils.Endian;
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
		static public var meshType:String = TYPE_MESH;
		static public var filterByParticleSizeLow:Number = 0.0;
		static public var filterByParticleSizeHigh:Number = 100.0;
		static public var particleScale:Number = 1.0;
		static public var endian:String = Endian.LITTLE_ENDIAN;
		static public var uvTransform:Matrix;
		static public var fixDisplaceUV:Matrix;
		static public var uvPresetName:String;
		static public var totalFrames:int = 1;
		static public var relaxIterations:int = 0;
		static public var totalVerticesToInsert:int = 120*80*.25;
		
		public function Settings() 
		{
			
		}
		
	}

}