%% Dynamic Range Calibration
%  Calibration of the imaging system dynamic range  
%% Experiment Description:
% This experiment illustrates calibration of image by manipulating the image histogram.
%
% Two calibrations are introduced:
%
% *Mean and STD calibration* - change the appearance of the image by
% modify the image global mean and STD.
%
% *Histogram match* - using an auxiliary image, match the histogram of the
% original image to the histogram of the auxiliary image.
%% Tasks:
% 
% 12.1.1
% Write a program for image calibration by reducing image mean and standard deviation to
% certain standard values. 
%
% Write a program for image calibration by reducing image mean and standard deviation to those of a certain reference image. 
% Observe the results.
%  
% 12.1.2 
% Observe image histogram standardization (program histosta.m). 
%
% Compare the results with standardization by mean and standard deviation.
%% Instruction:
% Use the 'Set Mean of Original Image' and 'Set STD of Original Image' slider to set the input image mean and standard deviation.
% 
% Use the  'Load Auxiliary Image' icon on the tool bar to change the
% auxiliary image used for the histogram matching.
% auxiliary image used.
%% Theoretical Background & algorithm:
% *Mean and standard deviation calibration -*
%
% A method of adjusting image appearance by changing the image global mean
% and standard deviation values to desired values.
%
% $$mean_{global} =\frac{1}{height*width}\sum_{y=0}^{height-1}\sum_{x=0}^{width-1}{Image(x,y)} $$
% 
% $$STD_{global} =\sqrt{ \frac{1}{height*width}\sum_{y=0}^{height-1}\sum_{x=0}^{width-1}(Image(x,y) - mean_{global})^2 }$$
%
% $$ Image_{res}(x,y)= \frac{ STD_{desired}(Image(x,y) - mean_{global})}{STD_{global}} + mean_{desired} $$
%
% *Histogram match -* 
%
% A method in image processing for color adjustment of two images using the image histograms.
%
% It can be used to normalize two images, when the images were acquired at
% the same local illumination (such as shadows) over the same location, but by different sensors, atmospheric conditions or global illumination.
%
% Given two images with $$ 2^n $$ gray levels:
%
% 1. Calculate the images histograms and the cumulative sum of the
% histograms:
%
% $$histogram_{Im1}(k) = \left( \#pixels \in Im1 \mid pixel_{val} = k\right) $$
%
% $$cum\_sum\_hist_{Im1}(l) = \sum_{k=0}^{k=l}{histogram_{Im1}(k)} $$
%
% $$histogram_{Im2}(k) = \left( \#pixels \in Im2 \mid pixel_{val} = k\right) $$
%
% $$cum\_sum\_hist_{Im2}(l) = \sum_{k=0}^{k=l}{histogram_{Im2}(k)} $$
%
% 2. Define a lut such that each lut(p) is the number of cases for which
% the cum_sum_hist of Im2 is smaller or equal to cum_sum_hist Im1.
%
% $$\delta (t) = \left\{\begin{array}{cc} 1 & t=True \\ 0 & t=False\end{array}\right. $$
%
% $$lut(p) = \sum_{l=0}^{l=2^n}\delta(cum\_sum\_hist_{Im2}(l)<cum\_sum\_hist_{Im1}(p))$$
%
% $$Image_{res}(x,y) = lut(Im1(x,y))$$
%%


function ImageDynamicRangeCalibration = ImageDynamicRangeCalibration_mb( handles )
% Dynamic Range Calibration
%  Calibration of the imaging system dynamic range

    axes_hor = 4;
    axes_ver = 2;
    is_outerposition = zeros(1, axes_hor*axes_ver);
    is_outerposition(5:end) = 1;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    ImageDynamicRangeCalibration = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9, ...
    is_outerposition);


    ImageDynamicRangeCalibration.im_1 = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    ImageDynamicRangeCalibration.im_2 = HandleFileList('load' , HandleFileList('get' , handles.image_index2));
    ImageDynamicRangeCalibration.mean = 128;
    ImageDynamicRangeCalibration.std = 0.4;

    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;
    interface_params =  SetSliderParams('Set image StDev (in fraction of image range)', ...
    4, 0, ImageDynamicRangeCalibration.std, ...
    0.25, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'std',@update_sliders), interface_params, k); 

    k=k+1;
    interface_params =  SetSliderParams('Set image mean value', ...
    255, 0, ImageDynamicRangeCalibration.mean, ...
    1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'mean',@update_sliders), interface_params, k);

    ImageDynamicRangeCalibration.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
     

    imshow( ImageDynamicRangeCalibration.im_1, [0 255], 'parent', ImageDynamicRangeCalibration.axes_1);
    DisplayAxesTitle( ImageDynamicRangeCalibration.axes_1, {['Test image'], ...
        ['Mean = ' num2str(mean(ImageDynamicRangeCalibration.im_1(:)), '%0.1f') ],...
        ['StDev = ' num2str(std(ImageDynamicRangeCalibration.im_1(:),1), '%0.1f') ]},'TM',10);
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
        ImageDynamicRangeCalibration = handles.(handles.current_experiment_name);
        process_image( ImageDynamicRangeCalibration.im_1, ...
            ImageDynamicRangeCalibration.im_2, ...
            ImageDynamicRangeCalibration.mean, ...
            ImageDynamicRangeCalibration.std, ...
            ImageDynamicRangeCalibration.axes_1, ...
            ImageDynamicRangeCalibration.axes_2, ...
            ImageDynamicRangeCalibration.axes_3, ...
            ImageDynamicRangeCalibration.axes_4, ...
            ImageDynamicRangeCalibration.axes_5, ...
            ImageDynamicRangeCalibration.axes_6, ...
            ImageDynamicRangeCalibration.axes_7, ...
            ImageDynamicRangeCalibration.axes_8...
            );

