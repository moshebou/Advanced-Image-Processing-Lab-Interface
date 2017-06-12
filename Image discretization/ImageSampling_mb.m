%% Image Sampling
%  Down sampling 2-d Images with and without LPF
%% Experiment Description:
% This experiment compares down-sampled 2-D images, one with LPF before the
% sampling, and the other without the LPF.
%% Tasks:
% * Compare sampling with the ideal low-pass filtering and simple decimation without
% low pass filtering.
% * Observe differences between optimally sampled and decimated images.
% * Determine the minimal bandwidth required to maintain the readability of the test text image (text256).
%% Instruction:
% For each axis, set the down-sample ratio using 'Set Sub-Sample Factor X (or Y)'.
%
%% Theoretical Background:
%
% *Sampling-*
%
% The sampling process of a continuous function $x(t)$ can be represented by:
%
% $$ x_s(t) = x(t) \cdot p(t) $$
%
% <<sampling0.png>>
%
% And in the frequency domain:
%
% $$ F \{ x_s(t)\} = F \{ x(t) \} *F \{ p(t) \} $$
%
% <<sampling1.png>>
%
% This convolution is very easy to carry out as $p(t)$ is composed
%       of a sequence of impulses. Note that after sampling $x(t)$ becomes
%       discrete and its spectrum becomes periodic accordingly.
%
%
% Now the sampling theorem can be easily obtained by observing the result above.
% Note that only when the sampling rate $f_s$ is more than twice the highest
% frequency component $f_{max}$ of the signal (called *Nyquist frequency*,
% can the signal be recovered from its discrete samples (by ideal low-pass
% filtering). Otherwise, some high frequency components in the signal will be
% mixed with some low frequency components, i.e., *aliasing* occurs, and the
% signal can never be reconstructed without error.
%
% To eliminate or reduce aliasing, we can:
%
% * Increase the sampling rate $f_s=\frac {1}{T_s}$ by reducing $T$ or/and
%
% * Reduce the high frequency component $f_{max}$ contained in the signal
%       by low-pass filtering it before sampling.
%
%% Algorithm:
%  input: Image, x_ratio, y_ratio
%
%       Not_LPF_Output_Image(j,i) = Image(1:step_y:end, 1:step_x:end, :)
%
%       image_lpf = convolution(lpf_filter ,Image); // convolution of the input image  with the lpf kernel.
%       LPF_Output_Image(j,i) = image_lpf(1:step_y:end, 1:step_x:end, :)
%% Reference:
% * [1]
% <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/L4_SignalDiscreti&Sampling.pdf
% L. Yaroslavsky, Lec. 4 Principles of signal digitization. Signal sampling>


function ImageSampling = ImageSampling_mb( handles )
% Tasks:
% Compare sampling with the ideal low-pass filtering and simple decimation without
% low pass filtering. Observe differences between optimally sampled and decimated images
% (program sampling.m). Determine the minimal bandwidth required to maintain the
% readability of the test text image (text256).
handles = guidata(handles.figure1);
axes_hor = 3;
axes_ver = 2;
button_pos = get(handles.pushbutton12, 'position');
bottom =button_pos(2);
left = button_pos(1)+button_pos(3);
ImageSampling = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);

% initial params

    ImageSampling.sub_sample_x = 1;
    ImageSampling.sub_sample_y = 1;
    ImageSampling.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
        k=1;
        interface_params(k).style = 'pushbutton';
        interface_params(k).title = 'Run Experiment';
        interface_params(k).callback = @(a,b)run_process_image(a);
        k=k+1;
        interface_params =  SetSliderParams('Set Sub-sampling Factor X', 5, 1, ImageSampling.sub_sample_x, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'sub_sample_x',@update_sliders), interface_params, k);
        k=k+1;
    interface_params =  SetSliderParams('Set Sub-sampling Factor Y', 5, 1, ImageSampling.sub_sample_y, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'sub_sample_y',@update_sliders), interface_params, k);

            
            
            
            
            
            
            
            
            

            ImageSampling.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
                 

        process_image(ImageSampling.im , ImageSampling.sub_sample_x, ImageSampling.sub_sample_y , ...
            ImageSampling.axes_1, ImageSampling.axes_2, ImageSampling.axes_3, ImageSampling.axes_4, ImageSampling.axes_5, ImageSampling.axes_6);

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
    ImageSampling = handles.(handles.current_experiment_name);
    process_image(ImageSampling.im , ImageSampling.sub_sample_x, ImageSampling.sub_sample_y , ...
        ImageSampling.axes_1, ImageSampling.axes_2, ImageSampling.axes_3, ImageSampling.axes_4, ImageSampling.axes_5, ImageSampling.axes_6);
