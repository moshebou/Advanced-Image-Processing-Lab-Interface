function OUTIMG=std_ev_mb(INPIMG,LX,LY,evpos,evneg)
% STD over EV neighborhood
% LX,LY - size of the window
% evpos, evneg - boundaries of the EV-neighborhood
% Call OUTIMG=std_ev(INPIMG,LX,LY,evpos,evneg);
INPIMG = double(INPIMG);
clf;

Lx=(LX-1)/2;

Ly=(LY-1)/2;



[SzX SzY]=size(INPIMG);

OUTIMG=zeros(SzX,SzY);



imgext=img_ext_mb(INPIMG,Lx,Ly);



% LOCAL HISTOGRAM EQUALIZATION



for X0=1:SzX,



	% FORMATION OF NEIGHBORHOOD MATRIX



	nbhood=zeros((2*Lx+1)*(2*Ly+1),SzY);

 

	Y=1:SzY;

	for y=-Ly:Ly,



		nbhood((2*Lx+1)*(Ly+y)+1:(2*Lx+1)*(Ly+y+1),Y)=imgext(X0:X0+2*Lx,Y+Ly+y);



	end





	centerpos=kron(INPIMG(X0,:)+evpos,ones((2*Lx+1)*(2*Ly+1),1));

	centerneg=kron(INPIMG(X0,:)-evneg,ones((2*Lx+1)*(2*Ly+1),1));

	evnbh=(nbhood<centerpos).*(nbhood>centerneg);

	sizeev=sum(evnbh);

	EVnbh=nbhood.*evnbh;



	OUTIMG(X0,:)=std(EVnbh)./sizeev;

	display1_mb(OUTIMG);

	title(['std\_ev.m:Output image; LX*LY=',num2str(LX),'*',num2str(LY),'; EVpl=',num2str(evpos),'; EVmn=',num2str(evneg)]);

	drawnow;

end

OUTIMG=255*OUTIMG/max(max(OUTIMG));
 





	