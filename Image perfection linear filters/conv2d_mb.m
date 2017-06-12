function OUTIMG=conv2d_mb(INPIMG,mask)
INPIMG = double(INPIMG);


% 2-D convolution by means of FFT

% Size of the mask should be an odd number

% Call OUTIMG=conv2d(INPIMG,mask);



[SzX SzY]=size(INPIMG);

INPIMG_sp=fft2(INPIMG);



[Szx Szy]=size(mask);

PSF=zeros(SzX,SzY); 

PSF(floor(SzX/2+1-(Szx-1)/2:SzX/2+1+(Szx-1)/2),floor(SzY/2+1-(Szy-1)/2:SzY/2+1+(Szy-1)/2))=mask;

PSF=fftshift(PSF);

fr_resp=fft2(PSF);



OUTIMG=real(ifft2(INPIMG_sp.*fr_resp));