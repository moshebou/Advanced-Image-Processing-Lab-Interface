%% JPEG Coding Standard
%  Image Compression using Jpeg Coding Standard
%% Experiment Description:
% This experiment illustrates Jpeg compression format throw it various
% steps.
%
% 
%% Tasks:
% 
% 4.2.1. Image blocks. 
%
% Compute DCT coefficients for a 8x8 block of the original image (8-bit). Subtract
% from the block values value of 128 (in 8-bit scale) and compute DCT. Compare the range of resulting
% DCT values for both cases. Explain the reason for such a subtraction used in conventional JPEG.
%
% 4.2.2. Quantization. 
%
% 1. Generate different quantization matrices and use matlab program encode_jpg_block.m to
% perform quantization of 8x8 blocks of the input image. Calculate bit allocation for each
% quantized DCT coefficient.
% 2. Design different quantization tables for different Q-quality factors (matlab program
% scld_qnt_jpg.m )
% 3. Calculate quantization matrices for Q = 1,50,100. Find which Q corresponds to conventional
% JPEG quality (no scaling), to the worst quality, to the to best quality (compression with no
% losses at all).
% 4. Define the range in which DCT coefficients of 8x8 block of 8-bit image vary and estimate the
% number of quantization levels for DCT coefficients for different values of the quality factor.
%
% 4.2.3 Zigzag rearrangement. 
%
% 1. Use matlab program zigzag_block.m to rearrange quantized DCT coefficients. Compare
% streams obtained from adjacent blocks of the same image, not adjacent blocks of the same
% image and blocks from different images. Write a program for zigzag rearrangement of a table
% of arbitrary size.
% 2. Compare zigzag ordered streams and those sorted in descending order.
% 3. Calculate the number of trailing zeros in each stream. In standard JPEG, a special symbol
% End Of Block (EOB) is used to indicate the end of trailing zeros. Thus, for each block one
% needs at most 6 additional bits (log 2 64) to specify the length of the “nonzero” vector (it
% might contain zeros, but its last element is nonzero). Concatenate the “stripped” vectors and
% compute the entropy, then add the overhead information of 6 bits/block.
% 
% 4.2.4 Entropy coding. 
%
% 1. Using program entrpy_calc.m calculate the entropy of encoded data at different stages of the
% coding:
%
% * a. Entropy of 8x8 block of the original image
% * b. Entropy of the block after subtraction of 128.
% * c. Entropy of the quantized DCT block.
% * d. Entropy of Shannon-Huffman encoded string
%
% Compare these entropy values for different blocks. Which coding stage (DCT transformation,
% DCT coefficients quantization or Entropy coding) mostly contributes to compression
% efficiency?
%
% 2. Compute the entropy of quantized DCT block for different quality factors. Explain the
% dependence of quantized DCT block entropy on scaling factor of the quantization table.
%
% 3. Using program JPEGlike.m, perform Shannon-Huffman coding of quantized and rearranged
% DCT matrices. Encode the string, investigate the encoding results in “res”-output (see
% program help for more details), and finally decode the string using the same program
% JPEGlike.m. Check the “Losslessness” of this stage of coding-decoding.
% 
% 4.2.5. Decoding
%
% 1. Use Matlab program jpgcodng.m to get JPG-coded images using different input parameters.
% Compare visual image quality coded with different Q factors.
%
% 2. Compare output parameters of coding with different Q factors.
% 
% * PSNR/MSE.
% * Entropy at the different stages of coding vs. Q-factor
% * BPP vs. Q-factor.
%
% 3. Measure PSNR/MSE vs. Compression Ratio
%
% 4. Investigate the Quality Losses due to coding/compression. Compare coding error of images
% coded with different Q-factors. Investigate Fourier spectra of compression errors. In which
% regions of the image the largest errors are? Which artifacts appear at very low rates (high
% compression)?
%
%% Instruction:
% Use the 'Set quality parameter Q' to set the value of the quality
% parameter described in the *'Theoretical Background & algorithm'*
% section.
%% Theoretical Background & algorithm:
% The name "JPEG" stands for "Joint Photographic Experts Group", the name
% of the committee that created the JPEG standard and also other still
% picture coding standards.
%
% The JPEG standard specifies the codec, which defines how an image is
% compressed into a stream of bytes and decompressed back into an image.
% 
% The Jpeg standard compression is composed of 4 main steps:
% 
% *Image blocks-*
%
% In JPEG standard, the image is first separated to 8x8 distinct blocks,
% each block value is then subtracted by $2^{n-1}$ where $n$ is the number
% of bits used to represent the digital image, and the DCT transform of
% each block is then calculated. The DCT transform of each block is passed
% to the quantization phase.
%
% *Quantization -*
%
% The DCT coefficients are quantized, using a quantization table
% for DCT coefficients of luminance (intensity). A standard quantization table is shown in Fig. 1. The
% entries $W_{r,s}$ , in this table define the interval, to which a coefficient value is mapped.
%
% $$ W_{r,s}  = \left[ \begin{array} {llllllll}
%  16 &  11 &  10 &  16 &  24 &  40 &  51 & 61 \\ 
%  12 &  12 &  14 &  19 &  26 &  58 &  60 & 55\\ 
%  14 &  13 &  16 &  24 &  40 &  57 &  69 & 56\\ 
%  14 &  17 &  22 &  29 &  51 &  87 &  80 & 62\\ 
%  18 &  22 &  37 &  56 &  68 &  109 & 103 & 77\\ 
%  24 &  35 &  55 &  64 &  81 &  104 &  113 & 92\\ 
%  49 &  64 &  78 &  87 &  103 &  121 &  120 & 101\\ 
%  72 &  92 &  95 &  98 &  112 &  100 &  103 & 99
% \end{array} \right]$$
% 
% Figure 1. Intensity Quantization Table $W_{r,s}$
%
% In order to control the trade-off between reconstructed image quality and the bit rate, the quantization
% table can be modified using the quality parameter $Q$ that can assume values from 1 to 100. 
%
% Quantized DCT coefficients $\alpha_{r ,s}$  are obtained as:
% 
% $$ \hat{\alpha}_r =  round \left( \frac{\alpha_{r,s}}{\tilde{w}_{r,s}} \right) $$
% 
% where
%
% $$ \tilde{w}_{r,s}= floor \left( \frac{ScFact \cdot w_{r,s}+50}{100} \right)$$
%
% and
%
% $$ SCFact = \left\{ \begin{array} {lll} 
%  1, & Q = 100 \\ 
% 200-2 \cdot Q, & 50 \le Q \le 99 \\ 
%   \frac{5000}{Q}, & 1 \le Q \le 50 
% \end{array} \right. $$
%
% *Zigzag rearrangement -*
% 
% JPEG reorders the coefficients in each block by means of zigzag scan,
% thus converting a 8x8 squared array of quantized DCT coefficients to a 1-D string of 64 elements with
% the first one representing the DC component and the others representing
% AC elements.
%
% <<ZigZag.png>> 
%
% Figure 2. Zigzag reordering scheme
% 
% *Entropy coding -*
%
% In JPEG, a run length/entropy coding is applied to quantized AC coefficients
% (the sequence of DC coefficients is DPCM coded separately). The baseline implementation of the
% JPEG standard uses Shannon-Huffman coding.
%
% _Huffman coding_ 
%
% Huffman coding is an entropy encoding algorithm used for lossless data
% compression. The term refers to the use of a variable-length code table
% for encoding a source symbol (such as a character in a file) where the
% variable-length code table has been derived in a particular way based on
% the estimated probability of occurrence for each possible value of the
% source symbol. It was developed by David A. Huffman while he was a Ph.D.
% student at MIT, and published in the 1952 paper "A Method for the
% Construction of Minimum-Redundancy Codes". 
%
% Huffman coding uses a specific method for choosing the representation for
% each symbol, resulting in a prefix code (sometimes called "prefix-free
% codes", that is, the bit string representing some particular symbol is
% never a prefix of the bit string representing any other symbol) that
% expresses the most common source symbols using shorter strings of bits
% than are used for less common source symbols. Huffman was able to design
% the most efficient compression method of this type: no other mapping of
% individual source symbols to unique strings of bits will produce a
% smaller average output size when the actual symbol frequencies agree with
% those used to create the code. The running time of Huffman's method is
% fairly efficient, it takes  operations to construct it.
%
% *Decoding -*
%
%% Reference:
% * [1]  <http://www.w3.org/Graphics/JPEG/itu-t81.pdf "DIGITAL COMPRESSION AND CODING OF CONTINUOUS-TONE STILL IMAGES">
% * [2]  <http://compression.ru/download/articles/huff/huffman_1952_minimum-redundancy-codes.pdf D. Huffman, “A method for the construction of minimum redundancy codes,”Proc. IRE, vol. 40, pp. 1098-1101, September 1952.>
%%

function JPEGCodingStandard = JPEGCodingStandard_mb( handles )
%BLOCKTRANSFORMCODING_MB Summary of this function goes here
%Detailed explanation goes here

	handles = guidata(handles.figure1);
	axes_hor = 2;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	JPEGCodingStandard = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);
	% initial params
	JPEGCodingStandard.Q = 50;    
	JPEGCodingStandard.blk_sz = 8;
	JPEGCodingStandard.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run for specific quality levels';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run compression vs image quality';
	interface_params(k).callback = @(a,b)run_compression_vs_quality(a);
	k=k+1;
	interface_params =  SetSliderParams('Set quality factor Q', 100, 0, JPEGCodingStandard.Q, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Q',@update_sliders), interface_params, k);



	JPEGCodingStandard.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		 

    imshow(JPEGCodingStandard.im, [ 0 255], 'parent', JPEGCodingStandard.axes_1);
    DisplayAxesTitle( JPEGCodingStandard.axes_1, [ 'Test Image'], 'TM'); 

% 	process_image(handles.waitbar_handle, JPEGCodingStandard.im, JPEGCodingStandard.blk_sz, JPEGCodingStandard.Q ,...
% 	JPEGCodingStandard.axes_1, JPEGCodingStandard.axes_2, JPEGCodingStandard.axes_3);


end

function update_sliders(handles)
	if ( ~isstruct(handles))
		handles = guidata(handles);
	end
	if ( strcmpi(handles.interactive, 'on'))
		run_process_image(handles);
	end
	guidata(handles.figure1,handles );
end

function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
    JPEGCodingStandard = handles.(handles.current_experiment_name);
    handles.waitbar_handle = waitbar(0, 'please wait');
    guidata(handles.figure1, handles);
    process_image(handles.waitbar_handle, JPEGCodingStandard.im, JPEGCodingStandard.blk_sz, JPEGCodingStandard.Q ,...
        JPEGCodingStandard.axes_1, JPEGCodingStandard.axes_2, JPEGCodingStandard.axes_3,JPEGCodingStandard.axes_4);
    delete(handles.waitbar_handle);
    handles  = rmfield(handles,'waitbar_handle');
    guidata(handles.figure1, handles);
end


function run_compression_vs_quality(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
    JPEGCodingStandard = handles.(handles.current_experiment_name);
    handles.waitbar_handle = waitbar(0, 'please wait');
    guidata(handles.figure1, handles);
    process_image(handles.waitbar_handle, JPEGCodingStandard.im, JPEGCodingStandard.blk_sz, [0:20:100] ,...
        JPEGCodingStandard.axes_1, JPEGCodingStandard.axes_2, JPEGCodingStandard.axes_3,JPEGCodingStandard.axes_4);
    delete(handles.waitbar_handle);
    handles  = rmfield(handles,'waitbar_handle');
    guidata(handles.figure1, handles);
end


function process_image(h, im, blk_sz, Q_lvl, ...
    axes_1, axes_2, axes_3, axes_4)

for i = 1 : length(Q_lvl)
    Q = Q_lvl(i);
    [im_jpg,encoded_string,res_huf, entropy_impimg(i), entropy_dct(i), entropy_encoded] = jpgcodng_mb(h, im,[blk_sz blk_sz] ,Q, 0, 1,0);
    imshow(im_jpg, [ 0 255], 'parent', axes_2);
    DisplayAxesTitle( axes_2, ['JPEG restored image'], 'TM',10); 


%     l = legend(axes_3, 'Input Image Entropy', 'Entropy of compressed image', 'Huffman code bits per pixel', 'Location', 'best');

    RestErr=im-im_jpg;
    ErrorSTD=sqrt(mean(RestErr(:).^2)-(mean(RestErr(:))).^2);
    imshow(RestErr, [ ], 'parent', axes_4);
    DisplayAxesTitle( axes_4, [ 'Restoration error; ErrorSTD=',num2str(ErrorSTD,3)], 'RM',10); 
end
plot(Q_lvl, entropy_impimg,  'r', 'linewidth', 2, 'parent', axes_3); hold(axes_3, 'on');
plot(Q_lvl, entropy_dct, 'g', 'linewidth', 2, 'parent', axes_3); hold(axes_3, 'on');
%     scatter(Q, entropy_encoded, 5, 'b', 'filled', 'parent', axes_3); hold(axes_3, 'on');
set(axes_3, 'xlim', [0 100], 'ylim', [0 8]);
grid(axes_3, 'on');
figure_children = get(get(axes_3, 'parent'), 'children');
legend_handle = figure_children(strcmpi(get(figure_children, 'tag'), 'legend'));
if ( ~isempty(legend_handle))
    delete(legend_handle);
end
l = legend(axes_3, 'Input Image Entropy', 'Entropy of compressed image', 'Location', 'best');
ylabel( axes_3, [ 'Bits per pixel'], 'fontweight','bold', 'fontsize', 10);
xlabel(axes_3, 'Quality factor', 'fontweight','bold');
end

