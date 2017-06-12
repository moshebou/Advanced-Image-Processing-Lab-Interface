function display1_mb(INPIMG)

% Displays a 2-D signal as an image 

% with normalization by global maximum and minimum

% Call display1(INPIMG)



Min=min(min(INPIMG)); Max=max(max(INPIMG));

if Max-Min==0, im=zeros(size(INPIMG)); else im=uint8(255*(double(INPIMG-Min)/double(Max-Min))); end

imshow(uint8(im), []);axis image;axis off;

%colorbar('vert')

% title('display1.m: Input image')

