function  show_spectrum( sp, axes_handle, b_fft_shift )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
p = 0.3;
if ( nargin < 3 )
    b_fft_shift = 0;
end
sp = (abs(sp)).^p;
if ( b_fft_shift )
    imshow(fftshift(uint8(255*(sp - min(sp(:)))/(max(sp(sp(:)~=max(sp(:)))) - min(sp(:))))) ,  'parent', axes_handle);
else
    imshow(uint8(255*(sp - min(sp(:)))/(max(sp(sp(:)~=max(sp(:)))) - min(sp(:)))) ,  'parent', axes_handle);
end   
% colormap(axes_handle, jet(256));
end

