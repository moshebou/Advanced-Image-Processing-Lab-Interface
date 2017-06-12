function [h1, h2, OUTIMG, h3]=histosta_mb(INPIMG1,INPIMG2)
INPIMG1 = double(INPIMG1);
INPIMG2 = double(INPIMG2);
% Standardization of image histogram; 
% Histogram of INPIMG1 is made identical to histogram of INPIMG2
% Call OUTIMG=histosta(INPIMG1,INPIMG2);

 [SzX SzY]=size(INPIMG1);
% histbuf=zeros(256,SzY);
% for n=1:SzX
%     try
% buf=INPIMG1(n,:); buf=buf+256*([0:SzY-1]);
% histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY);
%     catch
%         s=0;
%     end
% end
% h1=sum(histbuf'); 
h1= histc(INPIMG1(:), [0 :255]);
%plotnorm_mb(h1,2,2,3);title('Input image histogram');drawnow
cumh=cumsum(h1);lut1=255*cumh/cumh(end);



% histbuf=zeros(256,SzY);
% for n=1:SzX
% buf=INPIMG2(n,:); buf=buf+256*([0:SzY-1]);
% histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY);
% end
% h2=sum(histbuf'); 
h2= histc(INPIMG2(:), [0 :255]);
%plotnorm_mb(h2,2,2,4);title('Reference image histogram');drawnow

cumh=cumsum(h2);lut2=255*cumh/cumh(end);
lut = zeros(1,256);
for q=1:256,
lut(q)= sum(lut2<lut1(q));%+1;
end



OUTIMG=lutable_mb(INPIMG1,lut);

%subplot(221);display1_mb(OUTIMG);



histbuf=zeros(256,SzY);

for n=1:SzX
try
buf=OUTIMG(n,:); 
buf=buf+256*([0:SzY-1]);
histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY);
catch
    s = 0
end
end



h3=sum(histbuf ,2); 

%plotnorm_mb(h3,2,2,3);title('Transformed image histogram');drawnow