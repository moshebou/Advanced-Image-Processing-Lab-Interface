function coldispl(R,G,B);
% Color display of RGB images

%mx=max(max([R,G,B]));
%mn=min(min([R,G,B])); 
%mxmn=mx-mn;
%[X,map]=rgb2ind((R-mn)/mxmn,((G-mn)/mxmn),(B-mn)/mxmn,1024);
%imshow(X,map);

imshow(R/256,G/256,B/256)
