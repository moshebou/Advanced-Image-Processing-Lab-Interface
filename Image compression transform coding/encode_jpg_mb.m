% Block processing envelop for encoding
% an image into quantized dct blocks
% implements encode_jpg_block in every block
function c = encode_jpg_mb (x, q, blc_sz, zero_center)
if  nargin == 2
    blc_sz = [8 8];
end
if  ((nargin < 4) || (zero_center == 1))
    x = x-128;
end
func = @(X)encode_jpg_block_mb(X, q);
c = blockproc(x, blc_sz, func);
