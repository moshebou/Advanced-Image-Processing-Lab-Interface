%% Target Location
% Target Location and Object Detection in Cluttered Images
%% Experiment Description:
% Study of optimal adaptive linear filters for detection and localization of objects in
% cluttered images:
%
% # Comparison of the conventional matched filter and optimal adaptive
% correlators for target location on cluttered background.
% # Image “homogenization” for improving the correlational detection
% discrimination capability.
%
% This experiment demonstratet Signal de-noising capability of of local
% adaptive linear filters in the DCT domain, by supressing low enargy
% components.
%% Tasks:
% 9.1 Comparison of the conventional matched filter and optimal adaptive
% correlators for target location on cluttered background 
%
% # Compare conventional matched filter correlator (program mfcorr.m) and
% optimal adaptive filter correlator (program optcorr.m) in terms of the
% discrimination capability for location of targets of different size
% (color separated images chin_96b, chin_96r, chin_96b, 512x256),
% stereoscopic images mishstr1 and mishstr2). 
% # Evaluate localization reliability for different size of the target. 
%
% 9.2 Image “homogenization” for improving the correlational detection
% discrimination capability
% 
% # Test efficiency of using image “homogenization” (image calibration by local
% mean and standard deviation) as a preprocessing to improve the
% reliability of target location. 
% # Compare improvements for the matched filter and optimal adaptive filter
% correlators.
%
%% Instruction:
%% Theoretical Background:
% _Image homogenization_ 
%
% In cases when non re-adjustable localization device does not provide
% admissible localization reliability while the computational expenses for
% the implementation of the adjustable device one also can not afford one
% can accept an intermediate solution, an image preprocessing that improves
% image homogeneity. 
%
% The idea of image homogenization by preprocessing follows from the following reasoning. 
% In terms of the design of the optimal adaptive filter for the localization device, image can be
% regarded homogeneous if spectra of all image fragments involved in the
% averaging procedure in Eq.(4.2.4.4) are identical. 
% 
% While this is, in general, not the case, one can attempt to reduce the
% diversity of image local spectra by means of image preprocessing. 
%
% One of the computation-wise simplest preprocessing is the preprocessing
% that standardizes image local mean and local variance. 
% 
% In discrete signal representation, it is defined for image fragments of
% $(2\cdot N_1 +1) \cdot (2\cdot N_2 +1)$ pixels as: 
% 
% $$ (4.2.4.7) \hspace{0.5in} \hat{b}(k,l) = \sqrt{ \frac{1}{\sigma_{k,l}^2} } \cdot \left( b(k,l) - \mu_b^{k,l} \right)$$
%
% where (k, l) are running coordinates of the window central pixel,
%
% $$ (4.2.4.8) \hspace{0.5in} \mu_b^{k,l} = \frac{1}{(2\cdot N_1 +1) \cdot
% (2\cdot N_2 +1)} \cdot \sum_{n = -N_1}^{N_1} \sum_{m = -N_2}^{N_2} b(k-n,l-m) $$
%
% is image local mean over the window and
%
% $$ (4.2.4.9) \hspace{0.5in} \sigma_{k,l}^2 =  \frac{1}{(2 \cdot N_1 +1)
% \cdot (2 \cdot N_2 +1)} \sum_{n = -N_1}^{N_1} \sum_{m = -N_2}^{N_2}
% \left( b(k-n,l-m) - \mu_b^{k,l} \right) ^2 $$
%
% is its local variance. 
%
% Computation of image local mean and variance can be very efficiently
% carried out recursively such that the computational complexity does not
% depend on the window size ([3]). 
%
% Such an image homogenization procedure equalizes average of local power
% spectra over all frequencies and can be regarded as a zero order approximation to
% making them identical on each particular frequency. 
%
% Selection of the window size is governed by the image inhomogeneity.
%% Algorithm:
%
% <html>
% <pre class="codeinput">
% <p>Code:
% function [Y X]=mfcorr_mb(INPIMG1,TRGT)
%     % Matched filter correlation
%     % Call corr=mfcorr(INPIMG1,INPIMG2)
%     INPIMG1 = double(INPIMG1);
%     TRGT = double(TRGT);
%     %% filtering with matched filter
%     spimg = fft2(INPIMG1);
%     mtchfilter=conj(fft2(TRGT,size(spimg,1), size(spimg,2)));
%     corr=real(ifft2(spimg.*mtchfilter));
%     X = locatmax_mb(corr);
%     Y = X(2)+size(TRGT,1)/2 -4; X = X(1)+size(TRGT,2)/2 - 4;
% end
% </p>
% </pre>
% </html>
%
% <html>
% <pre class="codeinput">
% <p>Code:
% function [Y, X]=optcorr_mb(INPIMG1,TRGT, k)
%     % Optimal adaptive filter correlator
%     INPIMG1 = double(INPIMG1);
%     TRGT = double(TRGT);
%     spimg=fft2(INPIMG1);
%     mtchfilter=conj(fft2(TRGT, size(spimg,1), size(spimg,2)));
%     spimg2=(abs(spimg)).^2;
%     mask=ones(3);
%     if     k==0  
%         spimg2=conv2(spimg2,mask,'same');
%     else
%         spimg2=spimg2+(abs(mtchfilter).^2);
%     end
%     corr=real(ifft2(spimg.*mtchfilter./spimg2));
%     X = locatmax_mb(corr);
%     Y = X(2)+size(TRGT,1)/2 -4; X = X(1)+size(TRGT,2)/2 - 4;
%     end
% </p>
% </pre>
% </html>
%
% <html>
% <pre class="codeinput">
% <p>Code:
% function [Y X] = corr_coeff( im, target)
%    im = double(im);
%    target = double(target);
%    im_lcl_mean = filter2(ones(size(target))/length(target(:)), im);
%    target_mean = mean(target(:));
%    corr = filter2(target, im)- size(target,1)*size(target,2)*target_mean.*im_lcl_mean;
%    var_A = (filter2(ones(size(target)), im.^2) - size(target,1)*size(target,2)*im_lcl_mean.^2).^0.5;
%    var_B = sqrt(sum(sum(target.^2 - target_mean.^2)));
%    corr = corr./(var_A*var_B);
%     X = locatmax_mb(corr);
%    Y = X(2); X = X(1);
% end
% </p>
% </pre>
% </html>
%
%% Reference:
% # <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/Adv_imProc_6.pdf
% L.Yaroslavsky, Target location in clutter, Advanced Image Processing Lab:
% A Tutorial , EUSIPCO200, LECTURE 4.2>
% #
% # L. Yaroslavsky, M. Eden, Fundamentals of Digital Optics, Birkhauser, Boston,1996



