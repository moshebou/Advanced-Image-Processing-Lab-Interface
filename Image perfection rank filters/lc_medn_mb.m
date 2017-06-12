function OUTIMG=lc_medn_mb(INPIMG,LX,LY)
%**************************************************************
% Copyright: L. Yaroslavsky (yaro@eng.tau.ac.il) 
% 2) LOCAL median filtering over window; 
% LX - is window vertical size;
% LY - is window horizontal size;
% Displm - is a flag for displaying:
% if Displm==0, then display is disabled
% Image mirror extension by the size of the spatial window
% Call: OUTMEDN=lc_median(INPIMG,LX,LY)
%**************************************************************
INPIMG = double(INPIMG);
[SzX SzY]=size(INPIMG);
Lx=(LX-1)/2;
Ly=(LY-1)/2;
imgext=img_ext_mb(INPIMG,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding');
OUTIMG_med=median(nbhood,1);
OUTIMG = reshape(OUTIMG_med, SzY, SzX);

end

