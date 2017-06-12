%% Very Small Objects Detection
% Detection and localization of very small objects
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
% 8.4.1. 
% 
% # Test detection of microcalcifications in mammograms using program
% smobjdet.m (image mam2_256.img). 
% # Explain the role of the low pass filter implemented in the program.
%% Instruction:
%% Theoretical Background:
% _Image Translation retrival usign matched filter in the frequancy domain_
%
% The basis of the Fourier-based motion estimation is the shift
% property[23] of the Fourier transform. Denote by:
%
% $$ 1.1 \hspace{0.5in} {\mathcal {F}}\{ f({x,y})\} = F({\omega_{x},\omega_{y}})$$
%
% The Fourier transform of $f(x,y)$ Then:
%
% $$1.2 \hspace{0.5in} {\mathcal {F}} \left\{ f\left( {x+\Delta x,y+\Delta y} \right) \right\}
% = {F}\left( {\omega_{x},\omega_{y}}\right) \cdot e^{j \left(
% {\omega_{x}\Delta x+\omega_{y}\Delta y} \right)}$$
%
% The latest equation can be used for the estimation of image translation. 
% Assume the images Formula and Formula satisfy
%
% $$1.3 \hspace{0.5in} I_{1}\left( {x+\Delta x,y+\Delta y}\right ) = I_{2}\left( {x,y}\right)$$
%
% Performing Fourier transform on both sides of the Equation, yielding:
%
% $$1.4 \hspace{0.5in} \mathcal {I}_{1}\left( {\omega_{x},\omega_{y}}\right) e^{j\left(
% {\omega _{x}\Delta x+\omega _{y}\Delta y}\right) }= \mathcal{I}_{2}\left( {\omega_{x},\omega_{y}}\right)$$
%
% and
%
% $$1.5 \hspace{0.5in} {{ \mathcal{I}{_{2}\left( {\omega_{x},\omega_{y}}\right) }}\over {
% \mathcal{I}{_{1}\left ( {\omega _{x},\omega _{y}}\right) }}}=e^{j\left(
% {\omega_{x}\Delta x+\omega_{y}\Delta y}\right)}$$
%
% Thus, the translation parameters $(\Delta x, \Delta y)$ can be estimated
% in the spatial domain by computing the inverse FFT of (1.5):
%
% $$1.6 \hspace{0.5in} {Corr}\left( {x,y}\right) = {\mathcal{F}}^{-1} \left\{e^{j\left(
% {\omega_{x}\Delta x+\omega_{y}\Delta y}\right)}\right\} = {\delta }
% \left( x+{\Delta x,y+\Delta y}\right)$$
%
% and finding the position of the maximum value of the correlation function
% $Corr(x,y)$:
%
% $$1.7 \hspace{0.5in} \left( {x,y}\right) =\arg {\max \limits_{\left( {
% \hat{x},\hat{y}}\right)}} \left\{ {Corr} \left( { {\hat{x}},
% {\hat{y}}}\right) \right\} $$
%
% Further robustness to intensity differences between the images is
% achieved using the normalized phase correlation:
%
% $$1.8 \hspace{0.5in} \widetilde{Corr}\left ( {\omega_{x},\omega_{y}}\right)
% =\frac{\widehat{I}_2 \left( {\omega_{x},\omega_{y}} \right)\left\vert
% \widehat{I}_1 \left(
% {\omega_{x},\omega_{y}}\right)\right\vert}{\left\vert
% \widehat{I}_{2}\left({\omega _{x},\omega _{y}}\right) \right\vert
% \widehat{I}_{1}\left({\omega _{x},\omega _{y}}\right)} =
% \frac{\widehat{I}_{2}\left( {\omega_{x},\omega _{y}}\right )
% \widehat{I}_{1}^* \left({\omega _{x},\omega _{y}}\right)}{\left\vert
% \widehat{I}_{2}\left( {\omega _{x},\omega _{y}}\right) \right\vert
% \left\vert \widehat{I}_{1}^{*}\left( {\omega _{x},\omega
% _{y}}\right)\right\vert} = e^{j\left ( {\omega _{x}\Delta x+\omega
% _{y}\Delta y}\right ) }$$
%
% where $*$ denotes the complex conjugate.
%
% $$ $$
%% Algorithm:
%% Reference:
% # <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_5.pdf L.
% Yaroslavsky, Image parameter estimation, Advanced Image Processing Lab: A
% Tutorial , EUSIPCO200, LECTURE 4.1>
% # <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/Adv_imProc_6.pdf
% L.Yaroslavsky, Target location in clutter, Advanced Image Processing Lab:
% A Tutorial , EUSIPCO200, LECTURE 4.2> 
% # A. Van der Lugt, Signal Detection by Complex Spatial Filtering, IEEE
% Trans., IT-10, 1964, No. 2, p. 139 
% # L.P. Yaroslavsky, The Theory of Optimal Methods for Localization of
% Objects in Pictures, In: Progress in Optics, Ed. E. Wolf, v. XXXII,
% Elsevier Science Publishers, Amsterdam, 1993
% # <http://www.cs.tau.ac.il/~amir1/PS/KELLER/fft_correlation2.pdf A.
% Averbuch, Y. Keller, “A unified approach to FFT based image registration”,
% submitted to the IEEE Trans. On Image Processing.>  
% # L. Yaroslavsky, Target Location: Accuracy, Reliability and Optimal
% Adaptive Filters, TICSP series, Tampere Int. Center for Signal
% processing, TTKK, Monistamo, 1999
function DetectionOfVerySmallObjects = DetectionOfVerySmallObjects_mb( handles )
   handles = guidata(handles.figure1);
   axes_hor = 2;
   axes_ver = 1;
   button_pos = get(handles.pushbutton12, 'position');
   bottom =button_pos(2);
   left = button_pos(1)+button_pos(3);
        DetectionOfVerySmallObjects = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);
    DetectionOfVerySmallObjects.obj = 3;
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
    interface_params =  SetSliderParams(  'Set small object size', 11, 1, DetectionOfVerySmallObjects.obj, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'obj',@update_sliders), interface_params, k);             
    
    
    
    
    
    
    
    
    
    
    
    DetectionOfVerySmallObjects.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
     

    DetectionOfVerySmallObjects.im_1 = HandleFileList('load' , HandleFileList('get' , handles.image_index));


    image(DetectionOfVerySmallObjects.im_1, 'parent', DetectionOfVerySmallObjects.axes_1, 'ButtonDownFcn', @(a,b)ChooseObj(a,b));
    colormap(gray(256));
    axis(DetectionOfVerySmallObjects.axes_1, 'image', 'off');
    title(DetectionOfVerySmallObjects.axes_1, 'Test image', 'fontsize', 10, 'fontweight', 'bold');
    process_image(DetectionOfVerySmallObjects.im_1, DetectionOfVerySmallObjects.obj, DetectionOfVerySmallObjects.axes_2);
 
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


    DetectionOfVerySmallObjects = handles.(handles.current_experiment_name);
    process_image(DetectionOfVerySmallObjects.im_1, DetectionOfVerySmallObjects.obj, DetectionOfVerySmallObjects.axes_2);
end

function process_image(im, obj, axes_2)
    xx=1:13; T=exp(-((xx-7).^2)/(sqrt(obj)));Trgt=kron(T,T');
%     obj = ones(obj,obj);
%     im_res = smobjdet_mb(im,obj);
    im_res = smobjdet_mb(im,Trgt);    
    imshow(im_res, 'parent', axes_2);
    title(axes_2, 'Small objects enhanced for detection', 'fontsize', 10, 'fontweight', 'bold');
end
 
