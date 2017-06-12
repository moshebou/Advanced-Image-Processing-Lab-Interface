function OUTIMG=size_ev_mb(INPIMG,Lx,Ly,evpos,evneg)

% Size of EV neighborhood over (2Lx+1)*(2)Ly+1) window
% evpos,evneg -boundaries of EV-neighborhood
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call  OUTIMG=size_Ev(INPIMG,Lx,Ly,evpos,evneg);
INPIMG = double(INPIMG);
clf
LX=2*Lx+1;
LY=2*Ly+1;

[SzX SzY]=size(INPIMG);
OUTIMG=zeros(SzX,SzY);

imgext=img_ext_mb(INPIMG,Lx,Ly);

% LOCAL HISTOGRAM 

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

	OUTIMG(X0,:)=sum(evnbh);

	   	display1_mb(OUTIMG);
		drawnow;
		title(['size\_ev: LX=',num2str(LX),'; LY=',num2str(LY),'; EVpl=',num2str(evpos),'; EVmn=',num2str(evneg)]);

end
%OUTIMG=OUTIMG*255/max(max(OUTIMG));


 


	