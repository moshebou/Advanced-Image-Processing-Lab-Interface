function Z=histim(IMG);
%IMAGE HISTOGRAM
%INPUT VARIABLE "img" - a matrix of integer numbers from 0 to 255;
%OUTPUT:vector of histogram
SZ=size(IMG);
SZx=SZ(1);
SZy=SZ(2);
Z=zeros(1,256);
for k=1:SZx,
for l=1:SZy,
Z(1+fix(IMG(k,l)))=Z(1+fix(IMG(k,l)))+1;
end
end
