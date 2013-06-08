//
//  glBufferGroup.h
//
//  Created by Tomasz Dysinski on 13-06-07.
//
//

#ifndef _glBufferGroup_h
#define _glBufferGroup_h
#define TYPE_RUBBERSHEET 0
#define TYPE_PARTICLES 1

typedef struct {
    const unsigned int type;
    
    GLint shaderProgramID;
    
    const unsigned int verticesSize;
    const unsigned int verticesTotal;
    const GLfloat *vertices;
    GLuint verticesVBO;
    GLint vertexHandle;
    
    const unsigned int texCoordsSize;
    const unsigned int texCoordsTotal;
    const GLfloat *texCoords;
    GLuint texCoordsVBO;
    GLint texCoordsHandle;
    
    const unsigned int coordsForDisplaceLookupSize;
    const unsigned int coordsForDisplaceLookupTotal;
    const GLfloat *coordsForDisplaceLookup;
    GLuint coordsForDisplaceLookupVBO;
    GLint coordsForDisplaceLookupHandle;
    
    const unsigned int displaceSize;
    const unsigned int displaceTotal;
    const GLfloat *displace;
    GLint displaceHandle;
    
    const unsigned int indicesTotal;
    const unsigned short *indices;
    
    const unsigned int timeOffsetParticleSizeSize;
    const unsigned int timeOffsetParticleSizeTotal;
    const GLfloat *timeOffsetParticleSize;
    
    GLuint timeOffsetParticleSizeVBO;
    GLint timeOffsetParticleSizeHandle;
    
    GLint globalParticleSizeHandle;
    GLint globalTimeHandle;
    
    
} GLBufferGroup;



#endif
