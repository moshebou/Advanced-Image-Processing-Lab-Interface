% Block processing envelop for reconstruction
% an image from quantized dct blocks
% implements decode_jpg_block in every block
function y = decode_jpg_mb(c,q)
func = @(X)decode_jpg_block_mb(X, q);
y = blockproc(c, [8 8],func) + 128;
% clamp to valid pixel values
y(y<0) = 0;
y(y>255) = 255;


