function [OUT_IMG,encoded_string,res_huf, entropy_impimg, entropy_dct, entropy_encoded ] = jpgcodng_mb(h, IMP_IMG,blk_sz,qual,disp,coded,huf_speed)
% Copyright A. Steinman, L. Yaroslavsky (yaro@eng.tau.ac.il)
% Image JPEG coding using conventional quantization matrix for scalar quantization
% Including Huffman Coding stage according to implementation in JPEGlike_mb
% by Karl Scretting ( karl.skretting@tn.his.no.)
% suitable for different block sizes (future versions)
% Parameters:
% if code = 1, do Entropy Coding; else, restore from quantized DCT blocks
% if disp = 1, display lossy coded image and the original image error and FFT Log spectrum of error;
% else, the results are not presented graphically (for loop implementations)
% Arguments:
% IMP_IMG - image to be compressed in 8-bit mat format (must be a matrix array of values in the range 0..255)
% blk_sz - size of block suitable for operation [num_of_rows  num_of_columns], conventional JPEG processing block is of size [8 8].
% qual - quality factor defining scaling factor for conventional JPEG quantization table
% qual = 0,1 coarse quality(almost all coef. are quantized to 0)
% qual = 50 conventional quality (like no scaling at all)
% qual = 100 the best quality, tends quantization table to be all ones (no quantization loss)
% huf_speed - parameter of JPEGlike_mb function
%
%--------------------------------------------------------------------------------------
%
% function JPEGlike_mb
%
% Function needs following m-files: HuffLen, HuffCode, HuffTree
%
%  huf_speed 			For complete coding set Speed to 0. Set Speed to 1 to cheat 
%           			during encoding, y will then be a sequence of zeros only,
%           			but it will be of correct length and the other output 
%           			arguments will be correct. 
%  encoded_string    a column vector of non-negative integers (bytes) representing 
%           			the code, 0 <= encoded_string(i) <= 255. 
%  res_huf  			The results (encoding only)        for DC part       for AC part
%           			Number og symbols:                 Res(1)            Res(5)
%           			Bits to store Huffman table (HL):  Res(2)            Res(6)
%           			Bits to store Huffman symbols:     Res(3)            Res(7)
%           			Bits to store additional bits:     Res(4)            Res(8)
%           			The total of bits is then:  sum(Res([2:4,6:8]))
%----------------------------------------------------------------------------------------
% usage: [OUT_IMG,encoded_string,res_cod,res_huf] = jpgcodng(IMP_IMG,blk_sz,qual,disp,coded,huf_speed);
%
% OUTPUT ARGUMENTS
%
% OUT_IMG - output coded image
% encoded_string - entropy encoded bit string suitable for transmission
% res_cod - coding parameters: psnr, MSE, compress_ratio, storage_ratio, entropy_impimg, entropy_dct,
%                              entropy_encoded, BPP_comp 
% res_huf - huffman encoding statistics: see description above 
%
% INPUT ARGUMENTS
%
% IMP_IMG - input image matrix, must be 8 bit gray levelled
% blk_sz - size of processing block for JPEG coding should be 8x8  syntax [8 8]:
% qual - JPEG quality factor 1....100 (integer)
% disp - if 1 results displayed, if 0 no display
% coded - if 1 there is huffman coding if 0 only DCT quantization 
% huf_speed - if 1 speed processing, only statistics, if 0, complete coding
%
%-------------------------------------------------------------------------------------------------
% This function needs the following m-files:
% zpad_blk, entrpy_calc_mb, mat2clmn, scld_qnt_jpg_mb, encode_jpg_mb, zigzag_mb, JPEGlike_mb
% de_zigzag_mb, decode_jpg_mb, clmn2mat_mb,  
%

psnr              = inf;
compress_ratio    = 0;
storage_ratio     = 0;
entropy_impimg    = 8;
entropy_dct_strng = 0;
entropy_encoded   = 0;
MSE = 0;
encoded_string=0;
res_huf=0;
%profile on;
x=0; waitbar(x,h);
sz_imp = size(IMP_IMG);
impimg_ = double(zpad_blk_mb(IMP_IMG, blk_sz,0));             % convert to double and pad with zeros to
sz = size(impimg_);                                        % achive the size of processed image to be
																			  % [m,n] = [block_row*blk_sz(1),block_col*blk_sz(2)]
