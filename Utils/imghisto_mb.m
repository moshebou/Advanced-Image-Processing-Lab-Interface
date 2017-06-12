function OUT=imghisto_mb(INPIMG)
% Image histogram
% Call OUT=imghisto(INPIMG);
[SzX SzY]=size(INPIMG);
histbuf=zeros(256,SzY);
for n=1:SzX
buf=INPIMG(n,:); buf=buf+256*([0:SzY-1]);
histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY);
end
OUT=sum(histbuf'); 
%plotnorm(OUT);