function TargetLocationInClutter = TargetLocationInClutter_mb( handles )
% 9. 1 Comparison of the conventional matched filter and optimal adaptive correlators
% for target location on cluttered background
% Compare conventional matched filter correlator (program mfcorr.m) and optimal
% adaptive filter correlator (program optcorr.m) in terms of the discrimination capability
% for location of targets of different size (color separated images chin_96b, chin_96r,
% chin_96b, 512x256), stereoscopic images mishstr1 and mishstr2). Evaluate localization
% reliability for different size of the target.
% 9.2 Image “homogenization” for improving the correlational detection
% discrimination capability
% Test efficiency of using image “homogenization” (image calibration by local mean and
% standard deviation) as a preprocessing to improve the reliability of target location.
% Compare improvements for the matched filter and optimal adaptive filter correlators.

% 8.2 Target localization in correlated noise
% Repeat the same for correlated Gaussian noise of the same intensity. For target
% localization, modify appropriately matched filter to implement optimal filter. For
% generating correlated Gaussian noise, use results of the Lab. 6. Compare RMS of the
% localization error with corresponding results for white noise of the same intensity.
	handles = guidata(handles.figure1);
	axes_hor = 2;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	TargetLocationInClutter = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);

	% Create  test images, sharp and smooth

	TargetLocationInClutter.im_1 = HandleFileList('load' , HandleFileList('get' , handles.image_index));
	TargetLocationInClutter.im_2 = HandleFileList('load' , HandleFileList('get' , handles.image_index2));
% 	TargetLocationInClutter.TrgtWndSz = 3;
    TargetLocationInClutter.TrgtWndSz = 32;
	TargetLocationInClutter.PowerSpectrumEstimation =  'target spectrum';
% 	TargetLocationInClutter.SzW = 3;
    TargetLocationInClutter.SzW = 32;
