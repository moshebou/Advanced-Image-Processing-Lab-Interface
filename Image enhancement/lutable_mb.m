function OUT=lutable_mb(INPIMG,lut)
%Look up table element-wise transformation of an image
%lut is a table of (1,256) size
%Call OUT=lutable(INPIMG,lut);
Sz=size(INPIMG);SzX=Sz(1);SzY=Sz(2);
OUT=reshape(lut(1+INPIMG),SzX,SzY);