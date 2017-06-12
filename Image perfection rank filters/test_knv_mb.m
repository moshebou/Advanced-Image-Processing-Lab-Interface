function out=test_knv_mb(IMG)
% Interactive selection and observation of KNV-neighborhood
% Call out=test_knv(IMG);
IMG = double(IMG);
clf
display1_mb(IMG);title('Test_knv.m:input image');drawnow;
t='Enter coordinates of the center of the window'
c=ginput(1); X0=round(c(2));Y0=round(c(1));
%Y0=input('Enter horizontal coordinate of the window center, Y0 = ');
%X0=input('Enter vertical coordinate of the window center, X0 = ');
Ly=input('Enter horizontal size (2Ly+1) of the window, Ly = ');
Lx=input('Enter vertical size (2Lx+1) of the window, Lx = ');
eye=IMG(X0-Lx:X0+Lx,Y0-Ly:Y0+Ly);
IMG(X0-Lx:X0+Lx,Y0-Ly:Y0+Ly)=1.5*IMG(X0-Lx:X0+Lx,Y0-Ly:Y0+Ly);
subplot(2,2,1);display1_mb(IMG);grid;title('Test_knv.m:input image');drawnow;
centervalue=eye(Lx+1,Ly+1);
h=histim_mb(eye);h0=zeros(1,256);h0(centervalue)=max(h);
eye(Lx+1,Ly+1)=255;
subplot(2,2,2);display1_mb(eye);grid;
title(['window ',num2str((2*Lx+1)),'x',num2str((2*Ly+1))]);drawnow;

subplot(2,2,3);plot(1:256,h,'-',1:256,h0,'--');axis([1 256 0 max(h)]);grid;

title('histogram of the window');drawnow;



eye(Lx+1,Ly+1)=centervalue;



mask=zeros(2*Lx+1,2*Ly+1);mask(Lx+1,Ly+1)=1;

Lx=2*Lx+1;Ly=2*Ly+1;



dif=abs(eye-centervalue*ones(Lx,Ly));

[Y,I]=sort(dif(:));

% size(Y)=Lx*Ly; numbers in I indicate position of element of Y in diff



s='y';

while s=='y',
	K=input('Enter neighborhood size K = ');
    mask2 = zeros(size(eye));
mask2(I(1:K))=1;
	knvneighb=Y(1:K); coord=I(1:K);
	for k=1:K,
		c=coord(k)/Ly;
		x=fix(c)+1; if x>Lx, x=Lx;end;
		% y=fix(Ly*(c-x+1))+1;if y>Ly, y=Ly; end;
		y=fix(coord(k)-Ly*(x-1))+1; if y>Ly, y=Ly; end;
		mask(x,y)=1;
    end
   
	out=mask;
    %mask(coord) = 1;
	subplot(2,2,4);display1_mb(out);grid;title(['KNV-neighborhood,K=' int2str(K)]);
	s=input('Do you want to continue? (y or n)  ','s'); 
end