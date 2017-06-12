function GRAY=grayperm(n)



% Gray-to-Direct Binary Code permutation matrix of the order 2^n

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

