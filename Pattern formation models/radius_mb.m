function z=radius_mb(R)
% Generating a function z=(X-X0)^2+(Y-Y0)^2; R=X0-1=Y0-1; 
% Resulting matrix size is 2R*2R;
% Call z=radius(R);
X=(-R:R-1).^2;
X=kron(X,ones(2*R,1));
z=X+X';
% display1_mb(z);
% title(['radius.m: R=',num2str(R)]);







