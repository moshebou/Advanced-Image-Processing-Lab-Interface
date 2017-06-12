function z=fftnorm(signal);

%NORMALIZED DIRECT FFT

N=sqrt(length(signal));

signal=signal/N;

z=fft(signal);