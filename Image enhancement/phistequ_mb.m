function OUTIMG=phistequ_mb(INPIMG,P)
INPIMG = double(INPIMG);
% Image histogram p-equalization

% For negative P, uses smoothed histogram

% Call OUTIMG=phistequ(INPIMG,P);






[SzX SzY]=size(INPIMG);

mask=[1 1 1 1 1];

histbuf=zeros(256,SzY);

for n=1:SzX

buf=INPIMG(n,:); buf=buf+256*([0:SzY-1]);

histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY);

end



h=sum(histbuf'); 





if P>=0, hp=h.^P; 

	else h=conv2(h,mask,'same');

	hp=h.^(-P); hp=hp.^(-1); end	



lut=cumsum(hp);	lut=round(255*lut/max(lut));





OUTIMG=lutable_mb(INPIMG,lut);

