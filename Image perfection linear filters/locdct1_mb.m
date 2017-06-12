function OUT=locdct1_mb(INP,Lt)

% Computing local 1-D DCT spectrum of 1-D INP signal
% in moving window of 2*Lt+1 samples
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call OUT=locdct1(INP,Lt);


SzT=max(size(INP));
INP=reshape(INP,1,SzT);
INP=[INP(Lt+1:-1:2) INP INP(SzT-1:-1:SzT-Lt)];
SzW=2*Lt+1;
SqSzW=sqrt(SzW);
tt=(0:SzW-1)';
R=exp(-i*pi*tt/SzW);
OUT=zeros(SzW,SzT);

% Computing first spectrum
X=0:SzW-1;
for r=0:SzW-1,
   OUT(r+1,1)=sum(INP(1:SzW).*exp(i*pi*(X+1/2)*r/SzW));
end

% Computing local spectra
%for t=2:SzT,
%   OUT(:,t)=(OUT(:,t-1)+ones(Lt+1,1)*(INP(t-1+SzW)-INP(t-1))).*R;
%end


for t=2:SzT,
   corr=INP(t-1+SzW)*exp(i*pi*tt*(SzW+1/2)/SzW)-INP(t-1)*exp(i*pi*tt/(2*SzW));
   OUT(:,t)=(OUT(:,t-1)+corr).*R;
end
OUT=real(OUT)/SqSzW;
