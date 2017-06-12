function OUTIMG=dpcm2d_mb(INPIMG,mxm,BPP,P, NoiseType, NoiseParam)
% Simulation of DPCM with 2D prediction
% Difference signal quantization on 2^(BBP-1) levels in the range [-mxm,mxm]
% with non-linear (P)-law pre-distortion
% Additive or impulse noise in the prediction error transmission channel 
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il) 
% Call OUTIMG=dpcm1D(INPIMG,mxm,BPP,P);
INPIMG = double(INPIMG);
Q=2^round(BPP-1);
[SzX SzY]=size(INPIMG);
OUTIMG=zeros(SzX,SzY);
OUTIMG(:,1)=INPIMG(:,1);

switch NoiseType
case 'Additive noise'
    sigma=NoiseParam;
case 'Impulse noise'
    Perr=NoiseParam;
end



% First row
for y=2:SzY,
	diff=INPIMG(1,y)-OUTIMG(1,y-1);
	signdiff=sign(diff);
	absdiff=abs(diff); 
	if absdiff>mxm, absdiff=mxm;end
	absdiff_quant=round(Q*((absdiff/mxm).^P));
	diff_quant=signdiff.*absdiff_quant;
    switch NoiseType
    case 'Additive noise'
      diff_quant_noise=diff_quant+sigma*randn(1,1);
    case 'Impulse noise'
      err=rand<Perr;
      noise=2*Q*(rand-0.5);
      diff_quant_noise=(1-err)*diff_quant+err*noise;
   end
   diff_quant_noise=mxm*sign(diff_quant_noise).*(abs(diff_quant_noise)/Q).^(1/P);
	OUTIMG(1,y)=round(OUTIMG(1,y-1)+diff_quant_noise);
end

% Remaining rows

for x=2:SzX,
	for y=2:SzY-1,
	
	diff=INPIMG(x,y)-0.3*(OUTIMG(x,y-1)+OUTIMG(x-1,y))-0.2*(OUTIMG(x-1,y-1)+OUTIMG(x-1,y+1));
	signdiff=sign(diff);
	absdiff=abs(diff); if absdiff>mxm, absdiff=mxm;end
	absdiff_quant=round(Q*((absdiff/mxm).^P));
	diff_quant=signdiff.*absdiff_quant;
    switch NoiseType
    case 'Additive noise'
      diff_quant_noise=diff_quant+sigma*randn(1,1);
   case 'Impulse noise'
      err=rand<Perr;
      noise=2*Q*(rand-0.5);
      diff_quant_noise=(1-err)*diff_quant+err*noise;
   end
   diff_quant_noise=mxm*sign(diff_quant_noise).*(abs(diff_quant_noise)/Q).^(1/P);
	OUTIMG(x,y)=round(0.3*(OUTIMG(x,y-1)+OUTIMG(x-1,y))+0.2*(OUTIMG(x-1,y-1)+OUTIMG(x-1,y+1))+diff_quant_noise);
	end

	% Last pixel in row

	diff=INPIMG(x,SzY)-0.35*(OUTIMG(x,SzY-1)+OUTIMG(x-1,SzY))-0.3*OUTIMG(x-1,SzY-1);
	
	signdiff=sign(diff);
	absdiff=abs(diff); if absdiff>mxm, absdiff=mxm;end
	absdiff_quant=round(Q*((absdiff/mxm).^P));
	diff_quant=signdiff.*absdiff_quant;
    switch NoiseType
    case 'Additive noise'
      diff_quant_noise=diff_quant+sigma*randn(1,1);
   case 'Impulse noise'
       a = rand;
      err=a<Perr;
      noise=2*Q*(a-0.5);
      diff_quant_noise=(1-err)*diff_quant+err*noise;
   end
   diff_quant_noise=mxm*sign(diff_quant_noise).*(abs(diff_quant_noise)/Q).^(1/P);
   OUTIMG(x,SzY)=round(0.35*(OUTIMG(x,SzY-1)+OUTIMG(x-1,SzY))+0.3*OUTIMG(x-1,SzY-1)+diff_quant_noise);

end

% stderr=std2(INPIMG-OUTIMG);
% figure(3);colormap(gray(256));
% dispnorm(INPIMG-OUTIMG,6);
% title(['Coding/decoding error, STDerr=',num2str(stderr)]);
	