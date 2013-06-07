//example cpp buffer

#ifndef _QUAD_H_
#define _QUAD_H_


#define QUAD_VERTEX_TOTAL 4
#define QUAD_INDEX_TOTAL 6


static const float quadVertices[QUAD_VERTEX_TOTAL * 2] =
{
   -1.00f,  -1.00f,
    1.00f,  -1.00f,
    -1.00f,   1.00f,
    1.00f,   1.00f,
};

static const float quadTexCoords[QUAD_VERTEX_TOTAL * 2] =
{
    0, 0,
    1, 0,
    0, 1,
    1, 1,
};

static const unsigned short quadIndices[QUAD_INDEX_TOTAL] =
{
     0,  1,  2,  1,  3,  2,
};

#endif // _QUAD_H_
