%% Image Spectral Quantization
%  Image quantization in spectral domain.
%% Experiment Description:
% Illustration of uniform quantization, Lloyd-Max quantization and
% P-law quantization of one dimensional signal.
%
% This experiment present the original signal without noise, and the same
% signal with noise, after quantization.
%
% Another plot demonstrate the mapping of each quantization method, and the
% original signal histogram.
%
%% Tasks:
% 2.3.1 
%
% * Test nonuniform P-th law quantization of image Fourier spectrum magnitude and uniform quantization of image spectrum phase (program quanamph.m). 
% * Observe image reconstruction quality for different quantization levels of quantization of magnitude and phase. 
% * Determine optimal nonlinearity index P in the nonlinear P-th law quantization of spectrum magnitude, that minimizes RMS error of signal reconstruction.
%
% 2.3.2 
%
% * Test nonuniform P-th law quantization of spectrum orthogonal components (quanspec.m). 
% * Observe image reconstruction quality for different quantization parameters.
% * Determine optimal nonlinearity index P, that minimizes RMS error of signal reconstruction.
%% Instruction:
% Use the 'Set AWGN STD' slider to set the standard deviation of the additive
% white Gaussian noise added to the signal.
%
% Use the 'Set p for the Pth-law quantization' to set the p parameter of
% the p-law quantization (see Theoretical Background).
% 
% Use the 'Set p for the Pth-law quantization' to set the p parameter of
% the p-law quantization (see Theoretical Background).
%
%% Theoretical Background:
% In many applications (such as image block transform coding), DCT or FFT
% of the image is computed and spectral coefficients are quantized individually.
% 
% Two different spectral quantizations are introduced:
%
% 1. *_Orthogonal Components P-Law Quantization_*
%
% In "Orthogonal Components P-Law Quantization"  the real and imaginary
% parts of image spectrum are quantized using P-Law quantization.
%
% Algorithm:
% 
% # $$ Im_{fft} = FFT\{Im \} $$
% # $$ FFT_{REAL} = REAL\{Im_{fft}\}, FFT_{IMAGINARY} = IMAGINARY\{Im_{fft}\} $$
% # $$ FFT_{REAL}^Q = Quantize_{P-LAW}\{FFT_{REAL}\}, FFT_{IMAGINARY}^Q = Quantize_{P-LAW}\{FFT_{IMAGINARY}\} $$ 
% # $$ Im_{Restored} = IFFT\{  FFT_{REAL}^Q+j \cdot FFT_{IMAGINARY}^Q \}$$
%
% 2. *_Amplitude-Phase P-Law Quantization_*
%
% In "Amplitude-Phase P-Law Quantization"  the amplitude is quantized
% using p-law quantization, and phase is uniformly quantized.
%
% Algorithm:
% 
% # $$ Im_{fft} = FFT\{Im \} $$
% # $$ FFT_{REAL} = REAL\{Im_{fft}\}, FFT_{IMAGINARY} = IMAGINARY\{Im_{fft}\} $$
% # $$ FFT_{Absolute} = sqrt(FFT_{REAL}^2 + FFT_{IMAGINARY}^2) $$
% # $$ FFT_{Phase} = atan(FFT_{IMAGINARY}/FFT_{REAL}) $$
% # $$ FFT_{Absolute}^Q = Quantize_{P-LAW}\{FFT_{Absolute}\}, FFT_{Phase}^Q = Quantize_{uniform}\{FFT_{Phase}\} $$ 
% # $$ Im_{Restored} = IFFT\{  FFT_{Absolute}^Q \cdot e^{j\cdot FFT_{Phase}^Q} \}$$
% 
%% Reference:
% * [1]
% <http://books.google.co.il/books?id=qemYYMOZQIcC&pg=PA107&lpg=PA107&source=bl&ots=3WyNNQnj4O&sig=fmmV6a2EPxBlszNcVmuJLaHw6pY&hl=iw&sa=X&ei=7X3pUr2bFaqP5ASGiIHYCA&ved=0CCkQ6AEwAA#v=onepage&q&f=false
% Leonid P. Yaroslavsky, Theoretical Foundations of Digital Imaging Using
% MATLAB, page 107>
% * [2]
% <<http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/L5ImageQuantization.pdf,
% L. Yaroslavsky, Lec. 5 Optimal scalar quantization of images in signal and transform
% domains>>
% * [3] MacQueen, J. B. (1967). "Some Methods for classification and Analysis of Multivariate Observations". Proceedings of 5th Berkeley Symposium on Mathematical Statistics and Probability 1. University of California Press. pp. 281–297. MR 0214227. Zbl 0214.46201. Retrieved 2009-04-07.
% * [4] E.W. Forgy (1965). "Cluster analysis of multivariate data: efficiency versus interpretability of classifications". Biometrics 21: 768–769.
% * [5] <<http://fourier.eng.hmc.edu/e161/lectures/digital_image/node2.html Ruye Wang, Computer Image Processing and Analysis (E161)>>

