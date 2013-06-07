//template cpp buffer

#ifndef _TEMPLATE_H_
#define _TEMPLATE_H_


#define TEMPLATE_VERTEX_TOTAL %%VERTEX_TOTAL%%
#define TEMPLATE_INDEX_TOTAL %%INDEX_TOTAL%%


static const float templateVertices[TEMPLATE_VERTEX_TOTAL * 2] =
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

static const float templateTexCoords[TEMPLATE_VERTEX_TOTAL * 2] =
{
%%TEXCOORD_VALUES%%
};

static const unsigned short templateIndices[TEMPLATE_INDEX_TOTAL] =
{
%%INDEX_VALUES%%
};

#endif // _TEMPLATE_H_
