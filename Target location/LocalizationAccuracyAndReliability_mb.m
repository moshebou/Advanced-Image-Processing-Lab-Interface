%% LocalizationAccuracyAndReliability
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
% 8.1 Target localization in white noise
%
% # Generate two test target images of the same energy: sharp and smooth ones. 
% # Generate test image with targets on uniform background. 
% # Write a program that adds to the test image a Gaussian noise of different variance. 
% # Implements matched filters for each target, measures localization error
% and can be run repeatedly to measure RMS of the localization error over a
% set of experiments and to compute localization error histogram.
% # Perform statistical experiment to compute distribution histogram of the
% localization error and to determine how RMS of the localization error
% depends on the SNR. 
% # Observe and explain the threshold effect in the localization reliability. 
% # Compare localization error for the two test target images.
%
% 8.2 Target localization in correlated noise
%
% # Repeat the same for correlated Gaussian noise of the same intensity.
% # For target localization, modify appropriately matched filter to implement optimal filter.
% # For generating correlated Gaussian noise, use results of the Lab. 6. 
% # Compare RMS of the localization error with corresponding results for white noise of the same intensity.
%
%% Instruction:
%% Theoretical Background:
% __Estimation of signal position: AWGN-model__
%
% An important special case of image parameter estimation is that of object localization. 
%
% The goal of the localisation is determination of co-ordinates of a given target object in image. 
%
% Let $(x_0, y_0)$ are unknown co-ordinates of a target defined by its
% samples $S_k^{tr} (x_0, y_0)$ that are observed in a mixture with
% additive white Gaussian signal independent noise. (AWGN model). 
%
% Then, the MAP co-ordinate estimation $ (\hat{x}_0, \hat{y}_0)$ is defined
% by the following equation:
%
% $$ (\hat{x}_0, \hat{y}_0) = argMax_{(x,y)} \left(\int_{-\infty}^{\infty}
% \int_{-\infty}^{\infty} s^{inp}(x,y) s^{tr}(x - x_0,y - y_0) +N_0 \cdot
% ln(p(x_0, y_0))\right)$$
%
% Since target co-ordinates are shift parameters, computation target signal
% – input signal correlation function needed for finding optimal
% co-ordinate estimate $ (\hat{x}_0, \hat{y}_0)$ can be implemented by
% input signal filtering by a linear filter with impulse response $S^{tr}(x, y )$. 
%
% Such an implementation is called matched filtering ([4]). 
%
% In digital image processing, matched filtering can be efficiently
% implemented in Fourier domain by means of Fast Fourier Transform
% algorithms.
%
% Frequency response $H_{opt}(f_x, f_y)$ of the matched filter can be found
% as complex conjugate to Fourier transform spectrum $\alpha(f_x, f_y)$ of the
% target signal:
%
% $$H_{opt}(f_x, f_y) =  \alpha^*(f_x, f_y) $$
%
% The matched filtering concept can be extended to target localization in multi-component images. 
% For optimal localization of a target in multi-component images with
% uncorrelated additive Gaussian noise, one should sum up outputs of the
% corresponding component wise matched filters to obtain a resulting
% correlation signal in which position of maximum should be found and taken as the co-ordinate estimate. 
%
% __Target location in correlated (non white) noise__
%
% If additive observation noise is correlated (non white) the problem of
% optimal target location can be reduced to that in white noise, if one
% puts input signal that contain now white noise through a filter that
% converts non white noise with spectral density $N(f_x, f_y)$ into white
% one. This filter is called “whitening” filter.  
% Its frequency response is inversely proportional to square root of noise spectral density:
%
% $$ H_w(f_x, f_y) = \frac{1}{\sqrt{N(f_x, f_y)}} $$
%
% Obviously, the same whitening filtering should be applied to the target
% signal as well.
%
% In the implementations, one can combine matched filtering and input and
% target signal whitenings into one filter with frequency response:
%
% $$ H_{opt} (f_x, f_y) = \frac{I^* (f_x, f_y)}{N(f_x, f_y)} $$
%
% This filter is called “optimal” filter. 
%
% One can show ([4]) that the optimal filter provides maximum to the ratio
% of signal peak at its output in the point of the target location to
% standard deviation of the additive noise for any distribution of noise in the input signal. 
%
% Optimal filter is most frequently a sort of a band pass filter, since it
% represents a compromise between the need of suppressing correlated noise
% with most of its energy concentrated in low frequencies while preserving
% substantial part of the target signal energy that may be spread more uniformly in the bandwidth.
%% Algorithm:
% Matched filter (for AWGN case):
%
% <html>
% <pre class="codeinput">
% <p>Code:
% function [X, Y] = MatchedFilter(im_w_noise, target)
%     spimg = fft2(im_w_noise);
%     mtchfilter=conj(fft2(target,size(spimg,1), size(spimg,2)));
%     corr=fftshift(real(ifft2(spimg.*mtchfilter)));
%     X = locatmax_mb(corr);
%     Y = size(corr,1) - X(2)-0.5*size(target,1); X = size(corr,2) -X(1)-0.5*size(target,2);
% end
% </p>
% </pre>
% </html>
%
% Optimal filter (for CWGN case):
%
% <html>
% <pre class="codeinput">
% <p>Code:
% function [X Y] = OptimalFilter (im_w_noise, target, RE, RI)
%     N = max(size(im_w_noise,1), size(im_w_noise,2));
%     RING=255*ones(N);CX=N/2+1;CY=N/2+1;
%     for x=1:N,
%         for y=1:N,
%             if (((x-CX)^2 + (y-CY)^2)<(RI*N/2)^2)
%                 RING(x,y)=0;
%             elseif (((x-CX)^2 + (y-CY)^2)>(RE*N/2)^2)
%                 RING(x,y)=0;
%             else
%                 RING(x,y)=255;
%             end
%         end
%     end
%     RING=fftshift(RING);
%     spimg = fft2(im_w_noise);
%     RING = RING.*(RING~=0)+0.0001.*(RING==0);
%     spimg = spimg./RING;
%     mtchfilter=conj(fft2(target, size(spimg,1), size(spimg,2)));
%     corr=fftshift(real(ifft2(spimg.*mtchfilter)));    
%     X = locatmax_mb(corr);
%     Y = size(corr,1) - X(2)-0.5*size(target,1); X = size(corr,2) -X(1)-0.5*size(target,2);
% end
% end
% </p>
% </pre>
% </html>
%% Reference:
% # <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_5.pdf L.
% Yaroslavsky, Image parameter estimation, Advanced Image Processing Lab: A
% Tutorial , EUSIPCO200, LECTURE 4.1>
% # <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/Adv_imProc_6.pdf
% L.Yaroslavsky, Target location in clutter, Advanced Image Processing Lab:
% A Tutorial , EUSIPCO200, LECTURE 4.2> 
% # A. Van der Lugt, Signal Detection by Complex Spatial Filtering, IEEE
% Trans., IT-10, 1964, No. 2, p. 139 
% # L.P. Yaroslavsky, The Theory of Optimal Methods for LocalizationAccuracyAndReliability of
% Objects in Pictures, In: Progress in Optics, Ed. E. Wolf, v. XXXII,
% Elsevier Science Publishers, Amsterdam, 1993
% # L. Yaroslavsky, M. Eden, Fundamentals of Digital Optics, Birkhauser,
% Boston, 1996
% # L. Yaroslavsky, Target Location: Accuracy, Reliability and Optimal
% Adaptive Filters, TICSP series, Tampere Int. Center for Signal
% processing, TTKK, Monistamo, 1999
function LocalizationAccuracyAndReliability = LocalizationAccuracyAndReliability_mb( handles )
% LocalizationAccuracyAndReliability
%
% 8.1 Target localization in white noise
% Generate two test target images of the same energy: sharp and smooth ones. 
% Generate test image with targets on uniform background. 
% Write a program that adds to the test image a Gaussian noise of different variance. 
% Implements matched filters for each target, measures localization error and can be run repeatedly to measure RMS of the localization
% error over a set of experiments and to compute localization error histogram. 
% Perform statistical experiment to compute distribution histogram of the localization error and to
% determine how RMS of the localization error depends on the SNR. Observe and explain
% the threshold effect in the localization reliability. Compare localization error for the two
% test target images.
% 8.2 Target localization in correlated noise
% Repeat the same for correlated Gaussian noise of the same intensity. For target
% localization, modify appropriately matched filter to implement optimal filter. For
% generating correlated Gaussian noise, use results of the Lab. 6. Compare RMS of the
% localization error with corresponding results for white noise of the same intensity.
    handles = guidata(handles.figure1);
    axes_hor = 3;
    axes_ver = 2;
    is_outerposition = zeros(1, axes_hor*axes_ver);
    is_outerposition([3, 6]) = 1;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    LocalizationAccuracyAndReliability = DeployAxes( handles.figure1, ...
        [axes_hor, ...
        axes_ver], ...
        bottom, ...
        left, ...
        0.9, ...
        0.9, ...
        is_outerposition);

    % Create  test images, sharp and smooth
    A = load('Character_o.mat'); B = load('Character_o_sm.mat');
    LocalizationAccuracyAndReliability.im1 = A.letter_o;
    LocalizationAccuracyAndReliability.im2 = B.Character_o_sm;
    % initial params
    LocalizationAccuracyAndReliability.noise_type = 'awgn';
    LocalizationAccuracyAndReliability.RE = 0.1;
    LocalizationAccuracyAndReliability.RI = 0;
    LocalizationAccuracyAndReliability.number_of_experiments = 1000;
    LocalizationAccuracyAndReliability.snr = 0.025;
    
    % Noise param slider
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run error histogram experiments';
    interface_params(k).callback = @(a,b)run_hist_exp(a);
    k=k+1;
    interface_params =  SetSliderParams( 'Set SNR', 15, 0.025, LocalizationAccuracyAndReliability.snr, 0.1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'snr',@update_sliders), interface_params, k);             
    k=k+1;           

	
    interface_params =  SetSliderParams(  'Set number of runs', 10000, 100, LocalizationAccuracyAndReliability.number_of_experiments, 100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'number_of_experiments',@update_sliders), interface_params, k);             
    k=k+1;  	

    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose noise type';
    interface_params(k).selection ={ 'White Gaussian noise', 'Correlated Gaussian noise'};
    interface_params(k).callback = @(a,b)ChooseNoiseType(a,b,handles);

    k=k+1;  	

    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose image to locate';
    interface_params(k).selection ={ 'Character O', 'Gard Eden'};
    interface_params(k).callback = @(a,b)ChooseImage(a,b,handles);

    
    
    
    
    
    
    
    
    

    LocalizationAccuracyAndReliability.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
         
    process_image(LocalizationAccuracyAndReliability.im1, ...
    LocalizationAccuracyAndReliability.im2, ...
    LocalizationAccuracyAndReliability.noise_type, ...
    LocalizationAccuracyAndReliability.snr, ...
    LocalizationAccuracyAndReliability.RE, ...
    LocalizationAccuracyAndReliability.RI, ...
    LocalizationAccuracyAndReliability.axes_1, ...
    LocalizationAccuracyAndReliability.axes_2, ...
    LocalizationAccuracyAndReliability.axes_3, ...
    LocalizationAccuracyAndReliability.axes_4, ...
    LocalizationAccuracyAndReliability.axes_5, ...
    LocalizationAccuracyAndReliability.axes_6, ...
    1 );
