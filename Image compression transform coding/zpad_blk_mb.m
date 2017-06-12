function out = zpad_blk_mb(a, blk_sz,padval); 
% this function works similar to subroutine in blkproc.m in Matlab Package
% Expand a: pad if size(a) is not divisible by block.
[ma,na] = size(a);

mpad = rem(ma,blk_sz(1)); if mpad>0, mpad = blk_sz(1)-mpad; end
npad = rem(na,blk_sz(2)); if npad>0, npad = blk_sz(2)-npad; end
if (isa(a, 'uint8'))
    if (padval == 1)
        out = repmat(uint8(1), ma+mpad,na+npad); % pad with 1
    else
        out = repmat(uint8(0), ma+mpad,na+npad); % pad with 0
    end
else
    if (padval == 1)
        out = ones(ma+mpad,na+npad);  % pad with 1
    else
        out = zeros(ma+mpad,na+npad); % pad with 0
    end
end
out(1:ma,1:na) = a;