function out=test_ev_mb(IMG, Lx, Ly, evpos, evneg)

% Interactive selection and observation of EV-neighborhood

% Call out=test_ev(IMG);




IMG = double(IMG);
% display1_mb(IMG);title('input image');drawnow;
% 
% t='Enter coordinates of the center of the window';
% 
% c=ginput(1); X0=round(c(2));Y0=round(c(1));

%Y0=input('Enter horizontal coordinate of the window center, Y0 = ');

%X0=input('Enter vertical coordinate of the window center, X0 = ');




center_wnd=IMG(X0-Lx:X0+Lx,Y0-Ly:Y0+Ly);



% dsplmask=ones(size(IMG));
% 
% dsplmask(X0-Lx:X0+Lx,Y0-Ly:Y0+Ly)=1.5*dsplmask(X0-Lx:X0+Lx,Y0-Ly:Y0+Ly);
% 
% subplot(2,2,1);display1_mb(IMG.*dsplmask);title('test_ev.m:Input image');drawnow;



centervalue=center_wnd(Lx+1,Ly+1);

h=imghisto_mb(center_wnd);h0=zeros(1,256);h0(centervalue)=max(h);

center_wnd(Lx+1,Ly+1)=255;



% subplot(2,2,2);display1_mb(center_wnd);
% 
% title(['window ',num2str(2*Lx+1),'x',num2str(2*Ly+1)]);drawnow;
% 
% subplot(2,2,3);plot(1:256,h,'-',1:256,h0,'--');axis([1 256 0 max(h)]);grid;
% 
% title('histogram of the window');drawnow;


	center_wnd(Lx+1,Ly+1)=centervalue;

	mask=(center_wnd<=(centervalue+evpos)).*(center_wnd>=(centervalue-evneg));

	out=mask;


