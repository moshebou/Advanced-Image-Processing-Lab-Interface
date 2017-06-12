function OUTIMG=medn_er_mb(INPIMG,LX,LY,ERplus,ERminus)
INPIMG = double(INPIMG);
%**************************************************************
% Copyright: L. Yaroslavsky (yaro@eng.tau.ac.il) A. Mochenov
% Version 28.07.99
% Median over ER-Neighborhood
% LX,LY - is window size
% ERplus,ERminus - are boundaries of ER-neighborhood
% Image mirror extension by the size of the spatial window
% Call: OUTIMG=medn_er(INPIMG,LX,LY,ERminus,ERplus)
%**************************************************************

Lx=(LX-1)/2;
Ly=(LY-1)/2;
SzW=LX*LY;
[SzX SzY]=size(INPIMG);
klin=ones(SzY*SzX,1)*[1:SzW];
imgext=img_ext_mb(INPIMG,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding')';
% Computation of pixel's rank
center = INPIMG(:)*ones(1,SzW);
varrow=sort(nbhood, 2);
R=sum(nbhood<center,2);
Rleft=R-ERminus;

Rleft=Rleft.*(Rleft>=1)+(Rleft<1); 
Rleft=Rleft*ones(1, SzW);

Rright=R+ERplus;
Rright=Rright.*(Rright<=SzW)+SzW*(Rright>SzW); 
Rright=Rright*ones(1, SzW);

maskL=(klin>=Rleft); maskR=klin<=Rright; mask=maskL.*maskR;

	ernbh=varrow.*mask;
	sizeer=sum(mask,2);
	mask=sizeer*ones(1, SzW);
	ernbh= sort(ernbh, 2, 'descend');

	
OUTIMG=sum(ernbh.*(fix((mask+1)/2)==klin),2);
OUTIMG=reshape(OUTIMG, [SzY SzX]);

end 


      
% [mn RMSer]=std2d(OUTIMG-INPIMG);
% figure(2);
% display1(OUTIMG-INPIMG);
% title(['Difference between input and output images; RMS-error=',num2str(RMSer)]);
% drawnow