end


function run_hist_exp(figure_handle)
    handles = guidata(figure_handle);
    process_image( handles.(handles.current_experiment_name).im1, ...
        handles.(handles.current_experiment_name).im2, ...
        handles.(handles.current_experiment_name).noise_type, ...
        handles.(handles.current_experiment_name).snr, ...
        handles.(handles.current_experiment_name).RE, ...
        handles.(handles.current_experiment_name).RI, ...
        handles.(handles.current_experiment_name).axes_1, ...
        handles.(handles.current_experiment_name).axes_2, ...
        handles.(handles.current_experiment_name).axes_3, ...
        handles.(handles.current_experiment_name).axes_4, ...
        handles.(handles.current_experiment_name).axes_5, ...
        handles.(handles.current_experiment_name).axes_6, ...
        handles.(handles.current_experiment_name).number_of_experiments);
end
function process_image( im_tst_sharp, im_tst_smooth, noise_type, snr, RE, RI, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6, number_of_experiment)
    if ( nargin == 9 )
        number_of_experiment = 1;
    end
%     im_tst_sharp = imresize( im, [15 15]);


%     im_tst_smooth = imfilter(padarray(im_tst_sharp, [1 1], 'symmetric'), (1/9)*ones(3,3));
%     im_tst_smooth = im_tst_smooth(2:end-1, 2:end-1);
%     im_tst_smooth = sum(sum(im_tst_sharp.^2))*im_tst_smooth/(sum(sum(im_tst_smooth.^2)));
    imshow(uint8(im_tst_sharp), 'parent', axes_1);
    DisplayAxesTitle( axes_1, ['Sharp target'], 'TM');
    imshow(uint8(im_tst_smooth), 'parent', axes_4);
    DisplayAxesTitle( axes_4, ['Smoothed target '], 'BM');
    % verify both test images have the same energy
    
    % normalize energy to 1 
    im_tst_smooth = im_tst_smooth/sqrt(mean(im_tst_smooth(:).^2));
    im_tst_sharp = im_tst_sharp/sqrt(mean(im_tst_sharp(:).^2));
    
    dist_error_sharp = zeros(1, round(number_of_experiment));
    dist_error_smooth = zeros(1, round(number_of_experiment));
    for i = 1 : number_of_experiment
