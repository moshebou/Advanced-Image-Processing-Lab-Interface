function OUTIMG=invapert_mb(INPIMG, g, Thr)
INPIMG = double(INPIMG);
% Inversion of aperture distortions of
% image scanning/reconstruction systems with a rectangular scanning aperture
% Thr is a threshold on the correction addition to INPIMG 
% Call OUTIMG=invapert(INPIMG,Thr);

%---- Formation scanner/display frequency response correction term----- 
INPIMG=img_ext_mb(INPIMG,1,1);
[SzX SzY]=size(INPIMG);
X=(1:SzX/2)/SzX; 
cor_fr_resp_sc_X=(pi*X)./sin(pi*X);
cor_fr_resp_sc_X=[cor_fr_resp_sc_X(SzX/2:-1:1) 1 cor_fr_resp_sc_X(1:SzX/2-1)];
Y=(1:SzY/2)/SzY; 
cor_fr_resp_sc_Y=(pi*Y)./sin(pi*Y);
cor_fr_resp_sc_Y=[cor_fr_resp_sc_Y(SzY/2:-1:1) 1 cor_fr_resp_sc_Y(1:SzY/2-1)];
cor_fr_resp_sc=kron(cor_fr_resp_sc_Y,cor_fr_resp_sc_X');
cor_fr_resp_sc=cor_fr_resp_sc.^2;
cor_fr_resp_sc=fftshift(cor_fr_resp_sc);
% ------------------------------Correction----------------------------
sp=fft2(INPIMG);
sp_corr=sp.* cor_fr_resp_sc;
OUTIMG=real(ifft2(sp_corr));
dif=OUTIMG-INPIMG;
sign_dif=sign(dif);
abs_dif=abs(dif);
abs_dif=abs_dif.*(abs_dif<=Thr)+Thr*(abs_dif>Thr);
dif=abs_dif.*sign_dif;
OUTIMG=INPIMG+g*dif;
OUTIMG=OUTIMG(2:SzX-1,2:SzY-1);
OUTIMG=srezka_mb(OUTIMG);
OUTIMG=round(OUTIMG);