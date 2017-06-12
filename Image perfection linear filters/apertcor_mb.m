function OUTIMG=apertcor_mb(INPIMG,g,Thr)
INPIMG = double(INPIMG);
% Aperture correction by unsharp masking
% with restriction of difference signal by magnitude of Thr
% OUTIMG=INPIMG+g*conv2(INPIMG,apmask)
% Call OUTIMG=apertcor(INPIMG,g,Thr);
[SzX SzY]=size(INPIMG);
apmask=[-0.1 -0.15 -0.1;-0.15 1 -0.15;-0.1 -0.15 -0.1];
INPIMG=img_ext_mb(INPIMG,1,1);
dif=conv2(INPIMG,apmask,'same');
sign_dif=sign(dif);
abs_dif=abs(dif);
abs_dif=abs_dif.*(abs_dif<=Thr)+Thr*(abs_dif>Thr);
dif=abs_dif.*sign_dif;
OUTIMG=INPIMG+g*dif;
OUTIMG=OUTIMG(2:SzX+1,2:SzY+1);
OUTIMG=srezka_mb(OUTIMG);


% %subplot(122);
% 
% myimage_mb([INPIMG(2:SzX+1,2:SzY+1) OUTIMG]);
% 
% title(['apertcor.m: Input and output images; g=',num2str(g)])