%         im = mean(im_tst_sharp(:))*ones(256,256);
        im = zeros(256,256);
        x1 = randi(size(im,2)-size(im_tst_smooth,2)) +ceil(size(im_tst_smooth,2)/2);
        y1 = randi( size(im,1)-size(im_tst_smooth,1)) +ceil(size(im_tst_smooth,1)/2);
%         im(y1 - 7: y1 + 7, x1 - 7: x1+ 7)= im_tst_sharp;
        im(y1 - ceil(size(im_tst_sharp,1)/2): y1 + ceil(size(im_tst_sharp,1)/2)-1, x1 - ceil(size(im_tst_sharp,2)/2): x1+ ceil(size(im_tst_sharp,2)/2)-1)= im_tst_sharp;
        im_sharp = im;
        im = zeros(256,256);
%         im(y1 - 7: y1 + 7, x1 - 7: x1 + 7)= im_tst_smooth;
        im(y1 - ceil(size(im_tst_smooth,1)/2): y1 + ceil(size(im_tst_smooth,1)/2)-1, x1 - ceil(size(im_tst_smooth,2)/2): x1+ ceil(size(im_tst_smooth,2)/2)-1)= im_tst_smooth;
        im_smooth = im;


        switch ( noise_type)
            case 'awgn'
            % SNR = sum(C(:).^2)/sum(im_sharp.^2)
            % where C = (image_with_noise - image_without_noise) - mean(image_with_noise - image_without_noise)
