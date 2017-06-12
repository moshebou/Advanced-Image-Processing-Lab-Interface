function OUTIMG=lcstanda(INPIMG,LX,LY,STD);



% LOCAL IMAGE STANDARDIZATION OVER WINDOW (LX=2Lx+1,LY=2Ly+1)

% Algorithm: OUTIMG=STD*(INPIMG-Local_Mean)./Local_STDeviation+128

% Image mirror extension by the size of the spatial window

% Call OUTIMG=lcstanda(INPIMG,LX,LY,STD);





[SzX SzY]=size(INPIMG);



lcstdv=lcstd(INPIMG,LX,LY);

lcmn=lcstdv(:,SzY+1:2*SzY);

lcstdv=lcstdv(:,1:SzY);

OUTIMG=round(STD*(INPIMG-lcmn)./lcstdv)+128;

OUTIMG=OUTIMG.*(OUTIMG>0);

OUTIMG=OUTIMG.*(OUTIMG<256)+255*ones(SzX,SzY).*(OUTIMG>255);



display1(OUTIMG);

title(['lcstanda.m:Output image, LX*LY=',num2str(LX),'*',num2str(LY)]);

drawnow

