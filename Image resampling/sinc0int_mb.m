function OUTPUT=sinc0int_mb(INPUT,L)
%1-D sinc interpolation with L-fold signal stretching
%GENERAL CASE OF SDFT
%NO SIGNAL EXTENSION
N =max(size(INPUT));
INPUT=reshape(INPUT,1,N);
eyeL=eye(L);
OUTPUT=zeros(1,L*N);
%OUTPUT=kron(INPUT,eyeL(1,:));
clf
k=0:N-1;r=k;n=k;m=0:N*L-1;
p=1/L;
INPUTM=INPUT.*exp(i*pi*k*(N-1)/N);
spinput=fft(INPUTM);
%spinput(1)=spinput(1)/2;spinput(N)=spinput(N)/2;
%M=exp(i*2*pi*r*p/N);
for l=0:L-1,
		spinputM=spinput.*exp(i*2*pi*r*l*p/N);
		out0=ifft(spinputM);
	out=out0.*exp(-i*pi*(n+l*p)*(N-1)/N);
	out1=kron(real(out),eyeL(l+1,:));
	OUTPUT=out1+OUTPUT;
bar(m,out1);drawnow;hold on
end
hold off