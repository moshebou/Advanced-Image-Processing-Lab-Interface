%-------------------------------------------------------------------
function WAL=walsh_mb(n)

% Matrix of Walsh Hadamard transform of the order 2^n
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call WAL=walsh(n);

Sz=2^n;
WAL=hadamard(Sz);
gray=grayperm(n);
bin=bininv(n);
WAL=gray*bin*WAL;
%-------------------------------------------------------------------
function GRAY=grayperm(n)

% Gray-to-Direct Binary Code permutation matrix of the order 2^n
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call GRAY=grayperm(n)

I2=eye(2); 
I2_=[0 1;1 0];
	I_n=kron_n_mb(I2,(n-1));
	I__n=kron_n_mb(I2_,(n-1));
	GRAY=dir_sum_mb(I_n,I__n);
	

for r=1:n-1,
	I2_r=kron_n_mb(I2,r);
	I_r=kron_n_mb(I2,(n-r-1));
	I__r=kron_n_mb(I2_,(n-r-1));
	I=dir_sum_mb(I_r,I__r);
	GRAY=GRAY*kron(I2_r,I);
end
%----------------------------------------------------------------
function BINV=bininv(n);

% Binary inversion permutation matrix of the order 2^n
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call  BINV=bininv(n);

BINV=eye(2);

for k=1:n-1,
	BINV_0=kron(BINV,[1 0]);
	BINV_1=kron(BINV,[0 1]);
	BINV=[BINV_0;BINV_1];
end