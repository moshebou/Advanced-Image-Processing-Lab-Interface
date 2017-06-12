function BINV=bininv(n);

% Binary inversion permutation matrix of the order 2^n
% Call  BINV=bininv(n);

BINV=eye(2);

for k=1:n-1,
	BINV_0=kron(BINV,[1 0]);
	BINV_1=kron(BINV,[0 1]);
	BINV=[BINV_0;BINV_1];
end