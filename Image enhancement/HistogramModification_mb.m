%% Histogram  Modification
%  Calibration of the imaging system dynamic range  
%% Experiment Description:
% This experiment illustrates calibration of image by manipulating the image histogram.
%
% Two calibrations are introduced:
%
% *Mean and variance calibration* - change the appearance of the image by
% modify the image global mean and variance.
%
% *Histogram match* - using an auxiliary image, match the histogram of the
% original image the the histogram of the auxiliary image.
%% Tasks:
% 
% 12.3.5 
%
% Test image enhancement by local histogram and P-histogram equalization in
% a running window (programs lchstequ.m and lcphsteq.m) for different
% window size and different non-linearity index P.
%
%% Instruction:
% Use the 'Set Mean of Test Image' and 'Set Variance of Test Image' slider to set the input image mean and variance.
% 
% Use the  'Load Auxiliary Image' icon on the tool bar to change the
% auxiliary image used for the histogram matching.
% auxiliary image used.
%% Theoretical Background & algorithm:
% *Global Histogram P-Equalization -*
%
% A method of contrast enhancement, which uses global image histogram to
% set the image histogram.
%
% $$mean_{global} =\frac{1}{height*width}\sum_{y=0}^{height-1}\sum_{x=0}^{width-1}{Image(x,y)} $$
% 
% $$var_{global} =\frac{1}{height*width}\sum_{y=0}^{height-1}\sum_{x=0}^{width-1}(Image(x,y) - mean_{global})^2$$
%
% $$ Image_{res}(x,y)= \frac{\sqrt{var_{desired}}(Image(x,y) - mean_{global})}{\sqrt{var_{global}}} + mean_{desired} $$
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
function HistogramModification = HistogramModification_mb( handles )
    %HistogramModification_mb Summary of this function goes here
    %   Detailed explanation goes here
    axes_hor = 4;
    axes_ver = 2;
    is_outerposition = zeros(1, axes_hor*axes_ver);
    is_outerposition(5:end) = 1;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    HistogramModification = DeployAxes( handles.figure1, ...
        [axes_hor, ...
        axes_ver], ...
        bottom, ...
        left, ...
        0.9, ...
        0.9, ...
        is_outerposition);
    %
    HistogramModification.im_1 = HandleFileList('load' ,  HandleFileList('get' , handles.image_index));
    HistogramModification.P = 0.5;
    HistogramModification.LX = 15;
    HistogramModification.LY = 15;
    %
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;           
    interface_params =  SetSliderParams('Set P-parameter of P-histogram equalization', 1, 0, HistogramModification.P, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'P',@update_sliders), interface_params, k);
    %
    k=k+1;
    interface_params =  SetSliderParams('Set Window Width', 55, 1, HistogramModification.LX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'LX',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set Window Height', 55, 1, HistogramModification.LY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'LY',@update_sliders), interface_params, k);
    %
        
    HistogramModification.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
         
    
    imshow( HistogramModification.im_1, [0 255], 'parent', HistogramModification.axes_1);
    DisplayAxesTitle( HistogramModification.axes_1, ['Test Image'],   'TM'); 

%     process_image(  HistogramModification.im_1, ...
%     HistogramModification.P, ...
%     HistogramModification.LX, ...
%     HistogramModification.LY, ...
%     HistogramModification.axes_1, ...
%     HistogramModification.axes_2, ...
%     HistogramModification.axes_3, ...
%     HistogramModification.axes_4, ...
%     HistogramModification.axes_5, ...
%     HistogramModification.axes_6, ...
%     HistogramModification.axes_7, ...
%     HistogramModification.axes_8...
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


        HistogramModification = handles.(handles.current_experiment_name);
        process_image(  HistogramModification.im_1, ...
            HistogramModification.P, ...
            HistogramModification.LX, ...
            HistogramModification.LY, ...
            HistogramModification.axes_1, ...
            HistogramModification.axes_2, ...
            HistogramModification.axes_3, ...
            HistogramModification.axes_4, ...
            HistogramModification.axes_5, ...
            HistogramModification.axes_6, ...
            HistogramModification.axes_7, ...
            HistogramModification.axes_8...
            );
end

function process_image( im, P, LX, LY, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6, axes_7,axes_8)



h = waitbar(0, 'please wait'); t=1;
[SzY SzX] = size(im);
OUTIMG1=phistequ_mb(im,1);
OUTIMG2=phistequ_mb(im,P);
waitbar(t/6, h); t=t+1;
Lx=floor((LX)/2);

Ly=floor((LY)/2);
% OUTIMG2_old=lchstequ_mb(im_1,LX,LY);
imgext=img_ext_mb(im,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding');
% center = im(:)*ones(1,SzW);

waitbar(t/6, h); t=t+1;

center = ones(size(nbhood,1), 1)*nbhood((LX*LY+1)/2, :);
waitbar(t/6, h); t=t+1;

Hist = hist(nbhood, [0:255]);
H = Hist.^P; 
waitbar(t/6, h); t=t+1;

sum_H = sum(H);
H = H./(ones(size(H,1),1)*sum_H);
rel_index = (([1:256]' * ones(1, size(H,2))) <=ones(size(H,1),1)* im(:)');
OUTIMG3 = reshape(255*(sum(H.*rel_index)), size(im));
waitbar(t/6, h); t=t+1;

% OUTIMG3=lcphsteq_mb(im_1,LX,LY,P);

h1 = histc(im(:), [0:255]);
h2 = histc(OUTIMG1(:), [0:255]);
h3 = histc(OUTIMG2(:), [0:255]);
h4 = histc(OUTIMG3(:), [0:255]);


imshow( OUTIMG1, [0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, ['Image equalization'],   'TM'); 
imshow( OUTIMG2, [0 255], 'parent', axes_3);
DisplayAxesTitle( axes_3, ['Image P-equalization'],   'TM'); 
imshow( OUTIMG3, [0 255], 'parent', axes_4);
DisplayAxesTitle( axes_4, ['Local P-equalization'],   'TM'); 
plot( h1, 'parent', axes_5, 'LineWidth', 2);

title( axes_5, ['Test image histogram'], 'fontweight', 'bold');  
plot( h2, 'parent', axes_6, 'LineWidth', 2);
title( axes_6, ['Image equalization histogram'], 'fontweight', 'bold'); 
plot( h3, 'parent', axes_7, 'LineWidth', 2);
title( axes_7, 'Image P-equalization histogram', 'fontweight', 'bold'); 
plot( h4,  'parent', axes_8, 'LineWidth', 2);
title( axes_8, {'Local P-equalization image histogram'}, 'fontweight', 'bold'); 
axis(axes_5, 'tight'); axis(axes_6, 'tight'); axis(axes_7, 'tight'); axis(axes_8, 'tight');
grid(axes_5, 'on'); grid(axes_6, 'on'); grid(axes_7, 'on'); grid(axes_8, 'on');

waitbar(1,h);
close(h);
end
