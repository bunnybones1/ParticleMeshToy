//template cpp buffer

#ifndef _TEMPLATE_GROUP_H_
#define _TEMPLATE_GROUP_H_

%%INCLUDE_HEADERS_LIST%%

GLBufferGroup *templateFrames[MAX_FRAMES_PER_LAYER] = {
%%FRAME_LIST%%
};

#endif