%     TargetLocationInClutter.DetectionType = { 'Matched filter detection result', 'Homogenized matched filter result', ...
%         'Signal-to-Cluter optimal filter', 'Homogenized Optimal Filter Result', 'Correlation coefficient result'};
    TargetLocationInClutter.DetectionType = { 'Matched filter detection result', 'Homogenized matched filter result', ...
        'Signal-to-Cluter optimal filter', 'Correlation coefficient result'};
    TargetLocationInClutter.DetectionTypesEnable = true(1,length(TargetLocationInClutter.DetectionType));
	WndSz = [3,8, 16, 32, 48, 64, 96];

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);

    k=k+1;
% 	interface_params =  SetSliderParams('Set Homogenization Window Size', WndSz, 1,1, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzW',@update_sliders, WndSz), interface_params, k);
    interface_params =  SetSliderParams('Set homogenization window size', WndSz, 1,4,1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzW',@update_sliders, WndSz), interface_params, k);

    k=k+1;
% 	interface_params =  SetSliderParams('Set Target Window Size', WndSz, 1, 1, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'TrgtWndSz',@update_sliders, WndSz), interface_params, k);
    interface_params =  SetSliderParams('Set target window size', WndSz, 1, 4, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'TrgtWndSz',@update_sliders, WndSz), interface_params, k);
    k= k+1;       
	interface_params(k).style = 'buttongroup';
	interface_params(k).title = 'Background Spectrum Estimation';
	interface_params(k).selection ={ 'target spectrum', 'window smoothing'};   
	interface_params(k).callback = @(a,b)PowerSpectrumEstimation(a,b,handles); 
    
	k= k+1;       
	interface_params(k).style = 'buttongroup';
	interface_params(k).title = 'Detection Type';
    interface_params(k).value = 1;
%  	interface_params(k).choose ={ 'Matched Filter Detection', 'Homogenized Matched filter Result', ...
%         'Optimal Filter Results', 'Homogenized Optimal Filter Result', 'Correlation coefficient result'};   
	interface_params(k).choose ={ 'Matched filter detection result', 'Homogenized matched filter result', ...
        'Signal-to-Cluter ratio optimal filter result', 'Correlation coefficient result'};
    interface_params(k).callback = @(a,b)ChooseDetectionType(a,b,handles);
    


	TargetLocationInClutter.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
	  
	%
	image(TargetLocationInClutter.im_1,  'parent', TargetLocationInClutter.axes_1, 'ButtonDownFcn', @(a,b)ChooseObj(a,b));
	colormap(TargetLocationInClutter.axes_1, gray(256)); axis(TargetLocationInClutter.axes_1, 'off');
	DisplayAxesTitle( TargetLocationInClutter.axes_1, ['Source image: select a target using cursor'],'TM',10);
	image(TargetLocationInClutter.im_2,  'parent', TargetLocationInClutter.axes_2);
	colormap(TargetLocationInClutter.axes_2, gray(256)); axis(TargetLocationInClutter.axes_2, 'off');
	DisplayAxesTitle( TargetLocationInClutter.axes_2, ['Searched image'],'TM',10);
    im_hom = ImageHomogenization_mb( TargetLocationInClutter.im_2 , TargetLocationInClutter.SzW );
	image(uint8(255*im_hom), 'parent', TargetLocationInClutter.axes_3);
	colormap(TargetLocationInClutter.axes_3, gray(256)); axis(TargetLocationInClutter.axes_3, 'off');
	DisplayAxesTitle( TargetLocationInClutter.axes_3, ['Homogenized image'],'BM',10);

end

function ChooseObj(image_handles,y,z)
% think of changing it to work with hover axes callback, 
% when mous leave the axes, must use:
% global   GETRECT_H1 
% set(GETRECT_H1, 'UserData', 'Completed');
axes_handles  =get(image_handles, 'parent');
handles = guidata(axes_handles);
point = get(axes_handles, 'CurrentPoint');
handles.(handles.current_experiment_name).x = round(point(1,1));
handles.(handles.current_experiment_name).y = round(point(1,2));

guidata(axes_handles, handles);

