% helper sub-function for encode_jpg (works on 8x8 blocks)
function cb = encode_jpg_block_mb(x,q)
cb = round(dct2(x.data)./q);