function ImageSpectralQuantization = ImageSpectralQuantization_mb( handles )
    %non-uniform_QUANTIZATION Summary of this function goes here
    %   Detailed explanation goes here
    axes_pos = [3,2];
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    ImageSpectralQuantization = DeployAxes( handles.figure1, ...
                                            axes_pos, ...
                                            bottom, ...
                                            left, ...
                                            0.9, ...
                                            0.9);
    %
    ImageSpectralQuantization.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    ImageSpectralQuantization.p1 = 0.25;
    ImageSpectralQuantization.p2 = 0.25;
    ImageSpectralQuantization.q_amp  = 5;
    ImageSpectralQuantization.q_phase= 5;
    ImageSpectralQuantization.q_orth= 5;
    %
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    
	k=k+1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Find min RMS P';
	interface_params(k).callback = @(a,b)find_min_rms_p(a);
    
	k=k+1;
    interface_params =  SetSliderParams('Orthogonal components quantiz. P value', 1, 0, ImageSpectralQuantization.p2, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'p2',@update_sliders), interface_params, k);

    k=k+1;
    interface_params =  SetSliderParams('Amplitude quantization P value', 1, 0, ImageSpectralQuantization.p1, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'p1',@update_sliders), interface_params, k);
    
    k=k+1;
    interface_params =  SetSliderParams('Phase bits per sample', 8, 0, ImageSpectralQuantization.q_phase, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'q_phase',@update_sliders), interface_params, k);

    k=k+1;
    interface_params =  SetSliderParams('Amplitude bits per sample', 8, 0, ImageSpectralQuantization.q_amp, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'q_amp',@update_sliders), interface_params, k);

    k=k+1;
    interface_params =  SetSliderParams('Orthogonal components bits per sample', 8, 0, ImageSpectralQuantization.q_orth, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'q_orth',@update_sliders), interface_params, k);

    ImageSpectralQuantization.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
    guidata(handles.figure1, handles);
    

    process_image( ImageSpectralQuantization.im, ...
    2^ImageSpectralQuantization.q_amp, ...
    2^ImageSpectralQuantization.q_phase, ...
    2^ImageSpectralQuantization.q_orth, ...
    ImageSpectralQuantization.p1, ...
    ImageSpectralQuantization.p2, ...
    ImageSpectralQuantization.axes_1, ...
    ImageSpectralQuantization.axes_2, ...
    ImageSpectralQuantization.axes_3, ...
    ImageSpectralQuantization.axes_4, ...
    ImageSpectralQuantization.axes_5, ...
    ImageSpectralQuantization.axes_6);
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
    guidata(handles.figure1, handles);
    ImageSpectralQuantization = handles.(handles.current_experiment_name);
    process_image( ImageSpectralQuantization.im, ...
                    2^ImageSpectralQuantization.q_amp, ...
                    2^ImageSpectralQuantization.q_phase, ...
                    2^ImageSpectralQuantization.q_orth, ...
                    ImageSpectralQuantization.p1, ...
                    ImageSpectralQuantization.p2, ...
                    ImageSpectralQuantization.axes_1, ...
                    ImageSpectralQuantization.axes_2, ...
                    ImageSpectralQuantization.axes_3, ...
                    ImageSpectralQuantization.axes_4, ...
                    ImageSpectralQuantization.axes_5, ...
                    ImageSpectralQuantization.axes_6);

