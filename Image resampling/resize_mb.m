function OUTIMG=resize(INPIMG,StepX,StepY,method)
INPIMG = double(INPIMG);
% Image/signal zoom StepX and StepY
% using either no (method=0) or nearest neighbor ('nn'), or 'bilinear' or 'bicubic' interpolation.
% Call OUTIMG=resize(INPIMG,StepX,StepY,'method');

 
[SzX SzY]=size(INPIMG);
if SzX==1
    INPIMG=[INPIMG;INPIMG;INPIMG];
    StepX=1;
elseif SzY==1
    INPIMG=[INPIMG INPIMG INPIMG];
    StepY=1;
end
[SzX SzY]=size(INPIMG);

if method==0,interp=zeros(StepX,StepY);interp(1,1)=1;OUTIMG=kron(INPIMG,interp);
else   
[Xint,Yint]=meshgrid(1:1/StepX:SzX,1:1/StepY:SzY);
%keyboard
%X=1:SzX; Y=(1:SzY)';
%Xint=1:1/StepX:SzX;
%Yint=(1:1/StepY:SzY)';

OUTIMG=(interp2(INPIMG',Xint,Yint,method))';
end


