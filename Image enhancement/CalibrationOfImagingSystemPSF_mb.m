%% Point Spread Function Calibration
% Calibration of the imaging system point spread function
%% Experiment Description:
% This experiment illustrates calibration of image PSF
%
% Two calibrations are introduced:
%
% *Aperture correction by unsharp masking* - enhance edges (sharp regions)
% by adding unsharp mask to the blurred image.
%
% *Inversion of aperture distortions with a rectangle aperture* - using an auxiliary image, match the histogram of the
% original image the the histogram of the auxiliary image.
%% Tasks:
% 
% 12.2.1
% Test aperture correction of image scanning and display devices for different images.
%
% Observe amplification of noise when correcting noisy images. 
%
% Determine admissible signal-to-noise ratio (SNR).
%
%% Instruction:
% Use the 'Set Mean' and 'Set Variance' slider to set the input image mean and variance.
% 
% Use the  'Load Auxiliary Image' icon on the tool bar to change the
% auxiliary image used for the histogram matching.
% auxiliary image used.
%% Theoretical Background & algorithm:
% _*Point spread function (PSF)-*_
%
% The point spread function (PSF) describes the response of an imaging
% system to a point source or point object. 
%
% A more general term for the PSF is a system's impulse response, the PSF being the impulse response of a
% focused optical system. 
% 
% The PSF in many contexts can be thought of as the
% extended blob in an image that represents an unresolved object. 
%
% In functional terms it is the spatial domain version of the modulation
% transfer function. 
%
% The degree of spreading (blurring) of the point object
% is a measure for the quality of an imaging system. In incoherent imaging
% systems such as fluorescent microscopes, telescopes or optical
% microscopes, the image formation process is linear in power and described
% by linear system theory. 
%
% This means that when two objects A and B are
% imaged simultaneously, the result is equal to the sum of the
% independently imaged objects. 
%
% In other words: the imaging of A is unaffected by the imaging of B and vice versa, owing to the
% non-interacting property of photons. 
%
% The image of a complex object can
% then be seen as a convolution of the true object and the PSF.
% 
% The Fourier Transform of a PSF is called Optical Transfer Function.
% 
% _*Point Spread Function Correction Methods-*_
%
% Two methods are introduced to reduce the blur effect of a given PSF
% function.
%
% *Aperture correction by unsharp masking:* 
%
% The Aperture correction by unsharp masking method of reducing PSF blur
% uses enhances the high frequency image by adding to the original image
% the high frequency image multiplied by a given factor.
%
% The algorithm steps:
%
% 1. Define a high frequency mask:
%
% $$ apmask= \left[ \begin{array}{ccc} -0.1 & -0.15 & -0.1 \\ -0.15 & 1 & -0.15 \\ -0.1 & -0.15 & -0.1 \end{array}\right] $$
% 
% 2. Extract the high frequency image by filtering the input image with
% $apmask$:
%
%  Highfrequency_{im} = conv2(INPIMG,apmask)
function CalibrationOfImagingSystemPSF = CalibrationOfImagingSystemPSF_mb( handles )
    %CalibrationOfImagingSystemPSF_mb Summary of this function goes here
    %   Detailed explanation goes here
    axes_hor = 2;
    axes_ver = 2;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    CalibrationOfImagingSystemPSF = DeployAxes( handles.figure1, ...
        [axes_hor, ...
        axes_ver], ...
        bottom, ...
        left, ...
        0.9, ...
        0.9);
    CalibrationOfImagingSystemPSF.im_1 = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    CalibrationOfImagingSystemPSF.thr = 30;
    CalibrationOfImagingSystemPSF.g = 1;
    CalibrationOfImagingSystemPSF.blur_var = 5;
    CalibrationOfImagingSystemPSF.blur_sz = 5;
    CalibrationOfImagingSystemPSF.noise_std = 0.05;
    %
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);

    k=k+1;
    interface_params =  SetSliderParams('Set g Gain Of Difference Signal', ...
    10, 0, CalibrationOfImagingSystemPSF.g, ...
    1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'g',@update_sliders), interface_params, k); 

    k=k+1;
    interface_params =  SetSliderParams('Set Threshold', ...
    256, 0, CalibrationOfImagingSystemPSF.thr, ...
    1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'thr',@update_sliders), interface_params, k);

    k=k+1;
    interface_params =  SetSliderParams('Set awgn STD', 128, 0, CalibrationOfImagingSystemPSF.noise_std, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'noise_std',@update_sliders), interface_params, k);

    k=k+1;
    interface_params =  SetSliderParams('Set Blur Kernel Var', ...
    10, 0, CalibrationOfImagingSystemPSF.blur_var, ...
    1/10, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'blur_var',@update_sliders), interface_params, k); 

    k=k+1;
    interface_params = SetSliderParams('Set Size Of Blur Kernel', ...
    17, 1, CalibrationOfImagingSystemPSF.blur_sz, ...
    2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'blur_sz',@update_sliders), interface_params, k); 

    


    
    
    
    
    
    
    
    
    

    CalibrationOfImagingSystemPSF.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
                     

    imshow( CalibrationOfImagingSystemPSF.im_1, [0 255], 'parent', CalibrationOfImagingSystemPSF.axes_1);
    DisplayAxesTitle( CalibrationOfImagingSystemPSF.axes_1, ['Test image'],   'TM'); 

