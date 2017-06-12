function OUTIMG=quantize_mb(INPIMG,Q)

% Image uniform  quantization in the range (INPIMGmin INPIMGmax)

% on Q levels

% Call OUTIMG=quantize(INPIMG,Q);
INPIMG = double(INPIMG);

inpmin=min(INPIMG(:));

inpmax=max(INPIMG(:));

OUTIMG=round((Q-1)*(INPIMG-inpmin)/(inpmax-inpmin));

%OUTIMG=(inpmax-inpmin)*(OUTIMG)/(Q-1)+inpmin;


