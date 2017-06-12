%% Pseudo Inverse Filter
%  Image de-blurring by the pseudo-inverse filter   
%% Experiment Description:
% This experiment demonstrates the different filtering algorithms of
% Additive Noise with different neighborhoods types and different smoothing
% (estimation) operations. 
%% Tasks:
% 10.1 
%
% # Generate a rectangle point spread function for the image blur. 
% # Test image de-blurring by pseudo-inverse filter for different degree of
% blur and different level of additive noise (program invfiltr.m; image
% text256 is recommended). 
% # Observe the sensitivity of the filter to the noise level. 
% Optimize the threshold level for eliminating zeros of the filter
% frequency response. 
% # Evaluate potential restoration capability of the pseudo-inverse filter in
% terms of trade off between the degree of blur and noise level.
%% Instruction:
% 'Set PSF Kernel Size' - determines the size of the psf kernel.
%
% 'Set AWGN Variance' - determines the additive White Gaussian Noise
% Variance.
%
% 'Set Threshold Frequency domain' - determines the threshold in the
% Frequency domain. (for more information, please check the *"Theoretical
% Background"* section.
%
% 'Set Threshold Space domain'- determines the threshold in the Space
% domain. (for more information, please check the *"Theoretical
% Background"* section. 
%% Theoretical Background:
% _*Linear degradation model*_
%
% the Linear degradation model can be presented by:
%
% <<Linear_degradation_model.png>>
%
% Where:
%
% * $I(x,y)$ - is the input image.
% * $h(x,y)$ - is a blur kernel, the psf for example.
% * $w(x,y)$ - is an additive white Gaussian noise signal
% $\mathcal{N}(0,\sigma_w^2)$.
% * $y(x,y) = I(x,y)*h(x,y) + w(x,y)$ where $*$ is the convolution
% operation.
%
% _*Linear restoration*_
%
% Linear restoration aim is to restore the original signal $I(x,y)$ from
% the degradated signal $y(x,y)$.
%
% $$\hat{I}(x,y) = h_{inv}(x,y)*y(x,y) = h_{inv}(x,y)*\left(I(x,y)*h(x,y) +
% w(x,y) \right) $$
%
% In the Fourier domain:
%
% $$\hat{ \mathcal{I}}(u,v)  = \mathcal{H}_{inv}(u,v)  \cdot \mathcal{Y}(u,v) =
% \mathcal{H}_{inv}(u,v) \cdot \left( \mathcal{I}(u,v) \cdot
% \mathcal{H}(u,v) + \mathcal{W}(u,v) \right) $$ 
%
% Where:
%
% * $\hat{ \mathcal{I}}(u,v)$ - is the Fourier transform of $\hat{I}(x,y)$.
% * $\mathcal{H}_{inv}(u,v)$ - is the Fourier transform of $h_{inv}(x,y)$.
% * $\mathcal{Y}(u,v)$ - is the Fourier transform of $y(x,y)$.
% * $\mathcal{I}(u,v)$ - is the Fourier transform of $I(x,y)$.
% * $\mathcal{H}(u,v)$ - is the Fourier transform of $H(x,y)$.
% * $\mathcal{W}(u,v)$ - is a representation of the Fourier transform of $w(x,y)$.
%
% _*Inverse Filter*_ 
%
% Inverse Filter is a non blind ( which means that the blurring kernel is
% known) linear restoration solution which uses prior knowledge of the blur
% kernel $h(x,y)$ to restore the original signal $I(x,y)$. 
%
% The Inverse Filter designed to cancel the effect of $H(x,y)$,
% therefore:
%
% $$\mathcal{H}_{inv}(u,v) = \mathcal{H}(u,v)^{-1}$$
%
% Implement the Inverse Filter on the blured with noise signal:
%
% $$\hat{ \mathcal{I}}(u,v)  =  \mathcal{H}(u,v)^{-1} \cdot \left(
% \mathcal{I}(u,v) \cdot \mathcal{H}(u,v) + \mathcal{W}(u,v) \right) =
% \mathcal{I}(u,v) + \mathcal{W}(u,v) \cdot \mathcal{H}(u,v)^{-1}$$   
%
% _*Inverse Filter Disadvantages*_ 
%
% The blurring kernel $h(x,y)$ have the effect of suppressing the high
% frequencies of the image. this means that the inverse of $h(x,y)$,
% $h_{inv}(x,y)$, has the opposite effect.
%
% since the AWGN exist in the high frequencies, as well as in the low
% frequencies, implement the Inverse Filter on $y(x,y)$ will result in
% amplifying noise in the high frequencies.
%
% Another disadvantage of the Inverse Filter is the introduction of poles
% in the system.
%
% _*Pseudo Inverse Filter*_ 
%
% To overcome the problems in the direct Inverse Filter implementation, the
% Pseudo Inverse Filter is used.
%
% To overcome the additional poles and amplification of noise, two thresholds
% are defined:
%
% * ThrF - the minimum allowed value of the Pseudo Inverse Filter:
% 
% $$\hat{\mathcal{H}}_{inv}(u,v) = \left\{ \begin{array}{ll} \mathcal{H}(u,v)^{-1}
% & \mathcal{H}(u,v)\ge ThrF \\ 0 & O.W. \end{array} \right. $$
%
% * ThrIm - The minimum allowed diff in space domain:
%
% $$\hat{I}_{final}(x,y) = I(x,y) + \left\{ \begin{array}{ll} \hat{I}(x,y) - I(x,y) 
% & \hat{I}(x,y) - I(x,y) \le ThrIm \\ ThrIm & O.W. \end{array} \right. $$
%% Appendix
% _*What is PSF? (Point spread function)-*_
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
% is a measure for the quality of an imaging system. 
%
% In incoherent imaging systems such as fluorescent microscopes, telescopes
% or optical microscopes, the image formation process is linear in power
% and described by linear system theory. 
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
%% Algorithm:
%% Reference:
% 
function ApertureCorrection = InverseFiltering_mb( handles )
	handles = guidata(handles.figure1);
	axes_hor = 2;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	ApertureCorrection = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);

	%
	ApertureCorrection.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
	ApertureCorrection.filter_size = 5;
% 	ApertureCorrection.std = 0;
    ApertureCorrection.std = 0.2;
% 	ApertureCorrection.ThrF = 0;
    ApertureCorrection.ThrF = 0.01;
	ApertureCorrection.ThrIm = 50;

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    
 	k=k+1;              
	interface_params = SetSliderParams('Set frequency domain threshold', 0.1, 0, ApertureCorrection.ThrF, 0.01, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'ThrF',@update_sliders), interface_params, k);

	k=k+1; 
	interface_params = SetSliderParams('Set image domain threshold', 100, 0, ApertureCorrection.ThrIm, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'ThrIm',@update_sliders), interface_params, k);
   
	k=k+1;
	interface_params = SetSliderParams('Additive noise standard deviation', 5, 0, ApertureCorrection.std, 0.1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'std',@update_sliders), interface_params, k);
    %%tive noise

	k=k+1;      
	interface_params = SetSliderParams('Set bluring filter PSF spread', 21, 1, ApertureCorrection.filter_size, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'filter_size',@update_sliders), interface_params, k);




	ApertureCorrection.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		 

	process_image(ApertureCorrection.im, ApertureCorrection.filter_size, ...
	ApertureCorrection.std, ApertureCorrection.ThrF, ApertureCorrection.ThrIm , ...
	ApertureCorrection.axes_1, ApertureCorrection.axes_2, ApertureCorrection.axes_3);
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



ApertureCorrection = handles.(handles.current_experiment_name);
    process_image(ApertureCorrection.im, ApertureCorrection.filter_size, ...
        ApertureCorrection.std, ApertureCorrection.ThrF, ApertureCorrection.ThrIm , ...
        ApertureCorrection.axes_1, ApertureCorrection.axes_2, ApertureCorrection.axes_3);
end



function     process_image(im, filter_size, std, ThrF, ThrIm , axes_1, axes_2, axes_3)

imshow(im, [0 255], 'parent', axes_1);
DisplayAxesTitle( axes_1, ['Test image'], 'TM',10);  
FILTMASK = ones(filter_size, filter_size)/(filter_size^2);
[BLURIMG_n, OUTIMG] =invfiltr_mb(im,FILTMASK,std,ThrF,ThrIm);

imshow(BLURIMG_n,[0 255],  'parent', axes_2);
DisplayAxesTitle( axes_2, ['Blurred test image with noise~(0,' num2str(std) ')'], 'TM',10);  
imshow(OUTIMG, [0 255] ,'parent', axes_3);
DisplayAxesTitle( axes_3, ['De-blurred, de-noised image'],'BM',10);  


end

