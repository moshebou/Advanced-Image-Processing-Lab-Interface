function OUT=locatmax_mb(INP)



% The program locates the highest maximum in a matrix INP

% Provides its value and coordinates

% OUT=[Xm Ym Maximum]

% Call OUT=locatmax_mb(INP);



[SzX SzY]=size(INP);

INP=reshape(INP,SzX*SzY,1);

[mx I]=max(INP);

Ym=fix((I-1)/SzX)+1;

Xm=rem(I-1,SzX)+1;



OUT=[Xm Ym mx ];





% Old program

%Sz=size(INP);

%[Z,X]=sort(INP);

%Z=Z(Sz(1),:);

%X=X(Sz(1),:);

%[Z,Y]=sort(Z);

%y=Y(Sz(2));x=X(y);

%z=Z(Sz(2)); %%%%%%%% Here you had z=Z(Sz(1)); 

%OUT=[x y z];