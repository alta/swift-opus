#include "variadic-wrapper.h"

int opus_custom_encoder_ctl_wrapper(CELTEncoder *OPUS_RESTRICT st, int request, opus_int32 val)
{
	opus_custom_encoder_ctl(st, request, val);
}

int opus_custom_decoder_ctl_wrapper(CELTEncoder *OPUS_RESTRICT st, int request, opus_int32 val)
{
	opus_custom_decoder_ctl(st, request, val);
}
