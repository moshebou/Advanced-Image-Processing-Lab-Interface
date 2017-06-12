function [OUTIMG, LUTable ]= LloydMaxQunt2_mb( INPIMA, Q, init_guess)
% LLoydMax quantization of INPIMA to Q quantization  levels in the range
% Copyright Moshe Bouhnik and L. Yaroslavsky (www.eng.tau.ac.il/~yaro)
% Usage [OUTIMG, LUTable]= LloydMaxQuant(INPIMG,Q);
% INPIMG - input image, gray, 8bpp, 256 gray levels.
% Q      - Number of quantization levels.


MAX_ITERATION = 1000;
INPIMA = double(INPIMA);
x_unique = unique(INPIMA(:));
max_val = max(x_unique(:));
min_val = min(x_unique(:));

if ( length ( x_unique ) < Q )
    OUTIMG = INPIMA;
    LUTable = [x_unique', x_unique'];
    return;
end

h = histc(INPIMA(:), x_unique); 

h = h/sum(h);

if ( nargin == 3 ) 
     x = sort([init_guess;((max(init_guess(:))-min(init_guess(:)))*rand(Q - length(init_guess),1)+min(init_guess(:)))])';
 else

      x = linspace(min_val, max_val, Q); 
 end

rms_error = inf;

A = x_unique*ones(1,size(x,2));
B = (A - ones(size(x_unique,1),1)*x).^2;
C = h*ones(1,size(x,2)).*A;
D = h*ones(1,size(x,2));
E = (ones(size(A,1),1)*[1:Q]);
[min_B, I] = min(B, [], 2);
curr_rms_error2 = sum(h'*min_B);
[sort_minb, Isorted] = sort(min_B.*h,'descend');
while ( curr_rms_error2+eps < rms_error && MAX_ITERATION > 0)
    rms_error = curr_rms_error2;
    indx = (E == (I*ones(1, Q)));
    zeros_indx = find(sum(indx) == 0);
    i = 1;
    while ~isempty(zeros_indx)
        indx = indx(:, [1:zeros_indx(1)-1, zeros_indx(1)+1 : end]);
        ver = zeros(size(indx,1), 1);
        hor = find(indx(Isorted(i), :) == 1);
        ver(Isorted(i):end) = indx(Isorted(i):end, hor);
        indx(Isorted(i):end, hor) = 0;
        indx = [indx(:, 1:hor), ver, indx(:, hor+1:end)];
         zeros_indx = find(sum(indx) == 0);
         i = i+1;
    end
    x = sum(C.*indx)./sum(D.*indx);
    B = (A - ones(size(x_unique,1),1)*x).^2;
    [min_B, I] = min(B, [], 2);
    curr_rms_error2 = h'*min_B;
    [sort_minb, Isorted] = sort(min_B.*h,'descend');
    MAX_ITERATION = MAX_ITERATION -1;
end
OUTIMG = INPIMA;


LUTable(:,1) = [x_unique'];
for i = 1 : length(LUTable(:,1))
    LUTable(i,2) = x(indx(x_unique == LUTable(i,1),:));
    OUTIMG(OUTIMG == LUTable(i,1) ) = LUTable(i,2);
end
