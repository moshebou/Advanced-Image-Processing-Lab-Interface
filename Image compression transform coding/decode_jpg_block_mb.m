% helper sub-function for decode_jpg (x,q) (works on 8x8 blocks)
function yb = decode_jpg_block_mb (c,q)
yb = round(idct2(c.data.*q));
