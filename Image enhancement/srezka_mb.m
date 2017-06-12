function OUTIMG=srezka_mb(INPIMG)
% Image normalization by zeroing all pixels that are less then 0
% and assigning 255 to all pixels than exceed 255
% Call OUTIMG=srezka(INPIMG);
OUTIMG=(INPIMG>0).*INPIMG;
OUTIMG=(OUTIMG<=255).*OUTIMG+255*(OUTIMG>255);