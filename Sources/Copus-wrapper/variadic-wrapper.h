#ifndef __OPUS_VARIADIC_WRAPPER_H__
#define __OPUS_VARIADIC_WRAPPER_H__

//#include ""
#include <opus_defines.h>
#include <opus_custom.h>

int opus_custom_encoder_ctl_wrapper(OpusCustomEncoder *OPUS_RESTRICT st, int request, opus_int32 val);
int opus_custom_decoder_ctl_wrapper(OpusCustomDecoder *OPUS_RESTRICT st, int request, opus_int32 val);

#endif
