function [OUTIMG, LUTable ]= LloydMaxQunt_General_mb( INPIMA, Q )
% LLoydMax quantization of INPIMA to Q quantization  levels in the range
% Copyright Moshe Bouhnik and L. Yaroslavsky (www.eng.tau.ac.il/~yaro)
% Usage [OUTIMG, LUTable]= LloydMaxQuant(INPIMG,Q);
% INPIMG - input image, gray, 8bpp, 256 gray levels.
% Q      - Number of quantization levels.

INPIMA = double(uint8(INPIMA));
max_val = max(INPIMA(:));
min_val = min(INPIMA(:));
x_unique = unique(INPIMA(:));
if ( length ( x_unique ) < Q )
    OUTIMG = INPIMA;
    LUTable = zeros(1, 256 ); 
    LUTable(1:min_val-1) = min_val;
    LUTable(max_val+1:end) = max_val;
    return;
end
% calc (once) the probabilaty of each pixel value
h = histc(INPIMA(:), [min_val:max_val]); % assuming integers
im_hist = @(x)h(x - min_val +1);
x = linspace(min_val, max_val, Q );
rms_error = inf;
t = (x(2:end) + x(1:end-1))/2;
curr_rms_error = 0;
for i = 1 : length(t)+1
    l = 0;
    X = x(i);
    x_unique_t = [];
    if ( i == 1 )
        x_unique_t =  x_unique(x_unique<=t(1));
    elseif ( i == length(t)+1 )
        x_unique_t =  x_unique(x_unique>t(length(t)));
    else
        x_unique_t =  x_unique(logical((x_unique>t(i-1)).*(x_unique<=t(i))));
    end
   
    for k = 1 : length(x_unique_t)
        l = l + ((X-x_unique_t(k)).^2)*im_hist(x_unique_t(k));
    end
    curr_rms_error = curr_rms_error + l;
end
while ( curr_rms_error < rms_error )
    rms_error = curr_rms_error;
    
    
    for i =1 :length(t)+1
        l= 0;
        num_of_pixels = 0;
        if ( i == 1 )
            x_unique_t =  x_unique(x_unique<=t(1));
        elseif ( i == length(t)+1 )
            x_unique_t =  x_unique(x_unique>t(length(t)));
        else
            x_unique_t =  x_unique(logical((x_unique>t(i-1)).*(x_unique<=t(i))));
        end

        for k = 1 : length(x_unique_t)
            l = l +x_unique_t(k)*im_hist(x_unique_t(k));
            num_of_pixels = num_of_pixels+im_hist(x_unique_t(k));
        end
        x(i) = l/num_of_pixels;
    end
    t = (x(2:end) + x(1:end-1))/2;
    
    curr_rms_error = 0;
    for i = 1 : length(t)+1
        l = 0;
        X = x(i);
        x_unique_t = [];
        if ( i == 1 )
            x_unique_t =  x_unique(x_unique<=t(1));
        elseif ( i == length(t)+1 )
            x_unique_t =  x_unique(x_unique>t(length(t)));
        else
            x_unique_t =  x_unique(logical((x_unique>t(i-1)).*(x_unique<=t(i))));
        end

        for k = 1 : length(x_unique_t)
            l = l + ((X-x_unique_t(k)).^2)*im_hist(x_unique_t(k));
        end
        curr_rms_error = curr_rms_error + l;
    end
end
OUTIMG = INPIMA;
LUTable = ones(1, 256);
indexs = 0:255;
for i = 1 : length(t)+1

    X = x(i);

    if ( i == 1 )
        OUTIMG(INPIMA<=t(1)) = X;
        LUTable(indexs<=t(1)) = X;
    elseif ( i == length(t)+1 )
        OUTIMG(x_unique>t(length(t))) = X;
        LUTable(indexs>t(length(t))) = X;
    else
        OUTIMG(logical((x_unique>t(i-1)).*(x_unique<=t(i)))) = X;
        LUTable(logical((indexs>t(i-1)).*(indexs<=t(i)))) = X;
    end
end


