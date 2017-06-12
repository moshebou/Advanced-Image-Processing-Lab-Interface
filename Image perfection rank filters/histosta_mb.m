function OUTIMG=histosta(INPIMG1,INPIMG2);
% Standardization of image histogram; 
% Histogram of INPIMG1 is made identical to histogram of INPIMG2
% Call OUTIMG=histosta(INPIMG1,INPIMG2);

clf
subplot(221);display1(INPIMG1);title('Input image');
subplot(222);display1(INPIMG2);title('Reference image');
[SzX SzY]=size(INPIMG1);

histbuf=zeros(256,SzY);
for n=1:SzX
buf=INPIMG1(n,:); buf=buf+256*([0:SzY-1]);
histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY);
end

h1=sum(histbuf'); 
plotnorm(h1,2,2,3);title('Input image histogram');drawnow
cumh=cumsum(h1);lut1=255*cumh/max(cumh);

histbuf=zeros(256,SzY);
for n=1:SzX
buf=INPIMG2(n,:); buf=buf+256*([0:SzY-1]);
histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY);
end

h2=sum(histbuf'); 
plotnorm(h2,2,2,4);title('Reference image histogram');drawnow
cumh=cumsum(h2);lut2=255*cumh/max(cumh);

for q=1:256,
lut(q)=sum(lut2<=lut1(q))+1;
end

OUTIMG=lutable(INPIMG1,lut);
subplot(221);display1(OUTIMG);

histbuf=zeros(256,SzY);
for n=1:SzX
buf=OUTIMG(n,:); buf=buf+256*([0:SzY-1]);
histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY);
end

h3=sum(histbuf'); 
plotnorm(h3,2,2,3);title('Transformed image histogram');drawnow