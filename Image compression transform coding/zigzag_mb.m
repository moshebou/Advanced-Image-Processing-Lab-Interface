function c = zigzag_mb (x, blc_sz)
if ( nargin == 1 )
    blc_sz = [8 8];
end
func = @(X)zigzag_block_mb(X);

c = blockproc(x, blc_sz, func);