process_image(handles.(handles.current_experiment_name).im_1, ...
    handles.(handles.current_experiment_name).im_2, ...
    handles.(handles.current_experiment_name).x, ...
    handles.(handles.current_experiment_name).y, ...
    handles.(handles.current_experiment_name).TrgtWndSz, ...
    handles.(handles.current_experiment_name).SzW, ...
    handles.(handles.current_experiment_name).PowerSpectrumEstimation, ...   
    handles.(handles.current_experiment_name).DetectionType, ...
    handles.(handles.current_experiment_name).DetectionTypesEnable, ...
    handles.(handles.current_experiment_name).axes_1, ...
    handles.(handles.current_experiment_name).axes_2, ...
    handles.(handles.current_experiment_name).axes_3);
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
    if ( isfield(handles.(handles.current_experiment_name), 'x' ))
        process_image(handles.(handles.current_experiment_name).im_1, ...
            handles.(handles.current_experiment_name).im_2, ...
            handles.(handles.current_experiment_name).x, ...
            handles.(handles.current_experiment_name).y, ...
            handles.(handles.current_experiment_name).TrgtWndSz, ...
            handles.(handles.current_experiment_name).SzW, ...
            handles.(handles.current_experiment_name).PowerSpectrumEstimation, ...
            handles.(handles.current_experiment_name).DetectionType, ...
            handles.(handles.current_experiment_name).DetectionTypesEnable, ...
            handles.(handles.current_experiment_name).axes_1, ...
            handles.(handles.current_experiment_name).axes_2, ...
            handles.(handles.current_experiment_name).axes_3);
    end
end


function PowerSpectrumEstimation(slider_handles,y,z)
    handles = guidata(slider_handles);
    handles.(handles.current_experiment_name).PowerSpectrumEstimation = get(y.NewValue, 'string');
    guidata(slider_handles, handles);
    run_process_image(handles);
end

function ChooseDetectionType(slider_handles,y,z)
    handles = guidata(slider_handles);
    handles.(handles.current_experiment_name).DetectionTypesEnable(strcmpi(get(slider_handles, 'string'), handles.(handles.current_experiment_name).DetectionType)) = get(slider_handles, 'value');
    guidata(slider_handles, handles);
    run_process_image(handles);
end

