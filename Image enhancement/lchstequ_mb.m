function OUTIMG=lchstequ_mb(INPIMG_in,LX,LY)
INPIMG = double(INPIMG_in.im);
% LOCAL HISTOGRAM EQUALIZATION OVER WINDOW (2Lx+1,2Ly+1)
% Image mirror extension by the size of the spatial window
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call  OUTIMG=lchstequ(INPIMG,LX,LY);
SzW=LX*LY;
Lx=ceil((LX-1)/2);
Ly=ceil((LY-1)/2);
[SzX SzY]=size(INPIMG);


imgext=img_ext_mb(INPIMG,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding')';

center = INPIMG(:)*ones(1,SzW);

OUTIMG = 255*sum(nbhood<center,2)/(LX*LY);

OUTIMG=uint8(reshape(OUTIMG, [SzY SzX]));

end


	