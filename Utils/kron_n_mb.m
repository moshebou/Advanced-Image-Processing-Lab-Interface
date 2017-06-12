function OUT=kron_n_mb(INP,n);

% n-th Kronecker power of matrix INP

% Call OUT=kron_n(INP,n); 



OUT=INP;

if n==0, OUT=1;

else

for k=1:n-1,

OUT=kron(OUT,INP);

end

end