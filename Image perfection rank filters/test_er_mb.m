function out=test_er_mb(eye_wnd)

% Interactive selection and observation of ER-neighborhood

% Call out=test_er(IMG);





% dsplmask=ones(size(IMG));
% 
% dsplmask(X0-Lx:X0+Lx,Y0-Ly:Y0+Ly)=1.5*dsplmask(X0-Lx:X0+Lx,Y0-Ly:Y0+Ly);
% 
% subplot(2,2,1);display1_mb(IMG.*dsplmask);title('Input image');drawnow;



centervalue=eye_wnd(round((size(eye_wnd,1)  - 1 )/2),round((size(eye_wnd,2)  - 1 )/2));
% 
% h=histim_mb(eye_wnd);h0=zeros(1,256);h0(centervalue)=max(h);
% 
% eye_wnd(Lx+1,Ly+1)=255;

% LX=2*Lx+1;LY=2*Ly+1;
% 
% subplot(2,2,2);display1_mb(eye_wnd);title(['window ',num2str(LX),'x',num2str(LY)]);drawnow;
% 
% 
% 
% subplot(2,2,3);plot(1:256,h,'-',1:256,h0,'--');axis([1 256 0 max(h)]);grid;
% 
% title('histogram of the window');drawnow;



eye_wnd(Lx+1,Ly+1)=centervalue;
	vector=reshape(eye_wnd,LX*LY,1);
    [Y,I]=sort(eye_wnd(:));
    R = round(median(find(Y == centervalue )));
    mask=zeros(LX,LY);
    mask( I(max(1,R-erneg):min(length(I),R+erpos))) = 1;
