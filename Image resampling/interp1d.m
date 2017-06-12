function OUTP=interp1d(INP,Lx);

% 1-D sinc interpolation with Lx-fold signal stretching
% For even SzX, (SzX/2+1)-th sample of the mask is equal to cos(pi*Ux);
% For matrix, interpolation is carried out column wise 
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il). Sept. 27, 2002  
% Call OUTP=interp1d(INP,Lx);

%INP=reshape(INP,max(size(INP)),min(size(INP)));
[SzX, SzY] =size(INP);
if SzX==1,INP=INP';[SzX, SzY] =size(INP);end
OUTP=zeros(Lx*SzX,SzY);
SzX2=round(SzX/2);
Ux=1/(Lx);
M=zeros(SzX,1);M(1)=1;
r=2:SzX2; 
spinput=fft(INP);
if fix(SzX/2)-SzX2==0,
   M(SzX2+1)=exp(i*pi*Ux);
   Wn=i*2*pi*Ux/SzX;
   M(r)=exp(Wn*(r-1)); M(SzX+2-r)=conj(M(r));
else
   Wn=i*2*pi*Ux/SzX;
   M(r)=exp(Wn*(r-1)); M(SzX+2-r)=conj(M(r));
end
M=kron(M,ones(1,SzY));
for l=1:Lx,	
   spinput=spinput.*M;
   if fix(SzX/2)-SzX2==0,
      out=real(ifft([spinput(1:SzX2,:);real(spinput(SzX2+1,:));spinput(SzX2+2:SzX,:)]));
   else
      out=real(ifft([spinput(1:SzX2-1,:);spinput(SzX2,:)/2;spinput(SzX2+1,:)/2;spinput(SzX2+2:SzX,:)]));
   end
	key=zeros(Lx,1);key(l)=1;
	OUTP=kron(out,key)+OUTP;
end

OUTP=[OUTP((SzX-1)*Lx+1:SzX*Lx,:);OUTP(1:(SzX-1)*Lx,:)];


	