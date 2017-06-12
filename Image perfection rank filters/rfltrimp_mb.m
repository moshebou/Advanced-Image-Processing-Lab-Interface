function OUTIMG=rfltrimp_mb(INPIMG,LX,LY,Rleft,Rright)
% Impulse noise filtering by checking 
% whether pixel ranks are in the range Rleft<R<Rright
% Correction by median
% LX,LY - window size;
% Rleft,Rright - boundaries of ER-neighborhood
% Call OUTIMG=rfltrimp(INPIMG,LX,LY,Rleft,Rright);




INPIMG = double(INPIMG);
Lx=(LX-1)/2;
Ly=(LY-1)/2;
SzW=LX*LY;
[SzX SzY]=size(INPIMG);
imgext=img_ext_mb(INPIMG,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding')';
% Computation of pixel's rank
center = INPIMG(:)*ones(1,SzW);
R=sum(nbhood<=center,2);
	medn=median(nbhood,2);
	mask=(R<=Rleft)+(R>=Rright);
	OUTIMG=INPIMG(:).*(1-mask)+medn.*mask;
    OUTIMG = reshape(OUTIMG, SzY, SzX);
end