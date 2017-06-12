function [OUTIMG, im_unique_p_law_quant]=nlquantz_mb(INPIMG,Q,P, im_unique)
INPIMG = double(INPIMG);
% (P)th-law signal magnitude quantization on Q levels;
% OUTIMG is (1/P)th law restored signal after its magnitude 
% is (P)th law nonlinearly quantized on Q levels
% Call OUTIMG=nlquantz(INPIMG,Number of quantization levels,Power)

sINP=sign(INPIMG);absINP=abs(INPIMG);
if ( sum(sINP == -1) )
    Q = Q/2 ; %for sign
end

max_abs=max(absINP(:));
min_abs=min(absINP(:));
fq=round((Q-1)*((absINP -min_abs) /(max_abs -min_abs) ).^(P));
OUTIMG=sINP.*  ( ((max_abs -min_abs)*((fq/(Q-1) ).^(1/P))) + min_abs);

im_unique_sign = sign(im_unique); im_unique_abs = abs(im_unique); 
fq=round((Q-1)*((im_unique_abs -min_abs) /(max_abs -min_abs) ).^(P));
im_unique_p_law_quant=im_unique_sign.*  ( ((max_abs -min_abs)*((fq/(Q-1) ).^(1/P))) + min_abs);





