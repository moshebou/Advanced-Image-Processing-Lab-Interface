function OUT=dpcmtest(INPIMG);
% Horizontal, vertical and 2-D prediction for DPCM:
% evaluation of variances and images
% Call OUTIMG=dpcmtest(INPIMG)

[mn,stdimg]=std2d(INPIMG);
subplot(421);display1(INPIMG);title(['Input image; std=',num2str(stdimg)]);drawnow
imh=imghisto(INPIMG);
plotnorm(imh,4,2,2);title('Input image histogram');drawnow

maskhor=[0 0 0;-1 1 0;0 0 0];
maskver=[0 -1 0;0 1 0;0 0 0];
mask2d= [-0.2 -0.4  0 ; -0.4 1 0; 0 0 0];
%mask2d= [-0.2 -0.3 0; -0.3 1 0; 0 0 0];
hordiff=conv2(INPIMG,maskhor,'same');
[mn,stdhordiff]=std2d(hordiff);
subplot(423);display1(hordiff);
title(['Horizontal differences; std=',num2str(stdhordiff)]);drawnow
absdif=abs(hordiff);mx=max(max(absdif));
absdif=round(255*absdif/mx);
hdiff=imghisto(absdif);
plotnorm(hdiff,4,2,4);title('Histogram of horizontal differences');drawnow

verdiff=conv2(INPIMG,maskver,'same');
[mn,stdverdiff]=std2d(verdiff);
subplot(425);display1(verdiff);
title(['Vertical differences; std=',num2str(stdverdiff)]);drawnow
absdif=abs(verdiff);mx=max(max(absdif));
absdif=round(255*absdif/mx);
hdiff=imghisto(absdif);
plotnorm(hdiff,4,2,6);title('Histogram of vertical differences');drawnow

horverdiff=conv2(INPIMG,mask2d,'same');
[mn,stdhorverdiff]=std2d(horverdiff);
subplot(427);display1(horverdiff);
title(['2D prediction error; std=',num2str(stdhorverdiff)]);drawnow
absdif=abs(horverdiff);mx=max(max(absdif));
absdif=round(255*absdif/mx);
hdiff=imghisto(absdif);
plotnorm(hdiff,4,2,8);title('Histogram of 2-D prediction error');drawnow