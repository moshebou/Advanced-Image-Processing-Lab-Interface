function OUT=locihaar1_mb(INP)
    % Computing local 1-D haar spectrum of 1-D INP signal
    % in moving window of 2*Lt+1 samples
    % Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
    % Call OUT=locdct1(INP,Lt);
    
    [SzW, SzY]=size(INP);
    har=haar(log2(SzW));
    OUT = ((har)^-1)*INP;
    OUT = OUT(1+size(OUT,1)/2, :);
end

function OUT=haar(n);
    % Generating Haar matrix of the order 2^n.
    % Copyright L. Yaroslavsky ((www.eng.tau.ac.il/~yaro)  
    E0=[1 1];
    E1=[1 -1];
    har_0=kron_n(E0,n-1);
    OUT=kron_n(E0,n);
    OUT=[OUT;kron(E1,har_0)];
    for i=2:n,
        har_0=kron_n(E0,n-i);
        har_i=kron(eye(2^(i-1)),E1);
        har_i=kron(har_i,har_0);
        OUT=[OUT;har_i];
    end
end

function OUT=kron_n(INP,n)
    % n-th Kronecker power of matrix INP
    % Copyright L. Yaroslavsky ((www.eng.tau.ac.il/~yaro)  
    OUT=INP;
    if n==0, OUT=1;
    else
        for k=1:n-1,
            OUT=kron(OUT,INP);
        end
    end
end