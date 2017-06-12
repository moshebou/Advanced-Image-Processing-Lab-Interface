function OUTPUT=sinc_int_mb(input,Lx)
%1-D sinc interpolation with Lx-fold signal stretching
%(SzX/2+1)th sample of the mask is equal to cos(pi*Ux)/2
% EVEN SIGNAL EXTENSION
input = input(:);
SzX =2*max(size(input));
SzX_half=round(SzX/2);
%output=zeros(Lx*SzX_half,1);
input=[input;input(SzX_half:-1:1)];
Ux=1/(Lx);
M=zeros(SzX,1);

M(1)=1; M(SzX_half+1)=exp(1i*pi*Ux);
r=2:SzX_half; Wn=1i*2*pi*Ux/SzX;
M(r)=exp(Wn*(r-1)); M(SzX+2-r)=conj(M(r));
spinput=fftnorm_mb(input);
spinput_2 =  (spinput*ones(1,Lx)).*(cumprod(M*ones(1, Lx), 2));
spinput_2(SzX_half+1, :) = real(spinput_2(SzX_half+1, :));
spinput_2 = spinput_2(1:SzX, :);
out = real(ifft(spinput_2)');
out=out(:);
OUTPUT = out(1:Lx*SzX_half);
% for l=1:Lx,
%         spinput=spinput.*M;
% out=real(ifftnorm_mb([spinput(1:SzX_half);real(spinput(SzX_half+1));spinput(SzX_half+2:SzX)]));
% 		out=out(1:SzX_half);
% 		key=zeros(Lx,1);key(l)=1;
% 		output=kron(out,key)+output;
% %         plotnorm_mb(OUTPUT,1,1,1);
% %         title(['sincint1.m: Interpolated signal, Lint=',num2str(Lx)]);
% %         drawnow;
% end
% max(abs(OUTPUT - output))