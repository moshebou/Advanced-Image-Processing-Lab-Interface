function OUTSP=quanamph_mb(INPSP,Qamp,Qph,P)
% (P)-law quantization on Qamp levels and (P)-law reconstruction of magnitudes 
% and uniform quantization on Qph levels of phase angles 
% of DFT spectrum of an image
% Call OUTSPECTR=quanamph(INPSPECTR,Qamp,Qph,P)
amp=abs(INPSP);
mxamp=max(max(amp)); 
fi=angle(INPSP);
ampq=mxamp*((round((Qamp-1)*(amp/mxamp).^P))/(Qamp-1)).^(1/P);
fiq=(round((Qph-1)*(fi+pi)/(2*pi)))*(2*pi/(Qph-1))-pi;
OUTSP=ampq.*exp(i*fiq);





