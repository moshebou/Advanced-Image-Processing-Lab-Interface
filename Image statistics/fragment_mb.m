function OUTIMG=fragment(INPIMG,LX,LY)

% Interactive selection of an image fragment of LXxLY pixels
% OUTIMG=fragment(INPIMG,LX,LY)
clf


LxL=LX-fix((LX-1)/2)-1; LxR=LX-LxL;
LyL=LY-fix((LY-1)/2)-1; LyR=LY-LyL;

dispnorm(INPIMG,6);title('Select center of the window') 
[Y X]=ginput(1);
Y=fix(Y)
X=fix(X)


OUTIMG=INPIMG(X-LxL:X+LxR-1,Y-LyL:Y+LyR-1);

 

display1(OUTIMG);title('Selected fragment') 

 