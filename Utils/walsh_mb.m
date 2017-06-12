function WAL=walsh_mb(n)
% Matrix of Walsh Hadamard transform of the order 2^n
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call WAL=walsh(n);

Sz=2^n;
WAL=hadamard(Sz);
gray=grayperm_mb(n);
bin=bininv_mb(n);
WAL=gray*bin*WAL;

norm=inv(sqrt(WAL*WAL'));
WAL=norm*WAL;


