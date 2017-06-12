function OUTIMG=lchstcom_mb(INPIMG,LX,LY,P)
INPIMG = double(INPIMG);
% L-p metrics deviation of histograms in a running window
% from the histogram of a fragment specified by the user 
% Image mirror extension by the size of the spatial window
% Call OUTIMG=lchstcom(INPIMG,Window Size X,Window Size Y,P);

Lx=round((LX-1)/2);

Ly=round((LY-1)/2);

[SzX SzY]=size(INPIMG);
clf
colormap(gray(256));
display1_mb(INPIMG);title('Select center of the window') 
coor=ginput(1);
X=round(coor(2));Y=round(coor(1));

frgm=INPIMG(X-Lx:X+Lx,Y-Ly:Y+Ly);
size(frgm)

subplot(221);display1_mb(INPIMG);title('Input image');drawnow
subplot(222);myimage_mb(frgm);title('Selected fragment');drawnow

histbuf=zeros(256,2*Ly+1);
for n=1:2*Lx+1
buf=frgm(n,:); buf=buf+256*([0:2*Ly]);
histbuf(buf+1)=histbuf(buf+1)+ones(1,2*Ly+1);
end

frgmhist=(sum(histbuf')').^P;
plotnorm_mb(frgmhist,2,2,4);title('Histogram.^P of the fragment');

OUTIMG=zeros(SzX,SzY);

imgext=img_ext_mb(INPIMG,Lx,Ly);

histbuf=zeros(256,SzY+2*Ly);

%Column histograms for the first row
for n=1:2*Lx+1,
	buf=imgext(n,:); buf=buf+256*([0:SzY+2*Ly-1]);
	histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY+2*Ly);
end

%FIRST HISTOGRAM IN THE FIRST ROW
	
h=sum(histbuf(:,1:2*Ly+1)')';

OUTIMG(1,1)=sqrt(sum((frgmhist-h.^P).^2));

% HISTOGRAMS FOR THE REST OF PIXELS IN THE ROW
for y=2:SzY,
	h=h-histbuf(:,y-1)+histbuf(:,y+LY-1);
	OUTIMG(1,y)=sqrt(sum((frgmhist-h.^P).^2));
end

%COLUMN HISTOGRAMS FOR THE REST OF IMAGE

for x=2:SzX,
	buf=imgext(x-1,:); buf=buf+256*([0:SzY+2*Ly-1]);
	histbuf(buf+1)=histbuf(buf+1)-ones(1,SzY+2*Ly);
	buf=imgext(2*Lx+1+x-1,:); buf=buf+256*([0:SzY+2*Ly-1]);
	histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY+2*Ly);

%FIRST HISTOGRAM IN THE Xth ROW
	h=sum(histbuf(:,1:2*Ly+1)')';
	OUTIMG(x,1)=sqrt(sum((frgmhist-h.^P).^2));

%HISTOGRAMS FOR THE REST OF PIXELS IN THE Xth ROW			
	for y=2:SzY,
	h=h-histbuf(:,y-1)+histbuf(:,y+LY-1);
	OUTIMG(x,y)=sqrt(sum((frgmhist-h.^P).^2));
	end

subplot(223);display1_mb(-OUTIMG);
title('Local histogram RMS deviation');drawnow
end
OUTIMG=255-UQUAN256_mb(OUTIMG);