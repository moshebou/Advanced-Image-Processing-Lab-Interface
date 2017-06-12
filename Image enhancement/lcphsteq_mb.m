function OUTIMG=lcphsteq_mb(INPIMG_in,LX,LY,P)

% P-equalization of running histograms 
% Image mirror extension by the size of the spatial window
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call  OUTIMG=lcphsteq(INPIMG,Window Size X,Window Size Y,P);



INPIMG = double(INPIMG_in.im);
Lx=round((LX-1)/2);

Ly=round((LY-1)/2);

[SzX SzY]=size(INPIMG);


OUTIMG=INPIMG;
imgext=img_ext_mb(INPIMG,Ly,Lx);

histbuf=zeros(256,SzY+2*Ly);

%Column histograms for the first row
for n=1:2*Lx+1,
	buf=imgext(n,:); buf=buf+256*([0:SzY+2*Ly-1]);
	histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY+2*Ly);
end

%FIRST HISTOGRAM IN THE FIRST ROW
	
h=sum(histbuf(:,1:2*Ly+1)')'; 

hp=h.^P; hp=hp/sum(hp); 

centrpix=INPIMG(1,1);
OUTIMG(1,1)=255*(sum(hp(1:centrpix)));

% HISTOGRAMS FOR THE REST OF PIXELS IN THE ROW
for y=2:SzY,
	frgmhist=h;
	h=h-histbuf(:,y-1)+histbuf(:,y+LY-1);

	hp=h.^P; hp=hp/sum(hp); centrpix=INPIMG(1,y); 

	OUTIMG(1,y)=255*(sum(hp(1:centrpix)));
end

%COLUMN HISTOGRAMS FOR THE REST OF IMAGE

for x=2:SzX,
	buf=imgext(x-1,:); buf=buf+256*([0:SzY+2*Ly-1]);
	histbuf(buf+1)=histbuf(buf+1)-ones(1,SzY+2*Ly);
	buf=imgext(2*Lx+1+x-1,:); buf=buf+256*([0:SzY+2*Ly-1]);
	histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY+2*Ly);

%FIRST HISTOGRAM IN THE Xth ROW
	h=sum(histbuf(:,1:2*Ly+1)')';

	hp=h.^P; hp=hp/sum(hp); centrpix=INPIMG(2,y); 
        

	OUTIMG(2,y)=255*(sum(hp(1:centrpix)));
	
%HISTOGRAMS FOR THE REST OF PIXELS IN THE Xth ROW			
	for y=2:SzY,
	frgmhist=h;
	h=h-histbuf(:,y-1)+histbuf(:,y+LY-1);

	hp=h.^P; hp=hp/sum(hp); centrpix=INPIMG(x,y); 
    

	OUTIMG(x,y)=255*(sum(hp(1:centrpix)));
    
	end

   

end
