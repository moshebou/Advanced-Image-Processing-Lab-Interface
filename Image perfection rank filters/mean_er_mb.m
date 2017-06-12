function OUTIMG=mean_er_mb(INPIMG,LX,LY,ERplus,ERminus)
INPIMG = double(INPIMG);
% Mean over ER-neighborhood
% LX,LY - window size
% ERplus,ERminus - spread parameters of ER-neighborhood 
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  % Call  OUTIMG=mean_er(INPIMG,LX,LY,ERplus,ERminus);

Lx=(LX-1)/2;
Ly=(LY-1)/2;
SzW=LX*LY;
[SzX SzY]=size(INPIMG);
klin=ones(SzY*SzX,1)*[1:SzW];
imgext=img_ext_mb(INPIMG,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding')';
% Computation of pixel's rank
center = INPIMG(:)*ones(1,SzW);
varraw=sort(nbhood, 2);
R=sum(nbhood<center,2);
Rleft=R-ERminus;

Rleft=Rleft.*(Rleft>=1)+(Rleft<1); 
Rleft=Rleft*ones(1, SzW);

Rright=R+ERplus;
Rright=Rright.*(Rright<=SzW)+SzW*(Rright>SzW); 
Rright=Rright*ones(1, SzW);

maskL=(klin>=Rleft); maskR=klin<=Rright; mask=maskL.*maskR;
OUTIMG=reshape(SzW*mean(varraw.*mask,2)./sum(mask,2), [SzY SzX]);

end