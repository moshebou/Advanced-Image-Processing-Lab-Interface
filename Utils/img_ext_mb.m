function OUTIMG=img_ext_mb(INPIMG,Ly,Lx)
% Image extension by mirror reflection from its borders
% by Lx,Ly pixels from the corresponding sides
% Call OUTIMG=img_ext(INPIMG,Lx,Ly);
[SzX,SzY]=size(INPIMG);
OUTIMG=[fliplr(INPIMG(:,1:Ly)),INPIMG,fliplr(INPIMG(:,SzY-Ly+1:SzY))];
OUTIMG=[flipud(OUTIMG(1:Lx,:));OUTIMG;flipud(OUTIMG(SzX-Lx+1:SzX,:))];
%display(OUTIMG);title('img_ext');