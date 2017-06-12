function OUTIMG=mean_ev_mb(INPIMG,LX,LY,evpos,evneg)
% MEAN over EV-neighborhood in the window LX*LY;
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il) 
% Call  OUTIMG=mean_Ev(INPIMG,LX,LY,evpos,evneg);
INPIMG = double(INPIMG);
Lx=(LX-1)/2;
Ly=(LY-1)/2;
[SzX SzY]=size(INPIMG);
imgext=img_ext_mb(INPIMG,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding')';
% LOCAL HISTOGRAM 
SzW=LX*LY;
center = INPIMG(:)*ones(1,SzW);
centerpos = (center + evpos);
centerneg = center - evneg;
evnbh=(nbhood<=centerpos).*(nbhood>=centerneg);
sizeev=sum(evnbh,2);
EVnbh=nbhood.*evnbh;
OUTIMG=sum(EVnbh,2)./sizeev;
OUTIMG=reshape(OUTIMG, [SzY SzX]);
end



 


	