%                 im_sharp_w_noise  =  im_sharp + 255*sqrt(sum((im_sharp(:) /length(im_sharp(:) )).^2)/snr)*randn(size(im_sharp ));
                        im_sharp_w_noise  = im_sharp +sqrt(1/snr)*randn(size(im_sharp ));
%                         im_smooth_w_noise = im_smooth + 255*sqrt(sum((im_smooth(:)/length(im_smooth(:))).^2)/snr)*randn(size(im_smooth));
                        im_smooth_w_noise = im_smooth +sqrt(1/snr)*randn(size(im_sharp ));
            case 'cgn'
                        im_sharp_w_noise = cgn_mb(im_sharp, ...
                        snr, RE, RI);
                        im_smooth_w_noise  = cgn_mb(im_smooth, ...
                        snr, RE, RI);
        end

        switch ( noise_type )
            case 'awgn'
                [x_sharp, y_sharp] = MatchedFilter(im_sharp_w_noise, ...
                    im_tst_sharp);
                [x_smooth, y_smooth] = MatchedFilter(im_smooth_w_noise, ...
                    im_tst_smooth);
            case 'cgn'
                [x_sharp, y_sharp] = OptimalFilter(im_sharp_w_noise, ...
                    im_tst_sharp, RE, RI);
                [x_smooth, y_smooth] = OptimalFilter(im_smooth_w_noise, ...
                    im_tst_smooth, RE, RI);
        end
        
        dist_error_sharp(i) = sqrt((x1 - x_sharp)^2 + (y1 - y_sharp)^2 );
        dist_error_smooth(i) = sqrt((x1 - x_smooth)^2 + (y1 - y_smooth)^2 );
        if (i == 1 ||  mod(i, 10) == 0 )
                % Display the images
            imshow(uint8(255*(im_sharp_w_noise - min(im_sharp_w_noise(:)))/(max(im_sharp_w_noise(:)) - min(im_sharp_w_noise(:)))), 'parent', axes_2);
            imshow(uint8(255*(im_smooth_w_noise - min(im_smooth_w_noise(:)))/(max(im_smooth_w_noise(:)) - min(im_smooth_w_noise(:)))),'parent', axes_5);
            max_dist = sqrt(max(x1, abs(x1-256))^2 + max(y1, abs(y1-256))^2);
            hold(axes_2, 'on');
            red = dist_error_sharp(i)/max_dist;
            green = 1 - red;
            blue = 0;
            plot(axes_2, x_sharp, y_sharp, 'o', 'color', [red, green, blue]);
            DisplayAxesTitle( axes_2, ['Sharp target localization, Iteration Number ', num2str(i)] , 'TM');
            hold(axes_5, 'on');
            red = dist_error_sharp(i)/max_dist;
            green = 1 - red;
            blue = 0;
            plot(axes_5, x_smooth, y_smooth, 'o', 'color', [red, green, blue]);
            DisplayAxesTitle( axes_5,['Smooth target localization, Iteration Number ', num2str(i)] , 'BM');
            drawnow;
            hold(axes_5, 'off');
            hold(axes_2, 'off');
        end


    end

