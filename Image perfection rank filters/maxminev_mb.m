function OUTIMG=maxminev_mb(INPIMG,LX,LY,evpos,evneg)

INPIMG = double(INPIMG);

% MAX&MIN over EV neighborhood in window LX*LY

% evpos,evneg are boundaries of EV-neighborhood

% OUTIMG=[MAX_EV MIN_EV];

% Call OUTIMG=maxminev(INPIMG,LX,LY,evpos,evneg);



clf;



Lx=(LX-1)/2;

Ly=(LY-1)/2;





[SzX SzY]=size(INPIMG);

OUTIMG=[INPIMG INPIMG INPIMG];



imgext=img_ext_mb(INPIMG,Lx,Ly);



% LOCAL HISTOGRAM 



for X0=1:SzX,



	% FORMATION OF NEIGHBORHOOD MATRIX



	nbhood=zeros(LX*LY,SzY);

 

	Y=1:SzY;

	for y=-Ly:Ly,

		nbhood((2*Lx+1)*(Ly+y)+1:(2*Lx+1)*(Ly+y+1),Y)=imgext(X0:X0+2*Lx,Y+Ly+y);

	end


	centerpos=kron(INPIMG(X0,:)+evpos,ones(LX*LY,1));

	centerneg=kron(INPIMG(X0,:)-evneg,ones(LX*LY,1));

	evnbh=(nbhood<centerpos).*(nbhood>centerneg);

	%sizeev=sum(evnbh);



	EVnbhmax=nbhood.*(evnbh);

	EVnbhmin=nbhood./(evnbh+eps);

	OUTIMG(X0,:)=[max(EVnbhmax) min(EVnbhmin) max(EVnbhmax)-min(EVnbhmin)];



	display1_mb(OUTIMG);

	title(['maxminev.m:MaxEV, MinEV and Max-MinEV images; LX*LY=',num2str(LX),'*',num2str(LY),'; EVpl=',num2str(evpos),'; EVmn=',num2str(evneg)]);

	drawnow;

end
 





	