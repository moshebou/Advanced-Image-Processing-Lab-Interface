function OUTIMG=quantize(INPIMG,Q);
% Image uniform  quantization in the range (INPIMGmin INPIMGmax)
% on Q levels
% Call OUTIMG=quantize(INPIMG,Q);

inpmin=min(min(INPIMG));
inpmax=max(max(INPIMG));
OUTIMG=round((Q-1)*(INPIMG-inpmin)/(inpmax-inpmin));
OUTIMG=(inpmax-inpmin)*(OUTIMG)/(Q-1)+inpmin;
%subplot(121);display(INPIMG);title('Initial image');
%subplot(122);display(OUTIMG);title('Quantized image');
