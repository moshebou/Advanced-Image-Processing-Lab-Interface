function OUTPUT=interp2d_mb(INPUT,Lx,Ly,FlagQuant,FlagDispl)

% 2-D separable sinc interpolation with Lx*Ly-fold signal zooming
% Output image is 256-quantized if FlagQuant==1
% Output image is displayed if FlagDispl==1
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il). Sept. 25, 2002  
% Call OUTPUT=interp2d(INPUT,Lx,Ly,FlagQuant,FlagDispl);
if ( nargin < 4 ) 
    FlagQuant = 0;
end
if ( nargin < 5 )
    FlagDispl = 0;
end
[SzX,SzY]=size(INPUT);
OUTPUT=interp1d_mb(INPUT,Lx);
OUTPUT=(interp1d_mb(OUTPUT',Ly))';

if FlagQuant==1,
    OUTPUT=round(OUTPUT);
    OUTPUT=(OUTPUT>=min(INPUT(:))).*OUTPUT;
    OUTPUT=(OUTPUT<=max(INPUT(:))).*OUTPUT+max(INPUT(:))*ones(Lx*SzX,Ly*SzY).*(OUTPUT>max(INPUT(:)));
end

if FlagDispl==1,
    colormap(gray(256));
    display1(OUTPUT); 
    title(['interp2d.m: Magnified image X',num2str(Lx),'*',num2str(Ly)]);drawnow
end






	