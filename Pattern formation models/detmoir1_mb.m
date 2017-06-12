function OUTIMG=detmoir1_mb(INPIMG,thr)

% Automatic detection of noise components in accumulated 1-D spectrum
% thr is a parameter for detecting moire peaks; 0<thr<1 (usually about 0.05)
% thr is an allowed increment of spectrum samples;
% it is used for detection nonmonotonicity  OUT(x+1)>(1+thr)*OUT(x), 
% The program uses subroutine momotone.m
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call OUTIMG=detmoir1(INPIMG,thr)

[SzX SzY]=size(INPIMG);

sp=fft(INPIMG');
sp2=abs(sp).^2;
sp1d=(sum(sp2')).^0.1;
%plotnorm_mb(sp1d(1:SzX/2+1),3,1,2);


% Moire detection

sp1dsm=monotone_mb(sp1d(1:SzX/2+1),thr);

%OUTIMG=sp1d(1:SzX/2+1)-sp1dsm;
OUTIMG=sp1d(1:SzX/2+1).^10-sp1dsm.^10;
%OUTIMG=sp1d(1:SzX/2+1).*mask;

mm=max(OUTIMG); if mm==0, mm=1;end


