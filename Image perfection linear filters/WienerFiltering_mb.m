%% Wiener Filters
%  Image de-noising and de-blurring by the ideal Wiener and empirical Wiener filters
%% Experiment Description:
% This experiment demonstrates the different filtering algorithms of
% Additive Noise with different Neighborhoods types and different smoothing
% (estimation) operations. 
%% Tasks:
% 10.2 
%
% # Test and compare image de-noising capability of the ideal Wiener and
% empirical Wiener filters (program wiener.m with the image blur parameter
% RD>1000. 
% # Optimize parameter $\gamma$ of spectrum estimation for the empirical
% Wiener filter. Observe blur in restored images. 
% # Test and compare image de-blurring capability of the ideal Wiener and
% empirical Wiener filters (program wiener.m with the image blur parameter
% RD=1 - 10, image text). 
% # Optimize parameter 'gamma'' of spectrum estimation for the empirical
% Wiener filter. 
% #Test image de-noising capability of the adaptive empirical Wiener filter
% for suppressing additive narrow-band noise (program demoire1.m, images:
% moire, jeep, magcrop).
%% Instruction:
% 'Set PSF Kernel Size' - determines the size of the psf kernel.
%
% 'Set AWGN Variance' - determines the additive White Gaussian Noise
% Variance.
%
% 'Set Threshold Frequency domain' - determines the threshold in the
% Frequency domain. (for more information, please check the *"Theoretical
% Background"* section.)
%
% 'Set Threshold Space domain'- determines the threshold in the Space
% domain. (for more information, please check the *"Theoretical
% Background"* section.) 
%% Theoretical Background:
% _*Random Sequences Estimation*_
%
% Given two random sequences, $u(m,n), v(m,n)$, the best estimator of $u(x,
% y)$ given $v(m,n)$  which minimize the mean square error $\left(
% \sigma_e^2 = E \left\{ (u(m,n) - v(m,n))^2 \right\} \right)$, is 
% given by:
% 
% $$\hat{u}(m,n) = E \left\{ u(m,n)|v(m,n)\right\}$$
%
% This result may look simple, but in many cases it is impossible to
% calculate the estimator due to its non-linear nature, and the difficult
% to calculate conditional probability density $p_{u|v}$.
%
% _*Linear Estimate*_
%
% Due to the problems described before, a linear estimator is suggested,
% i.e. $\hat{u}(m,n)$ is restricted to be a linear function of $v(m,n)$:
%
% $$\hat{u}(m,n) = \sum_{k=-\infty}^{\infty} \sum_{l=-\infty}^{\infty}
% g(m,n;k,l) \cdot v(k,l)$$
%
% Using:
%
% # The definition of the cross-correlation: 
% $$r_{ab}(m,n;k,l) = E\left\{ a(m,n)\cdot b(k,l) \right\}$
% # The assumption that $u(m,n), v(m,n)$ are jointly Gaussian
% sequence,i.e.:
% $r_{uv}(m,n;k,l) = r_{uv}(m-k, n-l)$
% # The requirement that the error $\left( u(m,n)-\hat{u}(m,n) \right)$
% must be orthogonal to the given sequence $v(m,n)$, which is a necessary
% constrain on the estimator for it to be optimal in mse sense: 
% $E \left\{\left(u(m,n)-\hat{u}(m,n) \right) \cdot v(m',n') \right\} =
% 0$
%
% From (3), we can conclude that $E \left\{u(m,n)\cdot v(m',n')\right\} = E
% \left\{\hat{u}(m,n) \cdot v(m',n')\right\}$ 
%
% Using the linearty constraint on $\hat{u}(m,n)$ and (2)+(1) we get: 
%
% $$r_{uv}(m, n) = \sum_{k=-\infty}^{\infty} \sum_{l=-\infty}^{\infty}
% g(m-k, n-l)\cdot r_{vv}(k, l)$$
%
% And in the Fourier domain (after multping both side of the equation in
% $S_{vv}^-1(\omega_1,\omega_2)$:
%
% $$G(\omega_1,\omega_2) = S_{uv}(\omega_1,\omega_2) \cdot S_{vv}^-1(\omega_1,\omega_2)$$
%
% Using the "Linear degradation model" described in the "Pasudo Inverse
% Filter" experiment, where $v(m,n)$ was the result of a linear operation
% on $u(m,n)$, added white Gaussian noise, we get:
%
% $$v(m,n) = \sum_{k=-\infty}^{\infty} \sum_{l=-\infty}^{\infty}
% h(m-k, n-l)\cdot u(k, l) + \eta(m,n)$$
%
% where $\eta(m,n)$ is a gaussian stationary noise, uncorrelated with
% $u(m,n)$, and with a known power spectra $S_{\eta\eta}(\omega_1,\omega_2)$.
%
% _*Wiener Filter*_
%
% The last results allow us to dirive the linear filter needed to estimate
% $u(m,n)$ from $v(m,n)$ mse optimal. Consider the power spectrums
% $S_{vv}(\omega_1,\omega_2)$ and $S_{uv}(\omega_1,\omega_2)$:
% 
% $$S_{vv}(\omega_1,\omega_2) = \left|H(\omega_1,\omega_2)\right|^2 \cdot
% S_{uu}(\omega_1,\omega_2) + S_{\eta\eta}(\omega_1,\omega_2)$$
%
% $$S_{uv}(\omega_1,\omega_2) = H^*(\omega_1,\omega_2) \cdot S_{uu}(\omega_1,\omega_2) $$ 
%
% Minimization of the minimum square error $\left(
% u(m,n)-\hat{u}(m,n) \right)$ requires that the error must be   
% orthogonal to the given sequence $v(m,n)$: $E \left\{
% \left(u(m,n)-\hat{u}(m,n) \right) \cdot v(m',n') \right\}$.
% White Gaussian 
% * $I(m,n)$ - is the input image.
% * $h(m,n)$ - is a blur kernel, the psf for example.
% * $w(m,n)$ - is an additive white Gaussian noise signal
% $\mathcal{N}(0,\sigma_w^2)$.
% * $y(m,n) = I(m,n)*h(m,n) + w(m,n)$ where $*$ is the convolution
% operation.
%
% _*Linear restoration*_
%
% Linear restoration aim is to restore the original signal $I(m,n)$ from
% the degradated signal $y(m,n)$.
%
% $$\hat{I}(m,n) = h_{inv}(m,n)*y(m,n) = h_{inv}(m,n)*\left(I(m,n)*h(m,n) +
% w(m,n) \right) $$
%
% In the Fourier domain:
%
% $$\hat{ \mathcal{I}}(u,v)  = \mathcal{H}_{inv}(u,v)  \cdot \mathcal{Y}(u,v) =
% \mathcal{H}_{inv}(u,v) \cdot \left( \mathcal{I}(u,v) \cdot
% \mathcal{H}(u,v) + \mathcal{W}(u,v) \right) $$ 
%
% Where:
%
% * $\hat{ \mathcal{I}}(u,v)$ - is the Fourier transform of $\hat{I}(m,n)$.
% * $\mathcal{H}_{inv}(u,v)$ - is the Fourier transform of $h_{inv}(m,n)$.
% * $\mathcal{Y}(u,v)$ - is the Fourier transform of $y(m,n)$.
% * $\mathcal{I}(u,v)$ - is the Fourier transform of $I(m,n)$.
% * $\mathcal{H}(u,v)$ - is the Fourier transform of $H(m,n)$.
% * $\mathcal{W}(u,v)$ - is a representation of the Fourier transform of $w(m,n)$.
%
% _*Inverse Filter*_ 
%
% Inverse Filter is a nin blind ( which means that the blurring kernel is
% known) linear restoration solution which uses prior knowledge of the blur
% kernel $h(m,n)$ to restore the original signal $I(m,n)$. 
%
% The Inverse Filter designed to cancel the effect of $H(m,n)$,
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
% The blurring kernel $h(m,n)$ have the effect of suppressing the high
% frequencies of the image. this means that the inverse of $h(m,n)$,
% $h_{inv}(m,n)$, has the opposite effect.
%
% since the AWGN exist in the high frequencies, as well as in the low
% frequencies, implement the Inverse Filter on $y(m,n)$ will result in
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
% $$\hat{I}_{final}(m,n) = I(m,n) + \left\{ \begin{array}{ll} \hat{I}(m,n) - I(m,n) 
% & \hat{I}(m,n) - I(m,n) \le ThrIm \\ ThrIm & O.W. \end{array} \right. $$
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
% _*Formation of blurred image*_
%
% <html><pre class="codeinput"><p>Code:
%     R=(RD*ImgSz/2)^2;
%     r=radius_mb(ImgSz/2);
%     mask=exp(-(r.^2/(R+eps)));
%     mask=fftshift(mask)+eps;
%     spimg=spimg.*mask;
%     spimg2=abs(spimg).^2;
%     INPIMG_=real(ifft2(spimg));
% </p></pre></html>
%
% _*Formation of additive noise interference*_
%
% <html><pre class="codeinput"><p>Code:
%     noise=NoiseStDev*randn(size(INPIMG);
%     spnoise=(abs(fft2(noise))).^2;
%     N=(mean(mean(spnoise)))*gamma*ones(size(INPIMG));
%     imgn=INPIMG_+noise;
%     spimgn=fft2(imgn);
%     spimgn2=abs(spimgn).^2;
%     spimgn2=conv2(spimgn2,ones(5)/25,'same');
%     sigma=std2(INPIMG-imgn);
% </p></pre></html>
%
% _*Ideal Wiener filter*_
%
% <html><pre class="codeinput"><p>Code:
%     WIENER=spimg2./(spimg2+spnoise);
%     WIENER=WIENER./mask;
%     IMGWIENER=real(ifft2(spimgn.*WIENER));
%     sigma=std2(INPIMG-IMGWIENER);
% </p></pre></html>
%
% _*Empirical Wiener filter*_
%
% <html><pre class="codeinput"><p>Code:
%     EMPWIENER=(spimgn2-N)./spimgn2;
%     EMPWIENER=EMPWIENER.*(EMPWIENER>=0);
%     EMPWIENER=EMPWIENER./mask;
%     IMGEMPWIENER=real(ifft2(spimgn.*EMPWIENER));
%     sigma=std2(INPIMG-IMGEMPWIENER);
% </p></pre></html>
%
%% Reference:
% * [1] Anil K. Jain,“Fundamentals Of Digital Image Processing”, Prentice hall in formation and system sciemce series, Section 8.3, p. 275-280 
% * [2] <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_3.pdfL. Yaroslavsky, Lecture Notes: "Image restoration, enhancement and segmentation: Linear filtering">

function WienerFiltering = WienerFiltering_mb( handles )
	handles = guidata(handles.figure1);
	axes_hor = 2;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	WienerFiltering = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);

	WienerFiltering.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
	WienerFiltering.gamma = 2;
	WienerFiltering.SNR = 5;
	WienerFiltering.RD = 20;


	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);

	k=k+1;       
	interface_params =  SetSliderParams('Weight parameter for empir. Wiener filter', 5, 1, WienerFiltering.gamma, 0.25, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'gamma',@update_sliders), interface_params, k);

	k=k+1;    
	interface_params =  SetSliderParams('Set blurring filter Fr.Response spread', 50, 10, WienerFiltering.RD, 10, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RD',@update_sliders), interface_params, k);
	
    k=k+1;
	interface_params =  SetSliderParams('Set additive noise stand. deviation', 25, 0, WienerFiltering.SNR, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SNR',@update_sliders), interface_params, k);



	WienerFiltering.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		 

	process_image(WienerFiltering.im, WienerFiltering.gamma, WienerFiltering.SNR, WienerFiltering.RD , ...
	WienerFiltering.axes_1, WienerFiltering.axes_2, WienerFiltering.axes_3, WienerFiltering.axes_4)
%     process_image(WienerFiltering.im, WienerFiltering.gamma, WienerFiltering.NoiseStDev, WienerFiltering.RD ,WienerFiltering.WndSz, ...
% 	WienerFiltering.axes_1, WienerFiltering.axes_2, WienerFiltering.axes_3, WienerFiltering.axes_4)
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
    WienerFiltering = handles.(handles.current_experiment_name);
    process_image(WienerFiltering.im, WienerFiltering.gamma, WienerFiltering.SNR, WienerFiltering.RD ,...
        WienerFiltering.axes_1, WienerFiltering.axes_2, WienerFiltering.axes_3, WienerFiltering.axes_4)
%     process_image(WienerFiltering.im, WienerFiltering.gamma, WienerFiltering.NoiseStDev, WienerFiltering.RD ,WienerFiltering.WndSz, ...
%         WienerFiltering.axes_1, WienerFiltering.axes_2, WienerFiltering.axes_3, WienerFiltering.axes_4)
end

function     process_image(im, gamma, SNR, RD , axes_1, axes_2, axes_3, axes_4)

imshow(im, [0 255], 'parent', axes_1);
DisplayAxesTitle( axes_1, ['Test image'], 'TM');

[im IMGWIENER IMGEMPWIENER]=wiener_mb(im,gamma,SNR,RD);
imshow(im, [0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, ['Blurred test image with noise'], 'TM',10);  

imshow(IMGWIENER,[0 255],  'parent', axes_3);
Error_id=im-IMGWIENER;
ErrorStDev_id=sqrt(mean((Error_id(:)).^2)-(mean(Error_id(:))).^2);
DisplayAxesTitle( axes_3, ['Restored image: ideal Wiener filter; ErrorStDev=',num2str(ErrorStDev_id,3)],'BM',9);  
Error_emp=im-IMGEMPWIENER;
ErrorStDev_emp=sqrt(mean((Error_emp(:)).^2)-(mean(Error_emp(:))).^2);
imshow(IMGEMPWIENER, [0 255] ,'parent', axes_4);
DisplayAxesTitle( axes_4, ['Restored image: empirical Wiener filter; ErrorStDev=',num2str(ErrorStDev_emp,3)],'BM',9);  
   

end

