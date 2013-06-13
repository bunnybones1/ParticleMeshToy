//template cpp buffer

#ifndef _TEMPLATE_H_
#define _TEMPLATE_H_


#define TEMPLATE_VERTEX_SIZE %%VERTEX_SIZE%%
#define TEMPLATE_VERTEX_TOTAL %%VERTEX_TOTAL%%

#define TEMPLATE_TEXCOORD_SIZE %%TEXCOORD_SIZE%%
#define TEMPLATE_TEXCOORD_TOTAL %%VERTEX_TOTAL%%

#define TEMPLATE_DISPLACE_SIZE %%DISPLACE_SIZE%%
#define TEMPLATE_DISPLACE_TOTAL %%VERTEX_TOTAL%%

#define TEMPLATE_COORDS_FOR_DISPLACE_LOOKUP_SIZE %%COORDS_FOR_DISPLACE_LOOKUP_SIZE%%
#define TEMPLATE_COORDS_FOR_DISPLACE_LOOKUP_TOTAL %%COORDS_FOR_DISPLACE_LOOKUP_TOTAL%%

#define TEMPLATE_INDEX_TOTAL %%INDEX_TOTAL%%



static const GLfloat templateVertices[TEMPLATE_VERTEX_TOTAL * TEMPLATE_VERTEX_SIZE] =
{
%%VERTEX_VALUES%%
};

static const GLfloat templateTexCoords[TEMPLATE_TEXCOORD_TOTAL * TEMPLATE_TEXCOORD_SIZE] =
{
%%TEXCOORD_VALUES%%
};

static float templateDisplace[TEMPLATE_DISPLACE_TOTAL * TEMPLATE_DISPLACE_SIZE] =
{
%%DISPLACE_VALUES%%
};

static const GLfloat templateCoordsForDisplaceLookup[TEMPLATE_COORDS_FOR_DISPLACE_LOOKUP_TOTAL * TEMPLATE_COORDS_FOR_DISPLACE_LOOKUP_SIZE] =
{
%%COORDS_FOR_DISPLACE_LOOKUP_VALUES%%
};

static const unsigned short templateIndices[TEMPLATE_INDEX_TOTAL] =
{
%%INDEX_VALUES%%
};

#endif // _TEMPLATE_H_

GLBufferGroup templateGLBufferGroup = {
    .type = TYPE_MOTION_VECTOR_PARTICLES,
    
    .verticesSize = TEMPLATE_VERTEX_SIZE,
    .verticesTotal = TEMPLATE_VERTEX_TOTAL,
    .vertices = templateVertices,
    
    .texCoordsSize = TEMPLATE_TEXCOORD_SIZE,
    .texCoordsTotal = TEMPLATE_TEXCOORD_TOTAL,
    .texCoords = templateTexCoords,
    
    .displaceSize = TEMPLATE_DISPLACE_SIZE,
    .displaceTotal = TEMPLATE_DISPLACE_TOTAL,
    .displace = templateDisplace,
    
    .coordsForDisplaceLookupSize = TEMPLATE_COORDS_FOR_DISPLACE_LOOKUP_SIZE,
    .coordsForDisplaceLookupTotal = TEMPLATE_COORDS_FOR_DISPLACE_LOOKUP_TOTAL,
    .coordsForDisplaceLookup = templateCoordsForDisplaceLookup,
    
    .indicesTotal = TEMPLATE_INDEX_TOTAL,
    .indices = templateIndices,
	
    .frameTimeOffset = %%FRAME_TIME_OFFSET%%,
};