%     process_image( CalibrationOfImagingSystemPSF.im_1, ...
%     CalibrationOfImagingSystemPSF.thr, ...
%     CalibrationOfImagingSystemPSF.g, ...
%     CalibrationOfImagingSystemPSF.blur_var, ...
%     CalibrationOfImagingSystemPSF.blur_sz, ...
%     CalibrationOfImagingSystemPSF.noise_std, ...
%     CalibrationOfImagingSystemPSF.axes_1, ...
%     CalibrationOfImagingSystemPSF.axes_2, ...
%     CalibrationOfImagingSystemPSF.axes_3, ...
%     CalibrationOfImagingSystemPSF.axes_4 ...
%     );
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


        CalibrationOfImagingSystemPSF = handles.(handles.current_experiment_name);
        process_image( CalibrationOfImagingSystemPSF.im_1, ...
            CalibrationOfImagingSystemPSF.thr, ...
            CalibrationOfImagingSystemPSF.g, ...
            CalibrationOfImagingSystemPSF.blur_var, ...
            CalibrationOfImagingSystemPSF.blur_sz, ...
            CalibrationOfImagingSystemPSF.noise_std, ...
            CalibrationOfImagingSystemPSF.axes_1, ...
            CalibrationOfImagingSystemPSF.axes_2, ...
            CalibrationOfImagingSystemPSF.axes_3, ...
            CalibrationOfImagingSystemPSF.axes_4 ...
            );
end
function process_image( im_1, thr, g, blur_var, blur_sz, noise_std, axes_1, axes_2, axes_3, axes_4)



im_1 = double(im_1);
blur = fspecial('Gaussian', blur_sz, blur_var+eps);
im_1 = imfilter(im_1, blur, 'symmetric', 'same');
im_1 = uint8(im_1 + noise_std * randn(size(im_1)));



apertcor_res = apertcor_mb(im_1, g, thr);
invapert_res = invapert_mb(im_1, g, thr);
imshow( im_1, [0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, {['Blurred input image with noise'], [ 'SNR = ' num2str(mean(im_1(:))/noise_std, '%0.1f') ]},   'TM'); 
imshow( apertcor_res, [0 255], 'parent', axes_3);
DisplayAxesTitle( axes_3, ['Aperture correction by unsharp masking'],   'BM'); 
imshow( invapert_res, [0 255], 'parent', axes_4);
DisplayAxesTitle( axes_4, ['Frequency response correction'],   'BM'); 
end
