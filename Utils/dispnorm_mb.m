function dspl=dispnorm(INPIMG,g)
% 2-D signal display with normalization by mean value and standard deviation
% g- is a parameter that defines ratio of the display range 0-255
% to the signal standard deviation 
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il) 
% Call dispnorm(INPIMG,g)

[SzX SzY]=size(INPIMG);
Mean=mean(mean(INPIMG));		
stdv=sqrt(mean(mean((INPIMG-Mean).^2)))+eps;
dspl=round(255*(INPIMG-Mean)/(g*stdv))+128;
dspl=(dspl>=0).*dspl;
dspl=(dspl<=255).*dspl+255*ones(SzX,SzY).*(dspl>255);
myimage(dspl);

%title(['dispnorm.m: Input image, g=',num2str(g)])
