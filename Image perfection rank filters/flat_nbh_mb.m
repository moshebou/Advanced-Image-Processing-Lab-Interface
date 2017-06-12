function out=flat_nbh_mb( eye_wnd)

% "Flat" neighborhood within image fragment:

% Those pixels where gradient is lower than a threshold thr

% that is provided by the user 

[height width]  = size(eye_wnd);
Lx = (height-1)/2;
Ly = (width-1)/2;



grad = zeros(size(eye_wnd));
	for x=2:2*Lx;

		for y=2:2*Ly,

			grad(x,y)=sqrt((eye_wnd(x-1,y)-eye_wnd(x,y)).^2+(eye_wnd(x+1,y)-eye_wnd(x,y)).^2+(eye_wnd(x,y-1)-eye_wnd(x,y)).^2+(eye_wnd(x,y+1)-eye_wnd(x,y)).^2)/2;

		end;

	end;



	mxmx=max(max(grad));

	h=imghisto_mb(round(255*grad/mxmx));



	centervalue=eye_wnd(Lx+1,Ly+1);

	h0=zeros(1,256);h0(centervalue)=max(h);



	t=0:mxmx/255:mxmx;



	subplot(2,2,3);plot(t,h,t,h0);axis([0 mxmx 0 max(h)]);grid;

	title('histogram of gradients in the window');drawnow;



	thr=input('Enter Threshold = ');



	mask=(grad<thr);

	out=mask;

	%out=eye_wnd/4+3*mask.*eye_wnd/4;



	subplot(2,2,4);display1_mb(out);

	title(['Flat-neighborhood; Thr=' int2str(thr)]);

	drawnow;



	s=input('Do you want to continue? (y or n)  ','s'); 

end