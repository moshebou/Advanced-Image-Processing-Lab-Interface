function OUTIMG=lcmxmnst_mb(INPIMG,LX,LY)
INPIMG = double(INPIMG);
% LOCAL IMAGE STANDARDIZATION by max_min OVER WINDOW (2Lx+1,2Ly+1)
% Algorithm: OUTIMG=255*(INPIMG-LCMIN)./(LCMAX-LCMIN)+128
% Image mirror extension by the size of the spatial window
% Call  OUTIMG=lcmxmnst(INPIMG,LX,LY);
Lx=(LX-1)/2;Ly=(LY-1)/2;
[SzX SzY]=size(INPIMG);
OUTIMG=INPIMG;
% imgext=img_ext_mb(INPIMG,Lx,Ly);
imgext=img_ext_mb(INPIMG,Ly,Lx);
for X0=1:SzX,
	% FORMATION OF NEIGHBORHOOD MATRIX
    nbhood=zeros((2*Lx+1)*(2*Ly+1),SzY);
	Y=1:SzY;	
    for y=-Ly:Ly
        nbhood((2*Lx+1)*(Ly+y)+1:(2*Lx+1)*(Ly+y+1),Y)=imgext(X0:X0+2*Lx,Y+Ly+y);
    end
LMIN=min(nbhood);LMAX=max(nbhood);
OUTIMG(X0,:)=round(255*((OUTIMG(X0,:)-LMIN)./(LMAX-LMIN)));
%OUTIMG(X0,:)=round(255*((OUTIMG(X0,:)-LMIN)./(LMAX-LMIN)));

end



% OUTIMG=round(255*OUTIMG/max(max(OUTIMG)));

 





	