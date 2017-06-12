function OUT=iwalsh2_mb(INPIMG)
% 2-D Inverse Walsh transform of INPIMG
% Note: INPIMG should be a square array with dimensions of power of 2
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il).
% Call OUT=iwalsh2(INPIMG);

[SzX,SzY]=size(INPIMG);
n=log2(SzX);
WAL=walsh(n);
OUT=(WAL.')*INPIMG*WAL;
%--------------------------------------------------------------------------

function OUT=walsh(n)
% Matrix of Walsh Hadamard transform of the order 2^n
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call WAL=walsh(n);

Sz=2^n;
OUT=hadamard(Sz);
gray=grayperm_mb(n);
bin=bininv_mb(n);
OUT=gray*bin*OUT;

norm=inv(sqrt(OUT*OUT'));
OUT=norm*OUT;