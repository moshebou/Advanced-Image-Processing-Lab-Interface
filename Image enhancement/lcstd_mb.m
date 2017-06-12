function OUTIMG=lcstd_mb(INPIMG,LX,LY)
INPIMG = double(INPIMG);
% LOCAL MEAN AND STANDARD DEVIATION OVER WINDOW (LX=2Lx+1,LY=2Ly+1)
% Image mirror extension by the size of the spatial window
% OUTIMG=[lcstd lcmean];
% Call OUTIMG=lcstd(INPIMG,LX,LY);
[SzX SzY]=size(INPIMG);
% LOCAL STD
INP_ext=img_ext_mb(INPIMG,fix(LY/2),fix(LX/2));
lcmean=conv2(INP_ext,ones(LX,LY)/(LX*LY),'same');
lcvar= conv2((INP_ext-lcmean).^2,ones(LX,LY)/(LX*LY),'same');
lcstd=sqrt(lcvar);
OUTIMG=[lcstd(fix(LX/2)+1:SzX+fix(LX/2),fix(LY/2)+1:SzY+fix(LY/2)) lcmean(fix(LX/2)+1:SzX+fix(LX/2),fix(LY/2)+1:SzY+fix(LY/2))];	