end

function process_image( im_1, im_2, mean_ref, std_ref, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6, axes_7,axes_8)
im_1 = double(im_1);
im_2 = double(im_2);
% mean_ref = mean(im_2(:));
% std_ref = std(im_2(:));

mean_src = mean(im_1(:));
std_src = std(im_1(:),1);

OUTIMG2 = std_ref *(im_1 - mean_src) + mean_ref;
h4 = histc(OUTIMG2(:), [0:255]);
[h1, h2, OUTIMG, h3]=histosta_mb(im_1,im_2);


imshow( im_2, [0 255], 'parent', axes_4);
DisplayAxesTitle( axes_4, {'Reference image with:',['Mean = ' num2str(mean(im_2(:)), '%0.1f') ],['StDev = ' num2str(std(im_2(:),1), '%0.1f') ]},'TM',10); 
imshow( OUTIMG, [0 255], 'parent', axes_3);
% DisplayAxesTitle( axes_3, {'Original Image' 'Histogram Matched'},   'TM'); 
DisplayAxesTitle( axes_3, {'Test image with histogram' 'matched to that of reference image'},'TM',10);
imshow( OUTIMG2, [0 255], 'parent', axes_2);
% DisplayAxesTitle( axes_2, {'Original Image With:',['Mean = ' num2str(mean(OUTIMG2(:))) ],['Std = ' num2str(std(OUTIMG2(:),1)) ]},   'TM'); 
DisplayAxesTitle( axes_2, {'Test image with calibreated Mean and StDev:',['Mean = ' num2str(mean(OUTIMG2(:)), '%0.1f')],['StDev = ' num2str(std(OUTIMG2(:),1), '%0.1f')]},'TM'); 
plot( h1, 'parent', axes_5, 'Linewidth',2);
grid(axes_5, 'on');
title( axes_5, {['Test image histogram']}, 'fontweight', 'bold');
axis(axes_5, 'tight');
plot( h2, 'parent', axes_8, 'Linewidth',2);
grid(axes_8, 'on');
title( axes_8, {['Reference image histogram']}, 'fontweight', 'bold');
axis(axes_8, 'tight');
plot( h3, 'parent', axes_7, 'Linewidth',2);
title( axes_7, {['Histogram matched to'],  ['that of reference image']}, 'fontweight', 'bold');
axis(axes_7, 'tight');
grid(axes_7, 'on');
plot( h4,  'parent', axes_6, 'Linewidth',2);
title( axes_6, {['Image histogram with'], ['calibrated Mean and StDev']}, 'fontweight', 'bold');
axis(axes_6, 'tight');
grid(axes_6, 'on');
end
