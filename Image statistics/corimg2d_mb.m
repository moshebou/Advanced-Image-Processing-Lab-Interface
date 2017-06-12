function corr=corimg2d_mb(INPIMG)
INPIMG = double(INPIMG);
% 1D autocorrelation function of an image: 
% inverse FFT of averaged spectra of image columns
% Call corr=corimg1d(INPIMG);
INPIMG=INPIMG-mean(INPIMG(:));
spimg=(abs(fft2(INPIMG))).^2;
corr=fftshift(abs(ifft2(spimg)));
