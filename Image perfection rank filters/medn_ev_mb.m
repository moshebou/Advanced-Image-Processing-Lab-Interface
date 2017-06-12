function OUTIMG=medn_ev_mb(INPIMG,LX,LY,evpos,evneg)
INPIMG = double(INPIMG);
% Median over EV-nbh in the window (2Lx+1)(2Ly+1) 
% EVplus,EVminus - boundaries of EV-neighborhood
% If Displ=1, image is displayed during processing;
% Otherwise it is displayed at the end of processing
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call  OUTIMG=medn_ev(INPIMG,Lx,Ly,EVplus,EVminus,Displ);

Lx=(LX-1)/2;
Ly=(LY-1)/2;
SzW = LX*LY;
[SzX SzY]=size(INPIMG);
klin=ones(SzY*SzX,1)*[1:SzW];
imgext=img_ext_mb(INPIMG,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding')';
% LOCAL HISTOGRAM 

center = INPIMG(:)*ones(1,SzW);
centerpos = (center + evpos);
centerneg = center - evneg;
evnbh=(nbhood<=centerpos).*(nbhood>=centerneg);
sizeev=sum(evnbh,2);
mask=sizeev*ones(1, LX*LY);
EVnbh=nbhood.*evnbh;
EVnbh= sort(EVnbh, 2,'descend');
OUTIMG=sum(EVnbh.*(fix((mask+1)/2)==klin),2);
OUTIMG=reshape(OUTIMG, [SzY SzX]);


end 

 


	