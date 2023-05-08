#include "variadic-wrapper.h"

int opus_custom_encoder_ctl_wrapper(OpusCustomEncoder *OPUS_RESTRICT st, int request, opus_int32 val)
{
	return opus_custom_encoder_ctl(st, request, val);
}

int opus_custom_decoder_ctl_wrapper(OpusCustomDecoder *OPUS_RESTRICT st, int request, opus_int32 val)
{
	return opus_custom_decoder_ctl(st, request, val);
}