end


function find_min_rms_p(figure_handle)    
    handles = guidata(figure_handle);
    im = handles.(handles.current_experiment_name).im;
    im_fft = fft2(im);
    rms_quanspec_min = inf;
    rms_amph_min = inf;
    h =waitbar(0, 'please wait');
    for p = 0.1:0.01:1;
        im_spec = ifft2(quanspec_mb(im_fft,2^handles.(handles.current_experiment_name).q_orth,p));
        rms = sqrt(sum(sum((double(im)-double(im_spec)).^2))); 
        if ( rms_quanspec_min > rms ) 
            rms_quanspec_min = rms;
            p_quanspec_min = p;
        end
        
        quan_amph=quanamph_mb(im_fft,2^handles.(handles.current_experiment_name).q_amp,2^handles.(handles.current_experiment_name).q_phase,p);
        im_amph = ifft2(quan_amph);    
        rms = sqrt(sum(sum((double(im)-double(im_amph)).^2))); 
        if ( rms_amph_min > rms ) 
            rms_amph_min = rms;
            p_amph_min = p;
        end
        waitbar( p, h);
    end
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider4');
    set(slider_handle, 'value', p_amph_min);
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value4');
    set(slider_title_handle, 'string', num2str(p_amph_min));
    
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider3');
    set(slider_handle, 'value', p_quanspec_min);
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value3');
    set(slider_title_handle, 'string', num2str(p_quanspec_min));
    close(h);    
    handles.(handles.current_experiment_name).p1 = p_amph_min;
    handles.(handles.current_experiment_name).p2 = p_quanspec_min;
    guidata(figure_handle, handles);
    ImageSpectralQuantization = handles.(handles.current_experiment_name);
    process_image( ImageSpectralQuantization.im, ...
                    2^ImageSpectralQuantization.q_amp, ...
                    2^ImageSpectralQuantization.q_phase, ...
                    2^ImageSpectralQuantization.q_orth, ...
                    ImageSpectralQuantization.p1, ...
                    ImageSpectralQuantization.p2, ...
                    ImageSpectralQuantization.axes_1, ...
                    ImageSpectralQuantization.axes_2, ...
                    ImageSpectralQuantization.axes_3, ...
                    ImageSpectralQuantization.axes_4, ...
                    ImageSpectralQuantization.axes_5, ...
                    ImageSpectralQuantization.axes_6); 
    
end

function process_image( im, q_amp, q_phase, q_orth, p1, p2, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
        im_fft = fft2(im);
        imshow(im, [0 255],'parent', axes_1 );
        DisplayAxesTitle( axes_1, ['Test image'],   'TM');
        show_spectrum(im_fft, axes_4, 1);
        DisplayAxesTitle( axes_4, ['Image DFT spectrum'],   'BM');        

        quan_spec = quanspec_mb(im_fft,q_orth,p2);
        im_spec = ifft2(quan_spec);
        imshow(abs(im_spec), [0 255],'parent', axes_2 );
        rms = CalcRMS( im, im_spec ); 
        DisplayAxesTitle( axes_2, {'DFT orthogonal components quantization', ['RMS error= ' num2str(rms,'%1.1f\n'), ' P = ' num2str(p2)]},   'TM');

        show_spectrum(quan_spec, axes_5, 1);
        DisplayAxesTitle( axes_5, ['Orthogonal components quantized DFT'],   'BM');      
        
        quan_amph=quanamph_mb(im_fft,q_amp,q_phase,p1);
        im_amph = ifft2(quan_amph);
        imshow(abs(im_amph) , [0 255], 'parent', axes_3 );
        rms = CalcRMS( im, abs(im_amph)); 
        DisplayAxesTitle( axes_3, {'DFT Phase-Amplitude quantization', ['RMS error= ' num2str(rms,'%1.1f\n'), ' P = ' num2str(p1)]},   'TM');                   
        show_spectrum(quan_amph, axes_6, 1);
        DisplayAxesTitle( axes_6, ['Phase-Amplitude quantized DFT'],   'BM');      

end
