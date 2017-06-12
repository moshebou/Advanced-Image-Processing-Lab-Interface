function z=ifftnorm_mb(signal)
%NORMALIZED INVERSE FFT
N=sqrt(length(signal));
signal=signal*N;
z=ifft(signal);