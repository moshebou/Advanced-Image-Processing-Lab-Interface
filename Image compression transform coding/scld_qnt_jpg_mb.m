function q = scld_qnt_jpg(Q,saturate)
% jpeg luminance quantization matrix
% multiplied with <scale>, saturated at 1, 255

scale = [5000./[1:49] 200-2.*[50:99] 1] ; % scaling factor vs. quality according to IJPEg software
% make shure that in range 1:100 (%)
if Q < 1 
   Q = 1 ;
end
if Q > 100
   Q = 100 ;
end

scale = scale( Q ) ;

q=[ 16,  11,  10,  16,  24,  40,  51,  61;
    12,  12,  14,  19,  26,  58,  60,  55;
    14,  13,  16,  24,  40,  57,  69,  56;
    14,  17,  22,  29,  51,  87,  80,  62;
    18,  22,  37,  56,  68, 109, 103,  77;
    24,  35,  55,  64,  81, 104, 113,  92;
    49,  64,  78,  87, 103, 121, 120, 101;
    72,  92,  95,  98, 112, 100, 103,  99];
 q = floor((scale * q + 50) / 100) ; % scale procedure according to ILPEG software definition
 q(q<1) = 1;
 if saturate
    q(q>255) = 255;
 end ;
 