%     plot(  unique(dist_error_sharp), histc(dist_error_sharp, unique(dist_error_sharp)),'*', 'parent', axes_3);
    delete(get(axes_3, 'children'));
    plot(  unique(dist_error_sharp), histc(dist_error_sharp, unique(dist_error_sharp)),'.', 'parent', axes_3);
    hold(axes_3,'on');
    plot(  unique(dist_error_sharp), histc(dist_error_sharp, unique(dist_error_sharp)), 'linewidth', 1.2,'parent', axes_3);
    axis(axes_3, 'tight');
    title( axes_3, {['Sharp target localization error histogram'],['Error RMS = ' num2str(sqrt(mean(dist_error_sharp.^2)), '%0.1f')]},  'fontweight', 'bold');
    grid(axes_3, 'on');
    hold(axes_3,'off');
%     plot(  unique(dist_error_smooth), histc(dist_error_smooth, unique(dist_error_smooth)),'*', 'parent', axes_4);
    delete(get(axes_6, 'children'));
    plot(  unique(dist_error_smooth), histc(dist_error_smooth, unique(dist_error_smooth)),'.', 'parent', axes_6);
    axis(axes_6, 'tight');
    hold(axes_6,'on');
    plot(  unique(dist_error_smooth), histc(dist_error_smooth, unique(dist_error_smooth)), 'linewidth', 1.2, 'parent', axes_6);
    title( axes_6, {['Smooth target localization error histogram'],['Error RMS = ' num2str(sqrt(mean(dist_error_smooth.^2)), '%0.1f')]},  'fontweight', 'bold');
    grid(axes_6, 'on');
    hold(axes_6,'off');
