%% Adaptive Linear Filters 1D
%  Signal de-noising capability of local adaptive linear filters 
%% Experiment Description:
% This experiment demonstratet Signal de-noising capability of of local
% adaptive linear filters in the DCT domain, by supressing low enargy
% components.
%% Tasks:
% 10.3 
%
% # Test 1D signal de-noising capability of local adaptive linear filtering
% in the domain of DCT in a moving window (program recdct1d.m; signal ecg1.mat).  
% # Determine optimal window size and thresholds.
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
% function [INPSIGN, LOCSPEC, LOCSP_m_Shr, OUT]=recdct1d_mb(INPSIGN,SzW,stdnoise,Thr)
% % Simulating 1-D Local spectral analysis and filtering in DCT basis
% % in the moving window of SzW samples (odd number)
% % Input - 1D signal(SzX,1);
% % Output - array of ((SzW+1)/2*Size(INPSIGN)) samples of local DCT spectra
% % Call LOCSPEC=recdct1d(INPSIGN,SzW,stdnoise,threshold);
% % SzW - window size;
% % stdnoise - standard deviation of additive noise to be added to INPSIGN 
% % Thr - is a threshold applied to DCT coefficients to cancel
% % those whose magnitude does not exceed it 
% % values about (1-3)*stdnoise/max(INPSIGN) are recommended)
% % Call LOCSPEC=recdct1d(INPSIGN,SzW,stdnoise,threshold);
%     SzX=max(size(INPSIGN)); 
%     INPSIGN=reshape(INPSIGN,1,SzX);
%     mx=max(INPSIGN);
%     Lx=(SzW-1)/2;
%     INPSIGN=INPSIGN+stdnoise*randn(size(INPSIGN));
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
%  1996); doi:10.1117/12.255218.>
function LocalAdaptiveFiltering1D = LocalAdaptiveFiltering1D_mb( handles )
% 10.3 Signal and image de-noising capability of local adaptive linear filters
% Test signal de-noising capability of local adaptive linear filtering in the domain of DCT
% in a moving window (program recdct1d.m; signal ecg1.mat). Determine optimal
% window size and thresholds.
% Generate an image with additive Gaussian noise. Test image de-noising capability of
% local adaptive linear filtering in the domain of DCT in a moving window (program
% lcdct2.m). Observe edge preserving capability of the filtering.
    handles = guidata(handles.figure1);
    axes_pos = {[5,1]};
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    LocalAdaptiveFiltering1D = DeployAxes( handles.figure1, ...
                                        axes_pos, ...
                                        bottom, ...
                                        left, ...
                                        0.9, ...
                                        0.9);                                            
    % initialization
    LocalAdaptiveFiltering1D.signal = HandleFileList('load' , HandleFileList('get signal' , handles.signal_index));
    LocalAdaptiveFiltering1D.WndSz = 17;
    LocalAdaptiveFiltering1D.STD = 15;
    LocalAdaptiveFiltering1D.Thr = 15;
    LocalAdaptiveFiltering1D.TransformType = 'DCT';
    %
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    
    k=k+1;          
    interface_params =  SetSliderParams('Set filtering threshold (% of signal StDev)', 100, 0, LocalAdaptiveFiltering1D.Thr, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Thr',@update_sliders), interface_params, k);
    
    k=k+1;          
    interface_params =  SetSliderParams('Set filter window size', 55, 7, LocalAdaptiveFiltering1D.WndSz, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSz',@update_sliders), interface_params, k);
	
    k=k+1;
    interface_params =  SetSliderParams('Set additive noise StDev (% of signal StDev)', 100, 0, LocalAdaptiveFiltering1D.STD, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'STD',@update_sliders), interface_params, k);
    k=k+1;
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose Evolutionary Model';
    interface_params(k).selection ={ 'DCT', 'Haar'};   
    interface_params(k).callback = @(a,b)ChooseTransformType(a,b,handles);  
    interface_params(k).value = find(strcmpi(interface_params(k).selection, LocalAdaptiveFiltering1D.TransformType));
    LocalAdaptiveFiltering1D.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
         
    process_image(LocalAdaptiveFiltering1D.signal, LocalAdaptiveFiltering1D.WndSz, LocalAdaptiveFiltering1D.STD, LocalAdaptiveFiltering1D.Thr, LocalAdaptiveFiltering1D.TransformType,...
    LocalAdaptiveFiltering1D.axes_1, LocalAdaptiveFiltering1D.axes_2, LocalAdaptiveFiltering1D.axes_3, LocalAdaptiveFiltering1D.axes_4, LocalAdaptiveFiltering1D.axes_5)
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
    LocalAdaptiveFiltering1D = handles.(handles.current_experiment_name);
    process_image(LocalAdaptiveFiltering1D.signal, LocalAdaptiveFiltering1D.WndSz, LocalAdaptiveFiltering1D.STD, LocalAdaptiveFiltering1D.Thr, LocalAdaptiveFiltering1D.TransformType,...
    LocalAdaptiveFiltering1D.axes_1, LocalAdaptiveFiltering1D.axes_2, LocalAdaptiveFiltering1D.axes_3, LocalAdaptiveFiltering1D.axes_4, LocalAdaptiveFiltering1D.axes_5)
end

function ChooseTransformType(a,b,handles)
    handles = guidata(handles.figure1);
    handles.(handles.current_experiment_name).TransformType = get(b.NewValue, 'string');
    delete(handles.(handles.current_experiment_name).buttongroup_handle);
    handles.(handles.current_experiment_name) = rmfield(handles.(handles.current_experiment_name), 'buttongroup_handle');
    k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    
    k=k+1;          
    interface_params =  SetSliderParams('Set filtering threshold (% of signal StDev)', 100, 0, handles.(handles.current_experiment_name).Thr, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Thr',@update_sliders), interface_params, k);
    
    k=k+1;
    if ( strcmpi(handles.(handles.current_experiment_name).TransformType, 'DCT'))
        handles.(handles.current_experiment_name).WndSz =11;
        interface_params =  SetSliderParams('Set filter window size', 55, 7, handles.(handles.current_experiment_name).WndSz, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSz',@update_sliders), interface_params, k);
    elseif ( strcmpi(handles.(handles.current_experiment_name).TransformType, 'Haar'))
        handles.(handles.current_experiment_name).WndSz =32;
        size = 2.^[2:6];
        interface_params =  SetSliderParams('Set filter window size', size, 1, log2(handles.(handles.current_experiment_name).WndSz)-1, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSz',@update_sliders, size), interface_params, k);
    end
    k=k+1;
    interface_params =  SetSliderParams('Set additive noise StDev (% of signal StDev)', 100, 0, handles.(handles.current_experiment_name).STD, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'STD',@update_sliders), interface_params, k);
    k=k+1;
    
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose Evolutionary Model';
    interface_params(k).selection ={ 'DCT', 'Haar'};   
    interface_params(k).callback = @(a,b)ChooseTransformType(a,b,handles);  
    interface_params(k).value = find(strcmpi(interface_params(k).selection, handles.(handles.current_experiment_name).TransformType));
    
 
    handles.(handles.current_experiment_name).buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
    guidata(handles.figure1, handles);
    LocalAdaptiveFiltering1D = handles.(handles.current_experiment_name);
    process_image(LocalAdaptiveFiltering1D.signal, LocalAdaptiveFiltering1D.WndSz, LocalAdaptiveFiltering1D.STD, LocalAdaptiveFiltering1D.Thr, LocalAdaptiveFiltering1D.TransformType,...
    LocalAdaptiveFiltering1D.axes_1, LocalAdaptiveFiltering1D.axes_2, LocalAdaptiveFiltering1D.axes_3, LocalAdaptiveFiltering1D.axes_4, LocalAdaptiveFiltering1D.axes_5)
end

function     process_image(signal, WndSz, stdnoise, Thr , TransformType, axes_1, axes_2, axes_3, axes_4, axes_5)
    plot( signal , 'parent', axes_1, 'linewidth', 2);
    grid(axes_1, 'on'); axis(axes_1, 'tight');
    title( axes_1, {'Test signal'}, 'fontweight', 'bold');     
    stdnoise = stdnoise*sqrt(var(signal));
    [INPSIGN, LOCSPEC, LOCSP_m_Shr, OUT] = ... 
    recdct1d_mb(signal,WndSz,stdnoise/100,Thr/100, TransformType);
    plot( INPSIGN , 'parent', axes_2, 'linewidth', 2);
    grid(axes_2, 'on'); axis(axes_2, 'tight');
    title( axes_2, { 'Test signal with noise'}, 'fontweight', 'bold');    
    image( 255*((uquan256_mb(LOCSPEC)/255)),'parent', axes_3);
    title( axes_3,{ ['Noisy signal local  ', TransformType, ' spectra']}, 'fontweight', 'bold');   
    image( 255*((uquan256_mb(LOCSP_m_Shr)/255)),'parent', axes_4);
    title( axes_4, {['Filtered signal Local ', TransformType, ' spectra']}, 'fontweight', 'bold');  
    plot( OUT, 'parent', axes_5, 'linewidth', 2);
    grid(axes_5, 'on'); axis(axes_5, 'tight');
    title( axes_5, ['Filtered signal, ErrorStDev = ' num2str(sqrt(mean((OUT(:) -signal(:)).^2)),2)]  , 'fontweight', 'bold');  
end


