function OUTIMG=dctspenh_mb(INPIMG,P)
INPIMG = double(INPIMG);


% Image enhancement by non-linear transformation of its DCT spectrum

% OUTIMG=idct2({abs[dct2(INPIMG)].^P}.*{sign[dct2(INPIMG)]});

% Call OUTPUT=dctspenh(INPIMG,P)



sp=dct2(INPIMG);

dc=sp(1,1);

sp(1,1)=0;

norm1=sqrt(sum(sum((sp.^2))));

magnitude=abs(sp).^P;

norm2=sqrt(sum(sum((magnitude.^2))));

SIGN=sign(sp);

sp=norm1*magnitude.*SIGN/norm2;

sp(1,1)=dc;

OUTIMG=(idct2(sp));

OUTIMG=srezka(OUTIMG);

OUTIMG=round(OUTIMG);



myimage([INPIMG OUTIMG]);

title(['dctspenh.m: Input and output images; P=',num2str(P)])