entropy_impimg = entrpy_calc_mb(impimg_);                     % entropy (average bit allocation) for image values
bit_impimg = entropy_impimg*sz(1)*sz(2);                   % bit budget for original image: entropy (average BPP) * size of the image
% [impimg1,block_col,block_row] = mat2clmn_mb(impimg_,blk_sz);   % rescale the matrix in 8x8 blocks column
impimg = im2col(impimg_, blk_sz, 'distinct');
block_col = size(impimg_, 1) /blk_sz(1);
block_row = size(impimg_, 2) /blk_sz(2);
if blk_sz == [8 8]
   % do if conventional JPEG block: 8x8 pixels
   x=x+0.1; waitbar(x, h);
   quantizer = scld_qnt_jpg_mb(qual,0) ;                      % defines a quantization scaling matrix according to q [%]
   x=x+0.1; waitbar(x, h);														              % uses conventional luminocity JPEG quantization matrix
   dct_matrices = round(kron(dctmtx(8),dctmtx(8))*(impimg-128)./(quantizer(:)*ones(1,size(impimg,2))));

   entropy_dct = entrpy_calc_mb(dct_matrices);                % entropy (average bit allocation) for quantized dct components
   x=x+0.1; waitbar(x, h);
   bit_dct = entropy_dct*sz(1)*sz(2);                      % bit budget in quantized DCT
   if coded                                                     
      %dct_strings1 = zigzag_mb(dct_matrices1)';                    % resize quantized DCT blocks in order suitable for JPEGlike_mb:
      zi= [ 0,  1,  5,  6, 14, 15, 27, 28,
       2,  4,  7, 13, 16, 26, 29, 42,
       3,  8, 12, 17, 25, 30, 41, 43,
       9, 11, 18, 24, 31, 40, 44, 53,
      10, 19, 23, 32, 39, 45, 52, 54,
      20, 22, 33, 38, 46, 51, 55, 60,
      21, 34, 37, 47, 50, 56, 59, 61,
      35, 36, 48, 49, 57, 58, 62, 63]+1;
  
      dct_strings(zi(:), :) = dct_matrices;
      x=x+0.1; waitbar(x, h);     
      dct_sz = size(dct_strings);                             % a matrix where the first row is the DC component and the following
                                                              % rows are the AC components ordered in ascending frequencies
                                                              
      if (~huf_speed)                                                       
      	[encoded_string,res_huf] = JPEGlike_mb(huf_speed,dct_strings);       % Huffman encoding of DCT strings (better for long tails of zeros)

        entropy_encoded = entrpy_calc_mb(encoded_string);                                    % entropy (average bit allocation) for Huffman encoded dct components
        x=x+0.1; waitbar(x, h);         
   		%bit_encoded = entropy_encoded*length(encoded_string);   % bit budget for encoded strings
   		%BPP_comp = bit_encoded/prod(sz_imp);
   		%compress_ratio = bit_impimg/bit_encoded;                % Compress ratio budget of original/budget of compressed
   		%storage_ratio  = prod(sz_imp)/length(encoded_string);   % Storage ratio size of original/length of compressed (in assumption of 8 bit IO)

   		decoded_dct_strings = JPEGlike_mb(encoded_string,dct_sz(1),dct_sz(2)); % decoding of compressed strings
   		%decoded_dct_matrices = de_zigzag_mb(decoded_dct_strings'); % resize decoded strings in the form suitable for decoding (idct) of blocks

        decoded_dct_matrices = decoded_dct_strings(zi,:);
      else
      	[encoded_string,res_huf] = JPEGlike_mb(huf_speed,dct_strings);       % Huffman encoding of DCT strings (better for long tails of zeros)
        x=x+0.1; waitbar(x, h);
   		entropy_encoded = 8;                                    % entropy (average bit allocation) for Huffman encoded dct components
 
   		bit_encoded = entropy_encoded*length(encoded_string);   % bit budget for encoded strings
   		BPP_comp = bit_encoded/prod(sz_imp);
   		compress_ratio = bit_impimg/bit_encoded;                % Compress ratio budget of original/budget of compressed
   		storage_ratio  = prod(sz_imp)/length(encoded_string);   % Storage ratio size of original/length of compressed (in assumption of 8 bit IO)
   
   		decoded_dct_strings = dct_strings;                      % decoding of compressed strings
   
   		decoded_dct_matrices = de_zigzag_mb(decoded_dct_strings'); % resize decoded strings in the form suitable for decoding (idct) of blocks
        x=x+0.1; waitbar(x, h);
      end;
      status = ' [ Entropy Coding ]';
   else
          x=x+0.1; waitbar(x, h);
      decoded_dct_matrices = dct_matrices;
      BPP_comp = bit_dct/prod(sz_imp);
   	compress_ratio = bit_impimg/bit_dct;                 % Compress ratio budget of original/budget of compressed
      storage_ratio  = 1;                                  % Storage ratio size of original/length of compressed (in assumption of 8 bit IO)
      status = ' [ Only DCT quantization ]';
   end;
      x=x+0.1; waitbar(x, h);
    %dct_matrices = round(kron(dctmtx(8),dctmtx(8))*(impimg-128)./(quantizer(:)*ones(1,size(impimg,2))));
	outimg = kron(dctmtx(8)', dctmtx(8)')* (decoded_dct_matrices.*(quantizer(:)*ones(1,size(impimg,2))))+128;    % decode de-quantized  then idct the blocks
	   x=x+0.1; waitbar(x, h);
%   outimg_ = clmn2mat_mb(outimg,block_col,block_row,blk_sz);  % rescale the 8x8 blocks column to matrix
    outimg_ =col2im(outimg, blk_sz, size(impimg_), 'distinct');
       x=x+0.1; waitbar(x, h);
else                                                       % do if non conventional JPEG block: no 8x8 pixels
   outimg = impimg; 													  % do not perform any encoding/decoding
   outimg_ = clmn2mat_mb(outimg,block_col,block_row,blk_sz);  % rescale the 8x8 blocks column to matrix
   warning('Block Size is not 8x8 - no JPEG coding');
       x=x+0.1; waitbar(x, h);
end;
diff = impimg_-outimg_;
RMSE  = sqrt(var(diff(:),1));
psnr = 20*log10(255/(RMSE+eps/2)); % Peak SNR while Signal is an original and the noise power is MSE
size(outimg_);
OUT_IMG = outimg_(1:size(IMP_IMG,1),1:size(IMP_IMG,2)); % crop the output image according to original size
size(OUT_IMG);
   x=x+0.1; waitbar(x, h);
 
%Presentation
%iptsetpref('TruesizeWarning', 'off');
% if disp
%    figure(1);
%    imagesc(IMP_IMG); colormap(gray(256));axis off;axis image
%    title(['Input Image, BPP = ' num2str(entropy_impimg) status]);
%    figure(2);imagesc(OUT_IMG); colormap(gray(256));axis off;axis image
%    title(['Compressed Image Q = ' num2str(qual)  '; BPP = ' num2str(BPP_comp),'; DCT entropy = ' num2str(entropy_dct)]);
%    figure(3);image(diff+128); colormap(gray(256));axis off;axis image
%    title(['CodngErrPSNR = ' num2str(psnr)  'db, RMSE = ' num2str(RMSE)]);
%    figure(4);imagesc((fftshift(abs(fft2(diff)))).^0.2); colormap(gray(256));axis off;axis image
%    title(['AbsErrorSpectrum^0.2']);   
% end;
%Results
% res_cod = [psnr
%   		     MSE
%            compress_ratio
%            storage_ratio;
%            entropy_impimg
%            entropy_dct
%            entropy_encoded
% 	        BPP_comp];

%--------------------------------------------------
%profile viewer;