function process_image(im_1, im_2, X, Y, TrgtWndSz, SzW, PowerSpectrumEstimation, DetectionType, DetectionTypesEnable, axes_1, axes_2, axes_3)
    im_2_hom = ImageHomogenization_mb( im_2 , SzW );
    im_1_hom = ImageHomogenization_mb( im_1 , SzW );

    if ( strcmpi(PowerSpectrumEstimation, 'window smoothing') )
        k=0;
    else
        k=1;
    end

    TRGT_hom=target_mb(im_1_hom,Y, X, TrgtWndSz);
    TRGT=target_mb(im_1,Y, X, TrgtWndSz);

    image(im_1, 'parent', axes_1, 'ButtonDownFcn', @(a,b)ChooseObj(a,b));
    colormap(axes_1, gray(256)); axis(axes_1, 'off');  
    rect_handle = get(axes_1, 'children');
    rect_handle = rect_handle(strcmpi(get(rect_handle, 'type'), 'rectangle'));
    delete(rect_handle);
    rectangle('Position', [max(1, X-SzW/2), max(1, Y-SzW/2), SzW, SzW], 'parent', axes_1);  
    delete(get(axes_2, 'children'));
    imshow(im_2,  [0 255], 'parent', axes_2); colormap(gray(256));hold(axes_2, 'on');
    
    delete(get(axes_3, 'children'));
    imshow(uint8(255*im_2_hom),  [0 255], 'parent', axes_3); colormap(gray(256));hold(axes_3, 'on');    
    

    if ( sum(strcmpi(DetectionType(DetectionTypesEnable),  'Matched filter detection result' )))
        [x,y] = mfcorr_mb(im_2, TRGT);
        plot(x,y,'Color', 'r', 'Marker', '>', 'MarkerSize', 4, 'linewidth', 2, 'parent', axes_2); hold(axes_2, 'on');
    end

    if ( sum(strcmpi(DetectionType(DetectionTypesEnable),  'Homogenized matched filter result')))
        [x_hom, y_hom]= mfcorr_mb(im_2_hom, TRGT_hom);
        plot(x_hom,y_hom,'Color', 'r', 'Marker', '^', 'MarkerSize', 5,'linewidth', 2,'parent',  axes_3); hold(axes_3, 'on');
    end

    if ( sum(strcmpi(DetectionType(DetectionTypesEnable),  'Signal-to-Cluter optimal filter')))
        [opt_x, opt_y]= optcorr_mb(im_2_hom, TRGT_hom, k);
        plot(opt_x, opt_y,'Color', 'b', 'Marker', 'X', 'MarkerSize', 15, 'linewidth', 4, 'parent', axes_2); hold(axes_2, 'on');
    end
    if ( sum(strcmpi(DetectionType(DetectionTypesEnable),  'Homogenized Optimal Filter Result')))
        [opt_x_hom, opt_y_hom]=optcorr_mb(im_2_hom, TRGT_hom, k);
        hold(axes_3, 'on');
        plot(opt_x_hom, opt_y_hom,'Color', 'g', 'Marker', 'O', 'MarkerSize', 8,'linewidth', 2, 'parent', axes_3); 
    end


    if ( sum(strcmpi(DetectionType(DetectionTypesEnable),  'Correlation coefficient result')))
        [coeff_x, coeff_y] = corr_coeff(im_2, im_1(max(1,floor(Y-TrgtWndSz/2)):min(size(im_1,1),floor(Y+TrgtWndSz/2)-1 ), max(1,floor(X-TrgtWndSz/2)):min(size(im_1,2),floor(X+TrgtWndSz/2)-1)));
        plot(coeff_x, coeff_y,'Color', 'y', 'Marker', '<', 'MarkerSize', 9, 'linewidth', 2, 'parent', axes_2); hold(axes_2, 'on');
    end
    DetectionTypesEnable_axes_2 = true(1,length(DetectionTypesEnable));
    DetectionTypesEnable_axes_2(2) = false;
    DetectionTypesEnable_axes_2 = DetectionTypesEnable_axes_2&DetectionTypesEnable;
    h_legend = legend(axes_2, DetectionType(DetectionTypesEnable_axes_2));
    
    DetectionTypesEnable_axes_3 = false(1,length(DetectionTypesEnable));
    DetectionTypesEnable_axes_3(2) = true;
    DetectionTypesEnable_axes_3 = DetectionTypesEnable_axes_3&DetectionTypesEnable;
    h_legend2 = legend(axes_3, DetectionType(DetectionTypesEnable_axes_3));
    
    axes_2_units = get(axes_2, 'units');
    set(axes_2, 'units', 'points');
    axes_2_pos = get(axes_2, 'position');
    set(axes_2, 'units',axes_2_units);
    font_size = 10;
    legend_hight = font_size*5;
    axes_2_pos(4) = legend_hight;
    axes_2_pos(2) = axes_2_pos(2) - legend_hight;
    set(h_legend, 'units', 'points',  'Position', axes_2_pos, 'fontsize', font_size);
    
    axes_3_units = get(axes_3, 'units');
    set(axes_3, 'units', 'points');
    axes_3_pos = get(axes_3, 'position');
    set(axes_3, 'units',axes_3_units);
    font_size = 10;
    legend_hight = font_size*2.5;
    axes_3_pos(4) = legend_hight;
    axes_3_pos(2) = axes_3_pos(2) - legend_hight;    
    set(h_legend2, 'units', 'points',  'Position', axes_3_pos, 'fontsize', font_size);
    DisplayAxesTitle( axes_1, ['Source image: select a target using cursor'],'TM',10);
    DisplayAxesTitle( axes_2, ['Searched image'],'TM',10);
    DisplayAxesTitle( axes_3, ['Homogenized searched image'],'LM',10);
end

function [Y X] = corr_coeff( im, target)
   im = double(im);
   target = double(target);
   im_lcl_mean = filter2(ones(size(target))/length(target(:)), im);
   target_mean = mean(target(:));
   corr = filter2(target, im)- size(target,1)*size(target,2)*target_mean.*im_lcl_mean;
   var_A = (filter2(ones(size(target)), im.^2) - size(target,1)*size(target,2)*im_lcl_mean.^2).^0.5;
   var_B = sqrt(sum(sum(target.^2 - target_mean.^2)));
   corr = corr./(var_A*var_B);
    X = locatmax_mb(corr);
   Y = X(2)+4; X = X(1)+4;
end
