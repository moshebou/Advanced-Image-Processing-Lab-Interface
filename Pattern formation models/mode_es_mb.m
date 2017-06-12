function OUTIMG=mode_es_mb(INPIMG,LY,LX,axes, iteration)
% MOD(ES_NBH) in a running window
% LX,LY - size of the ES neighborhood;
% Displ - display flag;Output image is displayed if Displ=1;
% Call OUTIMG=mode_es(INPIMG,Window Size X,Window Size Y);
Lx=ceil((LX-1)/2);
Ly=ceil((LY-1)/2);
[SzX SzY]=size(INPIMG);
OUTIMG=INPIMG;
 imgext=img_ext_mb(INPIMG,ceil(Ly),ceil(Lx));
% im_col = im2col(imgext, [LY, LX], 'sliding');
% im_hist = histc(im_col, [0:255]);
% [val, pos] = max(im_hist);
% OUTIMG = reshape(pos, size(INPIMG));
histbuf=zeros(256,SzY+2*Ly);
%Column histograms for the first row
for n=1:2*Lx+1,
	buf=imgext(n,:); 
    buf=buf+256*([0:SzY+2*Ly-1]);
	histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY+2*Ly);
end

%FIRST HISTOGRAM IN THE FIRST ROW

	

h=sum(histbuf(:,1:2*Ly+1)')';

[Y,I]=max(h);

OUTIMG(1,1)=I;



% HISTOGRAMS FOR THE REST OF PIXELS IN THE ROW

for y=2:SzY,

	h=h-histbuf(:,y-1)+histbuf(:,y+LY-1);

   [Y,I]=max(h);

   OUTIMG(1,y)=I;

end



%COLUMN HISTOGRAMS FOR THE REST OF IMAGE



for x=2:SzX,

	buf=imgext(x-1,:); buf=buf+256*([0:SzY+2*Ly-1]);

	histbuf(buf+1)=histbuf(buf+1)-ones(1,SzY+2*Ly);

	buf=imgext(2*Lx+1+x-1,:); buf=buf+256*([0:SzY+2*Ly-1]);

	histbuf(buf+1)=histbuf(buf+1)+ones(1,SzY+2*Ly);



%FIRST HISTOGRAM IN THE Xth ROW

   h=sum(histbuf(:,1:2*Ly+1)')';

   [Y,I]=max(h);

	OUTIMG(x,1)=I;



%HISTOGRAMS FOR THE REST OF PIXELS IN THE Xth ROW			

	for y=2:SzY,

      h=h-histbuf(:,y-1)+histbuf(:,y+LY-1);

      [Y,I]=max(h);

      OUTIMG(x,y)=I-1;

	end



if ( mod(x,10) == 0 )
imshow(uint8(OUTIMG), 'parent', axes);
% display1(OUTIMG);

title(['MODE\_ES over the window ',num2str(LX),'x',num2str(LY), ' iteration number ' num2str(iteration)], 'parent', axes, 'fontweight', 'bold');drawnow

end



end

imshow(uint8(OUTIMG), 'parent', axes);

title(['MODE\_ES over the window ',num2str(LX),'x',num2str(LY), ' iteration number ' num2str(iteration)], 'parent', axes, 'fontweight', 'bold');