end
function process_image(im, step_x, step_y, ...
    axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
    imshow(im, [0 255], 'parent',  axes_1);
    DisplayAxesTitle( axes_1, 'Test image', 'TM',10);
    sp = abs(fft2(im));
    show_spectrum(sp,  axes_4, 1);
    DisplayAxesTitle( axes_4, 'Test image DFT spectrum', 'BM',10);
    im_energy = sum(im(:).^2);
%     im_sub_sampled= imresize(im(1:step_y:end, 1:step_x:end, :),size(im), 'nearest');
    im_sub_sampled= im(1:step_y:end, 1:step_x:end, :);
    im_sub_sampled_rec=kron(im_sub_sampled,ones(step_y,step_x));


%     imshow(im_sub_sampled, [0 255], 'parent',  axes_2);
    imshow(im_sub_sampled_rec, [0 255], 'parent',  axes_2);
    DisplayAxesTitle( axes_2, 'Sub-sampled and reconstruced image: no LPF', 'TM',10);

    sp = abs(fft2(im_sub_sampled_rec));
    show_spectrum(sp, axes_5, 1);
    DisplayAxesTitle( axes_5, 'No LPF sub-sampled and reconstructed image DFT spectrum', 'BM',10);

    [SzY, SzX, SzZ] = size(im);
    BWX=1/step_x;BWY=1/step_y;
    BX=round(SzX*(1-BWX)/2);
    BY=round(SzY*(1-BWY)/2);
    mask=ones(SzY, SzX);


    % Display
    % figure(2);imshow(fftshift(mask));title('mask');drawnow,end

%     sp = reshape(sp(logical(mask)),  [sum(mask(:,1)) sum(mask(1,:))]);
%     sp = (1/length(mask(:)))*sp *(sum(mask(1,:))*sum(mask(:,1)));
%     im_sub_sampled_lpf=imresize(real(ifft2(sp)), [SzY, SzX], 'nearest');
%     im_sub_sampled_lpf = im_sub_sampled_lpf(1:step_y:end, 1:step_x:end, :);

    % fft lpf
%     mask(SzY/2+1-BY:SzY/2+1+BY,:)=zeros(2*BY+1,SzX);
%     mask(:,SzX/2+1-BX:SzX/2+1+BX)=zeros(SzY,2*BX+1);
%     sp=fft2(im);%fft2(im).*mask;
%     OUTIMG=real(ifft2(sp.*mask));

    % DCT lpf
    mask(end-2*BY:end,:)=zeros(2*BY+1,SzX);
    mask(:,end-2*BX:end)=zeros(SzY,2*BX+1);
    sp1=dct2(im);
    OUTIMG=real(idct2(sp1.*mask));

    im_sub_sampled_lpf = OUTIMG(1:step_y:SzY, 1:step_x:SzX);

    sp2=dct2(im_sub_sampled_lpf);%fft2(im).*mask;
    display_res = zeros(size(im));
    display_res(1:size(sp2,1), 1:size(sp2,2)) = sp2;
    im_sub_sampled_lpf=real(idct2(display_res));
    im_sub_sampled_lpf=sqrt(im_energy)*im_sub_sampled_lpf/sqrt(sum(im_sub_sampled_lpf(:).^2));
    imshow(im_sub_sampled_lpf , [0 255], 'parent', axes_3);
    DisplayAxesTitle( axes_3, 'LPF Sub-sampled and reconstruced image', 'TM');
    %sp = abs(sp);
    show_spectrum(fft2(im_sub_sampled_lpf),  axes_6, 1);
    DisplayAxesTitle( axes_6, 'LPF sub-sampled and reconstructed image DFT spectrum', 'BM');
 end
