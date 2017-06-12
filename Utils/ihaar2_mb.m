function OUT=ihaar2_mb(INPIMG)
% 2-D Inverse Haar transform of INPIMG
% Note: INPIMG should be a square array with dimensions of power of 2
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il). Febr. 21, 2004
% Call OUT=ihaar2(INPIMG);

[SzX,SzY]=size(INPIMG);
n=log2(SzX);
HAR=haar(n);
OUT=(HAR.')*INPIMG*HAR;

%--------------------------------------------------------------------------
function OUT=haar(n)

% Generating Haar matrix of the order 2^n.
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call OUT=haar(n);

E0=[1 1];
E1=[1 -1];
har_0=kron_n_mb(E0,n-1);
OUT=kron_n_mb(E0,n);
OUT=[OUT;kron(E1,har_0)];

for i=2:n,
	har_0=kron_n_mb(E0,n-i);
	har_i=kron(eye(2^(i-1)),E1);
	har_i=kron(har_i,har_0);
	OUT=[OUT;har_i];
end

norm=inv(sqrt(OUT*OUT'));
OUT=norm*OUT;

