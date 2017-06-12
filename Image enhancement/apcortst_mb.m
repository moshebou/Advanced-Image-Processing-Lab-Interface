function fr_resp=apcortst_mb(SzX,SzY,g)
% Test of frequency response function
% of the aperture-correction filter apertcor=delta+g*apmask
% SzX,SzY are dimensions of in space/frequency domain
% Call OUTIMG=apcortst(SzX,SzY,g);
apmask=[ 0 0 0 ; 0 1 0 ; 0 0 0] + g *[-0.1, -0.15, -0.1; -0.15, 1, -0.15; -0.1, -0.15, -0.1];
psf=zeros(SzX,SzY);
psf(SzX/2:SzX/2+2,SzY/2:SzY/2+2)=apmask;
clf
fr_resp=fftshift(fft2(psf));
x=0:2/SzY:1-2/SzY;
plot(x,abs(fr_resp(SzX/2+1,SzY/2+1:SzY)));
axis([min(x) max(x) 0 max(abs(fr_resp(SzX/2+1,SzY/2+1:SzY)))]);grid
title(['apcortst.m: Aperture correction frequency response, g=',num2str(g)])
ylabel('Frequency response');
xlabel('Normalized frequency')