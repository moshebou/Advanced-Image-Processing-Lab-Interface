function output=interp2_mb(input,Lx,Ly)
% 2-D separable sinc interpolation with Lx*Ly-fold signal zooming
% Equivalent to program interp2d.m except it does not display the result
% Call output=interp2_(input,Lx,Ly);
input = double(input);
[SzX SzY] =size(input);
output=zeros(Lx*SzX,Ly*SzY);outputx=zeros(SzX,Ly*SzY);
Ux=1/(Lx);Uy=1/(Ly);

Mx=zeros(SzX,1);

Mx(1)=1; Mx((SzX/2)+1)=exp(i*pi*Ux);

r=2:SzX/2; Wn=i*2*pi*Ux/SzX;

Mx(r)=exp(Wn*(r-1)); Mx(SzX+2-r)=conj(Mx(r));



My=zeros(1,SzY);

My(1)=1; My((SzY/2)+1)=exp(i*pi*Uy);

r=2:SzY/2; Wn=i*2*pi*Ux/SzY;

My(r)=exp(Wn*(r-1)); My(SzY+2-r)=conj(My(r));



%INTERPOLATION ALONG Y AXIS



for x=1:2:SzX,

spinput=fft(input(x,:)+i*input(x+1,:));



for l=1:Ly,

	

		spinput=spinput.*My;

out=(ifft([spinput(1:SzY/2) real(spinput(SzY/2+1)) spinput(SzY/2+2:SzY)]));

		key=zeros(1,Ly);key(l)=1;

		outputx(x,:)=kron(real(out),key)+outputx(x,:);

		outputx(x+1,:)=kron(imag(out),key)+outputx(x+1,:);

end

end

%display(outputx); title('interp2dm: First pass');drawnow



%INTERPOLATION ALONG Y AXIS



for y=1:2:SzY*Ly,

spinput=fft(outputx(1:SzX,y)+i*outputx(1:SzX,y+1));



for l=1:Lx,

	

		spinput=spinput.*Mx;

out=(ifft([spinput(1:SzX/2);real(spinput(SzX/2+1));spinput(SzX/2+2:SzX)]));

		key=zeros(Lx,1);key(l)=1;

		output(:,y)=kron(real(out),key)+output(:,y);

		output(:,y+1)=kron(imag(out),key)+output(:,y+1);

end

%display(output); drawnow

end

output=round(output);

output=(output>=0).*output;

output=(output<=255).*output+255*ones(Lx*SzX,Ly*SzY).*(output>255);



%display(output); 

%title(['interp2d.m: Magnified image X',num2str(Lx),'*',num2str(Ly)]);drawnow













	