function [OUTIMG, LUTable]=MaxLloydQuant(INPIMG,Q)

% Optimal Max-Lloyd quantization of INPIMG to Q quantization levels
% LUTable - quantization look-up table
% Copyright L. Yaroslavsky (www.eng.tau.ac.il/~yaro)

[SzX,SzY]=size(INPIMG);
LUTable=zeros(1,256);
[partition,codebook] = lloyds(double(INPIMG(:)),8);
Partition=[min(INPIMG(:)),partition,max(INPIMG(:))];
for q=1:Q,
    LUTable(1+round(Partition(q)):1+round(Partition(q+1)))=codebook(q);
end
OUTIMG=reshape(LUTable(1+round(INPIMG)),SzX,SzY);
