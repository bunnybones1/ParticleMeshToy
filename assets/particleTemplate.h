//template cpp buffer

#ifndef _TEMPLATE_H_
#define _TEMPLATE_H_


#define TEMPLATE_PARTICLE_TOTAL %%PARTICLE_TOTAL%%
#define TEMPLATE_VERTEX_TOTAL %%VERTEX_TOTAL%%
#define TEMPLATE_INDEX_TOTAL %%INDEX_TOTAL%%


static const GLfloat templateVertices[TEMPLATE_VERTEX_TOTAL * 4] =
{
%%VERTEX_VALUES%%
};

static const GLfloat templateCoordsForDisplaceLookup[TEMPLATE_VERTEX_TOTAL * 2] =
{
%%COORDS_FOR_DISPLACE_LOOKUP_VALUES%%
};

static float templateDisplace[TEMPLATE_VERTEX_TOTAL] =
{
%%DISPLACE_VALUES%%
};

static const GLfloat templateTexCoords[TEMPLATE_VERTEX_TOTAL * 2] =
{
%%TEXCOORD_VALUES%%
};

static const unsigned short templateIndices[TEMPLATE_INDEX_TOTAL] =
{
%%INDEX_VALUES%%
};

static const GLfloat templateTimeOffsetsParticleSizes[TEMPLATE_VERTEX_TOTAL * 2] =
{
%%TIME_OFFSETS_PARTICLE_SIZES%%
};

#endif // _TEMPLATE_H_
