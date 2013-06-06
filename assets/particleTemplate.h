#example cpp buffer

#ifndef _TEMPLATE_H_
#define _TEMPLATE_H_


#define TEMPLATE_VERTEX_TOTAL 4
#define TEMPLATE_INDEX_TOTAL 6


static const float templateVertices[TEMPLATE_VERTEX_TOTAL * 2] =
{
%%VERTEX_VALUES%%
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
