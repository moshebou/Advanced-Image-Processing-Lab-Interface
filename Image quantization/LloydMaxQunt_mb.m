function [OUTIMG, LUTable ]= LloydMaxQunt_mb( INPIMA, Q)
% LLoydMax quantization of INPIMA to Q quantization  levels in the range
% Copyright Moshe Bouhnik and L. Yaroslavsky (www.eng.tau.ac.il/~yaro)
% Usage [OUTIMG, LUTable]= LloydMaxQuant(INPIMG,Q);
% INPIMG - input image, gray, 8bpp, 256 gray levels.
% Q      - Number of quantization levels.
MAX_ITERATION = 1000;
%F = figure; 
%A = axes('parent', F);
%hold(A, 'on');
INPIMA = double(INPIMA);
x_unique = unique(INPIMA(:));
max_val = max(x_unique(:));
min_val = min(x_unique(:));

if ( length ( x_unique ) < Q )
    OUTIMG = INPIMA;
%     LUTable = zeros(1, 256 ); 
    LUTable = [x_unique', x_unique'];
%     LUTable(max_val+2:end) = max_val;
    return;
end
% calc (once) the probabilaty of each pixel value
h = histc(INPIMA(:), x_unique); 

h = h/sum(h);

% stem(x_unique, h, 'parent', A); axis(A, 'tight');

%[h_sort,IX] = sort(h, 'ascend');
im_hist = @(im_val)h(logical(sum(x_unique*ones(1,length(im_val)) == ones(length(x_unique),1)*im_val',2))); %h(unique_index(x_unique == im_val);
 x = linspace(min_val, max_val, Q); 
% x = x_unique(IX(1:Q));
%S = scatter(x, zeros(length(x),1), 'r', '+' );
rms_error = inf;
t = (x(2:end) + x(1:end-1))/2;
%T = scatter(t, max(h(:))*ones(length(t),1), 'k', '+' );
curr_rms_error = 0;
length_x_unique_t = 0;
for i = 1 : length(t)+1
%     l = 0;
    X = x(i);
    x_unique_t = [];
    if ( i == 1 )
        x_unique_t =  x_unique(x_unique<t(1));
    elseif ( i == length(t)+1 )
        x_unique_t =  x_unique(x_unique>=t(length(t)));
    else
        x_unique_t =  x_unique(logical((x_unique>=t(i-1)).*(x_unique<t(i))));
    end
    if ( ~isempty(x_unique_t))
        curr_rms_error = curr_rms_error + sum(((X-x_unique_t).^2).*im_hist(x_unique_t));
    end
    length_x_unique_t = length_x_unique_t + length(x_unique_t);
end
if( length_x_unique_t < length(x_unique))
    error( 'not all x are assigned to a quantized val');
end
    
curr_rms_error = sqrt(curr_rms_error);
while ( curr_rms_error+eps < rms_error && MAX_ITERATION > 0)
    MAX_ITERATION = MAX_ITERATION -1;
    rms_error = curr_rms_error;
    length_x_unique_t = 0;
    
    for i =1 :length(t)+1
        if ( i == 1 )
            x_unique_t =  x_unique(x_unique<t(1));
            if( isempty(x_unique_t) )
                x_unique_t = min(x_unique);
            end
        elseif ( i == length(t)+1 )
            x_unique_t =  x_unique(x_unique>=t(length(t)));
            if( isempty(x_unique_t) )
                x_unique_t = max(x_unique);
            end
        else
            x_unique_t =  x_unique(logical((x_unique>=t(i-1)).*(x_unique<t(i))));
        end
        
        if (~isempty(x_unique_t))
            x(i) = sum(x_unique_t.*im_hist(x_unique_t))/sum(im_hist(x_unique_t));
        else
            x(i) = (t(i-1)+t(i))/2;
        end
        length_x_unique_t = length_x_unique_t + length(x_unique_t);
    end
    if( length_x_unique_t < length(x_unique))
        error( 'not all x are assigned to a quantized val');
    end
    %delete(S);
    %S = scatter(x, zeros(length(x),1), 'r', '+' );
    t = (x(2:end) + x(1:end-1))/2;
    %delete(T);
    %T = scatter(t, max(h(:))*ones(length(t),1), 'k', '+' );
    curr_rms_error = 0;
    for i = 1 : length(t)+1
        X = x(i);
        x_unique_t = [];
        if ( i == 1 )
            x_unique_t =  x_unique(x_unique<t(1));
        elseif ( i == length(t)+1 )
            x_unique_t =  x_unique(x_unique>=t(length(t)));
        else
            x_unique_t =  x_unique(logical((x_unique>=t(i-1)).*(x_unique<t(i))));
        end

        if ( ~isempty(x_unique_t))
            curr_rms_error(i) = sum(((X-x_unique_t).^2).*im_hist(x_unique_t));
        end
        
    end
    
    % debug
    curr_rms_error = sqrt(sum(curr_rms_error));
end
OUTIMG = INPIMA;
LUTable = ones(length(x_unique), 2);
LUTable(:, 1) = x_unique;
is_empty = [];
x_val = [];
err = [];
for i = 1 : length(t)+1

    X = x(i);

    if ( i == 1 )
        if( length(INPIMA(INPIMA<t(1))) == 1 )
            x(i) = INPIMA(INPIMA<t(1));
            X = x(i);
        end
        OUTIMG(INPIMA<t(1)) = X;
        LUTable(x_unique<t(1), 2) = X;
    elseif ( i == length(t)+1 )
        if( length(INPIMA(INPIMA>=t(length(t)))) == 1 )
            x(i) = INPIMA(INPIMA>=t(length(t)));
            X = x(i);
        end
        OUTIMG(INPIMA>=t(length(t))) = X;
        LUTable(x_unique>=t(length(t)), 2) = X;
    else
        if( isempty(INPIMA(logical((INPIMA>=t(i-1)).*(INPIMA<t(i))))) )
            is_empty = [is_empty, i];
        elseif( length(INPIMA(logical((INPIMA>=t(i-1)).*(INPIMA<t(i))))) == 1 )
            x(i) = INPIMA(logical((INPIMA>=t(i-1)).*(INPIMA<t(i))));
            X = x(i);
        end
        x_unique_t =  x_unique(logical((x_unique>=t(i-1)).*(x_unique<t(i))));
        err = [err; ((X-x_unique_t).^2).*im_hist(x_unique_t)];
        x_val = [x_val; x_unique_t];
        OUTIMG(logical((INPIMA>=t(i-1)).*(INPIMA<t(i)))) = X;
        LUTable(logical((x_unique>=t(i-1)).*(x_unique<t(i))), 2) = X;
    end
end
[B,IX] = sort(err, 'descend');
for i = 1: length(is_empty)
    x(is_empty(i)) = x_val(IX(i));
    OUTIMG(INPIMA == x_val(IX(i))) = x_val(IX(i));
end
rms = CalcRMS( INPIMA, OUTIMG); 
% OUTIMG = uint8(OUTIMG);
% LUTable = uint8(LUTable);

