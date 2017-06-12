function OUT=mneviter_mb(INPIMG,LX,LY,EVplus,EVminus,Niter)

% Iterated MEAN_EV
% LX,LY - dimensions of the window
% EVplus, EVminus - size of EV-neighborhood
% Niter - number of iterations
% Call OUT=mneviter(INP,Noise,LX,LY,EVpos,EVneg,Nit);
INPIMG = double(INPIMG);

[SzX SzY]=size(INPIMG);
OUT=INPIMG;
INP_n=INPIMG;
delta=zeros(1,Niter);

for k=1:Niter,
% figure(1);   
OUT=mean_ev_mb(INP_n,LX,LY,EVplus,EVminus);
% myimage([INPIMG OUT]);
% title(['Mneviter.m:Input image and output images; Iter=',num2str(k)]);
% drawnow

% [mn,dlt]=std2d(OUT-INPIMG);
% delta(k)=dlt(2);

% figure(2);
% plotnorm(delta,1,1,1);
% xlabel('Iteration');
% ylabel('Standard deviation')
% title('Std of residual noise.')
% drawnow

INP_n=OUT;
end


