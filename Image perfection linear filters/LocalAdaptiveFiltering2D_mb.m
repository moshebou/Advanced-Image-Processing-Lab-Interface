%% Adaptive Linear Filters 2D
%  Image de-noising capability of local adaptive linear filters 
%% Experiment Description:
% This experiment demonstratet Signal de-noising capability of of local
% adaptive linear filters in the DCT domain, by supressing low enargy
% components.
%% Tasks:
% 10.3 
%
% # Generate an image with additive Gaussian noise. 
% # Test image de-noising capability of local adaptive linear filtering in
% the domain of DCT in a moving window (program lcdct2.m).  
% # Observe edge preserving capability of the filtering.
%% Instruction:
% 'Set AWGN STD' - determines the Addative White Gaussian Noise
% standard deviation.
%
% 'Set Window size' - determines the threshold in the
% Frequency domaim. (for more information, please check the *"Theoretical
% Background"* section.
%
% 'Set Threshold (%-Percentage)'- determines the threshold in the Space
% domaim. (for more information, please check the *"Theoretical
% Background"* section. 
%% Theoretical Background:
% The local adaptive linear filters uses the wiener results found on the
% whole image, and imployes it on each individual signal\image window.
%
% i.e., given image( signal) destortion model of:
% 
% $$ b = L * a + n $$
%
% where L is a linear operator of the imaging system and n is a random zero
% mean signal independent random vector that models imaging system sensor's
% noise, and (*) is the conveloution operation.
%
% Assume also that the imaging system operator L is such that the distorted
% image can be described in the domain of the chosen orthogonal transform
% by the following relationship: 
%
% $$ B_{\omega_1, \omega_2 }^{k_1, k_2} = L_{\omega_1, \omega_2 }^{k_1,
% k_2} \cdot A_{\omega_1, \omega_2 }^{k_1, k_2} + N_{\omega_1, \omega_2
% }^{k_1, k_2} $$
%
% Where:
% 
% $\omega_1, \omega_2$ is the 2D frequancy domain.
%
% $k_1, k_2$ are current window location.
%
% $B_{\omega_1, \omega_2 }^{k_1, k_2}$ are running representation
% coefficients of the input image\signal $B$ domain of the orthogonal
% transform.(such as DCT, FFT) 
%
% $L_{\omega_1, \omega_2 }^{k_1, k_2}$ are running representation
% coefficients of the linear operator $L$ domain of the orthogonal
% transform.
%
% $ N_{\omega_1, \omega_2}^{k_1, k_2}$ are zero mean spectral cofficients of
% the realization of the noise interference.
%
% Then the derived "empirical Wiener filter" for each window is represented
% by:
%
% $$ \eta_{\omega_1, \omega_2}^{k_1, k_2} = \frac{ \left| L_{\omega_1,
% \omega_2 }^{k_1, k_2} \right |^2 \cdot \left| A_{\omega_1, \omega_2
% }^{k_1, k_2} \right |^2 } {  L_{\omega_1, \omega_2 }^{k_1, k_2} \cdot
% Average ( \left| B_{\omega_1, \omega_2 }^{k_1, k_2} \right |^2 ) } $$
%
% This experiment aims noise reduction, and to that aim, L is assumed to be 1.
% The orthogonal basis is designed to be DCT transform. 
%% Algorithm:
% Parameters: 
%
% # $S_{in}$ - input signal.
% # $WndSiz$ - window size.
% # $THr$    - threshold in persent from maximum value.
%
% For each disinc window $window_k$ of size $WndSiz$:
%
% # Computing local DCT spectrum of input signal at $window_k$:
% $signal_{dct}^k = DCT(signal@ window_k )$
% # $max = MAX(signal_{dct}^k)$
% # each sample smaller then  $THr*max$ set to 0.
% # Inverse local DCT for the central pixel of the window
% 
%
% <html><pre class="codeinput"><p>Code:
% function [INPSIGN, LOCSPEC, LOCSP_m_Shr, OUT]=recdct1d_mb(INPSIGN,SzW,std,Thr)
% % Simulating 1-D Local spectral analysis and filtering in DCT basis
% % in the moving window of SzW samples (odd number)
% % Input - 1D signal(SzX,1);
% % Output - array of ((SzW+1)/2*Size(INPSIGN)) samples of local DCT spectra
% % Call LOCSPEC=recdct1d(INPSIGN,SzW,std,threshold);
% % SzW - window size;
% % std - standard deviation of additive noise to be added to INPSIGN 
% % Thr - is a threshold applied to DCT coefficients to cancel
% % those whose magnitude does not exceed it 
% % values about (1-3)*std/max(INPSIGN) are recommended)
% % Call LOCSPEC=recdct1d(INPSIGN,SzW,std,threshold);
%     SzX=max(size(INPSIGN)); 
%     INPSIGN=reshape(INPSIGN,1,SzX);
%     mx=max(INPSIGN);
%     Lx=(SzW-1)/2;
%     INPSIGN=INPSIGN+std*randn(size(INPSIGN));
%     % Computation of local spectra
%     LOCSPEC=locdct1_mb(INPSIGN,Lx);
%     %****************************Filtering*********************************
%     % Spectrum shrinkage
%     LOCSP_m=abs(LOCSPEC);
%     LOCSP_ph=sign(LOCSPEC);
%     LOCSP_m_Shr=LOCSP_m.*(LOCSP_m>=Thr*mx);% Shrinkage
%     LOCSP_m_Shr(1,:)=LOCSP_m(1,:);
%     % Reconstruction
%     LOCSP=LOCSP_m_Shr.*LOCSP_ph;
%     OUTSIGN=locidct1_mb(LOCSP);
%     OUT=[OUTSIGN];
% </p></pre></html>
%
%% Reference:
% [1] <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/LocAdaptFiltr_ICObook.pdf
%  Leonid P. Yaroslavsky; Local adaptive image restoration and enhancement
%  with the use of DFT and DCT in a running window. Proc. SPIE 2825,
%  Wavelet Applications in Signal and Image Processing IV, 2 (October 23,
%  1996); doi:10.1117/12.255218.>%% Tasks:


function LocalAdaptiveFiltering2D = LocalAdaptiveFiltering2D_mb( handles )
% 10.3 Signal and image de-noising capability of local adaptive linear filters
% Test signal de-noising capability of local adaptive linear filtering in the domain of DCT
% in a moving window (program recdct1d.m; signal ecg1.mat). Determine optimal
% window size and thresholds.
% Generate an image with additive Gaussian noise. Test image de-noising capability of
% local adaptive linear filtering in the domain of DCT in a moving window (program
% lcdct2.m). Observe edge preserving capability of the filtering.

    % loading program parameters
	handles = guidata(handles.figure1);
	axes_hor = 2;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	LocalAdaptiveFiltering2D = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);
	
    % setting up defulte experiment values
	LocalAdaptiveFiltering2D.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
	LocalAdaptiveFiltering2D.p = 1;
	LocalAdaptiveFiltering2D.g = 1;
	LocalAdaptiveFiltering2D.WndSz = 7;
	LocalAdaptiveFiltering2D.std = 25;
	LocalAdaptiveFiltering2D.Thr = 25;
    LocalAdaptiveFiltering2D.filter_type = 'Rejecting filter';
    
    % defining eexperiment gui
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;    
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose the filter';
    interface_params(k).selection ={ 'Rejecting filter','Empirical Wiener filter'};   
    interface_params(k).value = find(strcmpi(interface_params(k).selection, LocalAdaptiveFiltering2D.filter_type));
    interface_params(k).callback = @(a,b)ChooseFilterType(a,b,handles);
	k=k+1;
	interface_params =  SetSliderParams('Set Power Of Spectral Coefficients', 1, 0, LocalAdaptiveFiltering2D.p, 0.05, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'p',@update_sliders), interface_params, k);
	k=k+1;    
	interface_params =  SetSliderParams('Set Spectral Coefficients Amplification', 5, 1, LocalAdaptiveFiltering2D.g, 0.1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'g',@update_sliders), interface_params, k);
	k=k+1;            
	interface_params =  SetSliderParams('Set Comparison Threshold', 50, 0, LocalAdaptiveFiltering2D.Thr, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Thr',@update_sliders), interface_params, k);
	k=k+1;
	interface_params =  SetSliderParams('Set Filter Window Size', 55, 1, LocalAdaptiveFiltering2D.WndSz, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSz',@update_sliders), interface_params, k);
    k=k+1;            
	interface_params =  SetSliderParams('Set additive noise StDev', 50, 0, LocalAdaptiveFiltering2D.std, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'std',@update_sliders), interface_params, k);

	LocalAdaptiveFiltering2D.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		 
    
    %display th etest image, to avoid repeating it with each experiment run
    imshow(LocalAdaptiveFiltering2D.im,[0, 255], 'parent', LocalAdaptiveFiltering2D.axes_1);
    DisplayAxesTitle( LocalAdaptiveFiltering2D.axes_1, ['Test image'], 'TM');  
end

function ChooseFilterType (a,b,handles)
    handles = guidata(handles.figure1);
    handles.(handles.current_experiment_name).filter_type = get(b.NewValue, 'string');

    LocalAdaptiveFiltering2D = handles.(handles.current_experiment_name);
    guidata(    handles.figure1, handles);
    process_image(LocalAdaptiveFiltering2D.im, LocalAdaptiveFiltering2D.WndSz, LocalAdaptiveFiltering2D.std, ...
    LocalAdaptiveFiltering2D.p, LocalAdaptiveFiltering2D.g, LocalAdaptiveFiltering2D.Thr , LocalAdaptiveFiltering2D.filter_type, ...
    LocalAdaptiveFiltering2D.axes_1, LocalAdaptiveFiltering2D.axes_2, LocalAdaptiveFiltering2D.axes_3, LocalAdaptiveFiltering2D.axes_4);
    
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
    LocalAdaptiveFiltering2D = handles.(handles.current_experiment_name);
    process_image(LocalAdaptiveFiltering2D.im, LocalAdaptiveFiltering2D.WndSz, LocalAdaptiveFiltering2D.std, ...
    LocalAdaptiveFiltering2D.p, LocalAdaptiveFiltering2D.g, LocalAdaptiveFiltering2D.Thr ,LocalAdaptiveFiltering2D.filter_type,  ...
    LocalAdaptiveFiltering2D.axes_1, LocalAdaptiveFiltering2D.axes_2, LocalAdaptiveFiltering2D.axes_3, LocalAdaptiveFiltering2D.axes_4);
end

function     process_image(im, WndSz, std, p, g, Thr , filter_type, axes_1, axes_2, axes_3, axes_4)
        imshow(im,[0, 255], 'parent', axes_1);
        DisplayAxesTitle( axes_1, ['Test image'], 'TM');  
        im  = double(im);
        h = waitbar(0, 'please wait');
        noise = std*(randn(size(im)));
        im = im + noise;
        sp_mask = ones(WndSz, WndSz);
        imshow(im,[0, 255], 'parent', axes_2);
        DisplayAxesTitle( axes_2, ['Test image with noise'], 'TM');  
        if ( strcmpi(filter_type, 'Rejecting filter'))
            k = 1 ;
        else
            k = 0;
        end
        [OUTIMG1, OUTIMG2]=lcdct2_mb(im,sp_mask,p,g,Thr, k, h, axes_3, axes_4);
        
        

        imshow(OUTIMG1,[0, 255],  'parent', axes_3);
        DisplayAxesTitle( axes_3, ['Filtered image'], 'BM');  
        
        imshow(OUTIMG2, [0, 255] ,'parent', axes_4);
        DisplayAxesTitle( axes_4, ['DCT-domain mask (Controlled by threshold]'], 'BM');  
        waitbar(1 ,    h);
        close(h);

end

