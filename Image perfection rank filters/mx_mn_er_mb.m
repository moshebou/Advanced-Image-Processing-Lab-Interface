function OUTIMG=mx_mn_er_mb(INPIMG,LX,LY,ERplus,ERminus)

INPIMG = double(INPIMG);

% MAX-MIN over ER-neighborhood

% ERplus,ERminus - parameters of ER neighborhood

% Image mirror extension by the size of the spatial window

% Call OUTIMG=OUTIMG=mx_mn_er(INPIMG,LX,LY,ERplus,ERminus);



Lx=(LX-1)/2;

Ly=(LY-1)/2;

SzW=LX*LY;



[SzX SzY]=size(INPIMG);



klin=kron([1:SzW]',ones(1,SzY));



OUTIMG=[INPIMG INPIMG INPIMG];



imgext=img_ext_mb(INPIMG,Lx,Ly);



% Computation of pixel's rank



for X0=1:SzX,



	% FORMATION OF NEIGHBORHOOD MATRIX



	nbhood=zeros((2*Lx+1)*(2*Ly+1),SzY);

 

	Y=1:SzY;

	for y=-Ly:Ly,

		nbhood((2*Lx+1)*(Ly+y)+1:(2*Lx+1)*(Ly+y+1),Y)=imgext(X0:X0+2*Lx,Y+Ly+y);

	end



	varraw=sort(nbhood);

	center=kron(INPIMG(X0,:),ones(SzW,1));



	R=sum(nbhood<center);



	Rleft=R-ERminus;

	Rleft=Rleft.*(Rleft>=1)+ones(size(Rleft)).*(Rleft<1); 

	Rleft=kron(Rleft,ones(SzW,1));



	Rright=R+ERplus;

	Rright=Rright.*(Rright<=SzW)+SzW*ones(size(Rright)).*(Rright>SzW); 

	Rright=kron(Rright,ones(SzW,1));



	maskL=(klin<=Rleft); maskR=klin<=Rright; 



	OUTIMG(X0,:)=[max(varraw.*maskR) max(varraw.*maskL) max(varraw.*maskR)-max(varraw.*maskL)];



	display1_mb(OUTIMG);

	title(['mx\_mn\_er.m:MaxER, MinER and Max-MinER images; LX*LY=',num2str(LX),'*',num2str(LY),'; ERpl=',num2str(ERplus),'; ERmn=',num2str(ERminus)]);

	drawnow

end





	