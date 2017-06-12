function [OUTIMG,stderr]=dpcm1d_mb(INPIMG,mxm,BPP,P, NoiseType, NoiseParam)
% Simulation of DPCM with 1D prediction;
% Difference signal quantization on 2^(BPP-1) levels in the range [-mxm,mxm]
% with non-linear (P)-law pre-distortion;
% Additive or impulse noise in the difference error transmission channel;
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)
% Last modified March 27, 2005 
% Call : OUTIMG=dpcm1D(INPIMG,mxm,BPP,P);
INPIMG = double(INPIMG);
Q=2^round(BPP-1);
[SzX SzY]=size(INPIMG);
OUTIMG=zeros(SzX,SzY);
OUTIMG(:,1)=INPIMG(:,1);
OUTIMG_0=zeros(SzX,SzY);
OUTIMG_0(:,1)=INPIMG(:,1);
h=zeros(1,256);

switch NoiseType
case 'Additive noise'
    sigma=NoiseParam;
case 'Impulse noise'
    Perr=NoiseParam;
end

for y=2:SzY,
	diff=double(INPIMG(:,y))-0.95*OUTIMG_0(:,y-1);
	signdiff=sign(diff);
	absdiff=abs(diff); 
    absdiff=absdiff.*(absdiff<=mxm)+mxm*(absdiff>mxm);
	absdiff_quant=round(Q*((absdiff/mxm).^P));
	h=h+imghisto_mb(absdiff_quant')/(SzY-1);
    diff_quant=signdiff.*absdiff_quant;
    switch NoiseType
    case 'Additive noise'
      diff_quant_noise=diff_quant+sigma*randn(SzX,1);
    case 'Impulse noise'
      err=rand(SzX,1)<Perr; 
      noise=2*Q*(rand(SzX,1)-0.5);
      diff_quant_noise=(1-err).*diff_quant+err.*noise;
    end
   
    diff_quant_noise_r=mxm*sign(diff_quant_noise).*(abs(diff_quant_noise)/Q).^(1/P);
    diff_quant_r=mxm*sign(diff_quant).*(abs(diff_quant)/Q).^(1/P);
    OUTIMG_0(:,y)=round(0.95*OUTIMG_0(:,y-1)+diff_quant_r);
    OUTIMG(:,y)=round(0.95*OUTIMG(:,y-1)+diff_quant_noise_r);

% switch NoiseType
% case 'awgn'
%    	str=[';stdnoise=',num2str(sigma)];
% 	case 2
%    	str=[';Perr=',num2str(Perr)];
% 	end

% 	image(OUTIMG);axis equal;axis off;
% 	title(['Output image, mxm=',num2str(mxm),'; Q=',num2str(BPP),'; P=',num2str(P),str]);
% 	drawnow
end
% 
% image(OUTIMG);axis equal;axis off
% title(['Output image, mxm=',num2str(mxm),'; Q=',num2str(BPP),'; P=',num2str(P),str]);

h=h(1:Q+1)/SzX;hh=[h,h(2:Q+1)];
hh=hh/sum(hh);
H=-sum(hh.*log2(hh+eps));
[mn,stderr]=std2d_mb(double(INPIMG)-double(OUTIMG));
% figure(3);
% dispnorm(double(INPIMG)-double(OUTIMG),4);
% title(['Restoration error; StDev=',num2str(stderr)]);
% figure(4);
% bar(0:Q,h);axis tight;grid;
% title(['Histogram of abs. value of the quantized prediction error; Entropy=',num2str(H)]);