end

function ChooseNoiseType(a,b, handles)
    handles = guidata(handles.figure1);
    noise = get(get(a, 'SelectedObject'), 'string');
    delete(handles.(handles.current_experiment_name).buttongroup_handle);
    
    % Noise param slider
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'run error histogram experiments';
    interface_params(k).callback = @(a,b)run_hist_exp(a);
    k=k+1;
    interface_params =  SetSliderParams( 'Set SNR', 15, 0.025, handles.(handles.current_experiment_name).snr, 0.1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'snr',@update_sliders), interface_params, k);             
    k=k+1;    
    if ( strcmpi(noise, 'White Gaussian Noise'))
        handles.(handles.current_experiment_name).noise_type = 'awgn';
    elseif(strcmpi(noise, 'Correlated Gaussian Noise'))
        handles.(handles.current_experiment_name).noise_type = 'cgn';
        interface_params =  SetSliderParams(  'Set internal radius of ring-shaper noise spectrum', handles.(handles.current_experiment_name).RE, 0, handles.(handles.current_experiment_name).RI, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RI',@update_sliders), interface_params, k);             
        k=k+1;  
        interface_params =  SetSliderParams(  'Set external radius of ring-shaper noise spectrum', 1, 0, handles.(handles.current_experiment_name).RE, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RE',@update_sliders), interface_params, k);             
        k=k+1;
    end
    interface_params =  SetSliderParams(  'Set number of runs', 10000, 100, handles.(handles.current_experiment_name).number_of_experiments, 100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'number_of_experiments',@update_sliders), interface_params, k);             
    k=k+1;  	

    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose noise type';
    interface_params(k).selection ={ 'White Gaussian noise', 'Correlated Gaussian noise'};
    interface_params(k).value = find(strcmpi(interface_params(k).selection, noise));
    interface_params(k).callback = @(a,b)ChooseNoiseType(a,b,handles);

    k=k+1;  	

    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose image to locate';
    interface_params(k).selection ={ 'Character O', 'Gard Eden'};
    interface_params(k).callback = @(a,b)ChooseImage(a,b,handles);

    
    
    
    
    
    
    
    
    

    handles.(handles.current_experiment_name).buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
       


    guidata(handles.figure1,handles);
    process_image( handles.(handles.current_experiment_name).im1, ...
        handles.(handles.current_experiment_name).im2, ...
        handles.(handles.current_experiment_name).noise_type, ...
        handles.(handles.current_experiment_name).snr, ...
        handles.(handles.current_experiment_name).RE, ...
        handles.(handles.current_experiment_name).RI, ...
        handles.(handles.current_experiment_name).axes_1, ...
        handles.(handles.current_experiment_name).axes_2, ...
        handles.(handles.current_experiment_name).axes_3, ...
        handles.(handles.current_experiment_name).axes_4, ...
        handles.(handles.current_experiment_name).axes_5, ...
        handles.(handles.current_experiment_name).axes_6, ...
        1);
end

function ChooseImage(a,b, handles)
    handles = guidata(handles.figure1);
    image = get(get(a, 'SelectedObject'), 'string');
    if ( strcmpi(image, 'Character O'))
        A = load('Character_o.mat'); B = load('Character_o_sm.mat');
        handles.(handles.current_experiment_name).im1 = A.letter_o;
        handles.(handles.current_experiment_name).im2 = B.Character_o_sm;
    elseif(strcmpi(image, 'Gard Eden'))
        A = load('GardEden.mat'); B = load('GardEden_sm.mat');
        handles.(handles.current_experiment_name).im1 = A.GardEden;
        handles.(handles.current_experiment_name).im2 = B.GardEden_sm;
    end
    guidata(handles.figure1,handles);
    process_image( handles.(handles.current_experiment_name).im1, ...
        handles.(handles.current_experiment_name).im2, ...
        handles.(handles.current_experiment_name).noise_type, ...
        handles.(handles.current_experiment_name).snr, ...
        handles.(handles.current_experiment_name).RE, ...
        handles.(handles.current_experiment_name).RI, ...
        handles.(handles.current_experiment_name).axes_1, ...
        handles.(handles.current_experiment_name).axes_2, ...
        handles.(handles.current_experiment_name).axes_3, ...
        handles.(handles.current_experiment_name).axes_4, ...
        handles.(handles.current_experiment_name).axes_5, ...
        handles.(handles.current_experiment_name).axes_6, ...
        1);
end

function update_sliders(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
    if ( strcmpi(handles.(handles.current_experiment_name).noise_type, 'cgn'))
        % internal ring radius
        val = min(handles.(handles.current_experiment_name).RI, handles.(handles.current_experiment_name).RE);
        slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider3');
        set(slider_handle, 'value', val);
        set(slider_handle, 'max', handles.(handles.current_experiment_name).RE);
        set(slider_handle, 'sliderstep', [1/100, 1/100]);
        slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value3');
        set(slider_title_handle, 'string',  num2str(val));
        slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText3');
        set(slider_title_handle, 'string',  num2str(handles.(handles.current_experiment_name).RE));
        handles.(handles.current_experiment_name).RI = val; 
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


    process_image( handles.(handles.current_experiment_name).im, ...
        handles.(handles.current_experiment_name).noise_type, ...
        handles.(handles.current_experiment_name).snr, ...
        handles.(handles.current_experiment_name).RE, ...
        handles.(handles.current_experiment_name).RI, ...
        handles.(handles.current_experiment_name).axes_1, ...
        handles.(handles.current_experiment_name).axes_2, ...
        handles.(handles.current_experiment_name).axes_3, ...
        handles.(handles.current_experiment_name).axes_4, ...
        handles.(handles.current_experiment_name).axes_5, ...
        handles.(handles.current_experiment_name).axes_6, ...
        handles.(handles.current_experiment_name).number_of_experiments);
end
function [X, Y] = MatchedFilter(im_w_noise, target)
    % filtering with matched filter
    spimg = fft2(im_w_noise);
    mtchfilter=conj(fft2(target,size(spimg,1), size(spimg,2)));
    corr=real(ifft2(spimg.*mtchfilter))';
    X = locatmax_mb(corr);
    Y = X(2)+floor(0.5*size(target,1)); X = X(1)+floor(0.5*size(target,2));
end

function [X Y] = OptimalFilter (im_w_noise, target, RE, RI)
    N = max(size(im_w_noise,1), size(im_w_noise,2));
    RING=255*ones(N);CX=N/2+1;CY=N/2+1;
    for x=1:N,
        for y=1:N,
            if (((x-CX)^2 + (y-CY)^2)<(RI*N/2)^2)
                RING(x,y)=0;
            elseif (((x-CX)^2 + (y-CY)^2)>(RE*N/2)^2)
                RING(x,y)=0;
            else
                RING(x,y)=255;
            end
        end
    end
    RING=fftshift(RING);
    spimg = fft2(im_w_noise);
    RING = RING.*(RING~=0)+0.0001.*(RING==0);
    spimg = spimg./RING;
    mtchfilter=conj(fft2(target, size(spimg,1), size(spimg,2)));
    corr=real(ifft2(spimg.*mtchfilter))';    
    X = locatmax_mb(corr);
%     Y = size(corr,1) - X(2)-0.5*size(target,1); X = size(corr,2) -X(1)-0.5*size(target,2);
    Y = X(2)+floor(0.5*size(target,1)); X = X(1)+floor(0.5*size(target,2));
end