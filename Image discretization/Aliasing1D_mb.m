%% Aliasing in 1D signals
%  under-sampling of 1D signal, and aliasing effect.
%% Experiment Description:
% This experiment demonstrates the aliasing effect which occurs when
% sampling a 1D signal in a frequency less then Nyquist frequency.
%
% Given K value, the 1-d input signal is calculated:
%
% $$ t = 0:511 $$
%
% $$ X(t) = cos((0.1 \cdot k) \cdot t)+0.5 $$
%
% For each frequency the original signal, and its Fourier transform are displayed.
%
% The experiment automatically changes the value for k for 1 till 64, and displayed the 1-D Fourier transform for each k value.
%% Tasks:
% * Observe and explain discretization aliasing effects on sinusoidal signals
% of different frequency.
%% Instruction:
%% Theoretical Background:
%
% To demonstrate the sampling theorem, the figure below shows the sampling of
% sinusoidal signals of various frequencies. As can be seen, when the frequency
% is higher than half of the sampling rate, aliasing occurs.
%
% <<sampling3.png>>
%
% The same sampling process can be further illustrated in the frequency domain
% as shown in the figure below. The spectrum of the sinusoidal signal
% $x(t)=cos(\omega_0 t)=cos(2\pi f_0)$ is
% $X(\omega)=\delta(\omega-\omega_0)+\delta(\omega+\omega_0)$, containing two
% delta impulses at $\omega=\omega_0$ on either side of the origin, as shown
% in (a).
%
% To sample the signal, $x(t)$ is multiplied by a comb $p(t)$ in time domain, or
% equivalently, its spectrum $X(\omega)$ is convolved with $P(\omega)$ to become
% $X_p(\omega)=X(\omega) * P(\omega)$, as shown in (b). Note that the period of
% $P( \omega)$ equals to the sampling frequency $\omega_s=1/T_s$, and the
% convolution has infinite copies of $X(\omega)$ (the two delta impulses)
% separated by distance $\omega_s$.
%
% In (b) and (c), $\omega_0<\omega_s/2$, i.e., the original copy of
% $X(\omega)$ is inside the window of the ideal low-pass filter (with cut-off
% frequency $\omega_s/2$) which can perfectly reconstruct the original signal
% $x(t)$ from its samples.
%
% In (d) and (e), $\omega_0>\omega_s/2$, i.e., the original copy of $X(\omega)$
% is outside the window of the ideal low-pass filter. Instead, the low-pass filter
% will catch the copies of $X(\omega)$ in the next higher frequency range (both
% positive and negative). In the case, the reconstructed signal by low-pass
% filtering will appear to be at frequency $\omega_s-\omega_0$ (represented by
% the impulses inside the window of the ideal filter), which is lower than the
% actual frequency $\omega_0$, i.e., aliasing occurs.
%
% <<sampling4.png>>
%% Reference:
% * [1]
% <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/L4_SignalDiscreti&Sampling.pdf
% L. Yaroslavsky, Lec. 4 Principles of signal digitization. Signal sampling>


function Aliasing1D = Aliasing1D_mb( handles )
   handles = guidata(handles.figure1);
    axes_pos = {[3,1]};
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    Aliasing1D = DeployAxes( handles.figure1, ...
                                        axes_pos, ...
                                        bottom, ...
                                        left, ...
                                        0.9, ...
                                        0.9);
    % initialization
    t=0:511;
    h = imshow(zeros(64, length(t)), 'parent', Aliasing1D.axes_3);
    set(h, 'tag', 'DFT_K_Image');
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);

    Aliasing1D.buttongroup_handle = SetInteractiveInterface(handles, interface_params);
    process_image( Aliasing1D.axes_1, Aliasing1D.axes_2, Aliasing1D.axes_3, 1);
end

function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
    back_button_callback = get(handles.BACKpushbutton, 'callback');
    set(handles.BACKpushbutton, 'callback', []);
    Aliasing1D = handles.(handles.current_experiment_name);
    process_image( Aliasing1D.axes_1, Aliasing1D.axes_2, Aliasing1D.axes_3, 63);
    set(handles.BACKpushbutton, 'callback', back_button_callback);
end

function process_image( axes_1, axes_2, axes_3, max_k)
%     t = linspace(-1, 1, num_of_samples);
    t=0:511 ;
    tt=0:2047;
    Bandwidth=zeros(1,2048);Bandwidth(512)=0.2;Bandwidth(1536)=0.2;
    h = imshow(zeros(63, length(t)), 'parent', axes_3);
    set(h, 'tag', 'DFT_K_Image');
    for k = 1 : max_k,
    signal2 = cos((pi*k)*tt/64)+0.5;
    signal = cos((2*pi*k)*t/64)+0.5;
%     plot(t, signal, 'parent', axes_1);
    plot(1:128, signal(1:128), 'LineWidth',2,'parent', axes_1);
    axis(axes_1, 'tight');
    %set(axes_1 , 'Xlim', [min(t) max(t)], 'Ylim', [-0.5 1.5]);
%     fft_signal = abs(fftshift(fft(signal)));
    fft_signal2 = abs(fftshift(fft(signal2)));
    fft_signal = abs(fftshift(fft(signal)));
    fft_signal1=zeros(1,2048);fft_signal1(1024-511:1024+512)=kron(fft_signal,ones(1,2));
    title( axes_1, {'  ' , ['Sampled and reconstructed signal: cos(2pi*K*t/64) + 0.5;',' K=',num2str(k)]}, 'fontweight', 'bold');
    grid(axes_1, 'on');
    %plot((t - 255)/512, fft_signal , 'parent', axes_2);
    plot((tt - 1024)/1024, fft_signal2/max(fft_signal2),'^-b',......
        (tt - 1024)/1024, fft_signal1/max(fft_signal1),'g',......
        (tt - 1024)/1024,Bandwidth,'r','LineWidth',2,'parent', axes_2);
    xlabel(axes_2, 't','fontweight','bold','fontsize',9)
    legend(axes_2, 'Non-sampled signal spectrum','Sampled signal spectrum','Sampling rate');
    axis(axes_2, 'tight');
    %set(axes_2 , 'Xlim', [min(t) max(t)]);
    grid(axes_2, 'on');


    title( axes_2, {'Spectra of non-sampled and sampled signals'} , 'fontweight', 'bold');
    axes_3_children = get(axes_3, 'children');
    image_handle = axes_3_children(strcmpi(get(axes_3_children, 'tag') ,  'DFT_K_Image'));


    cdate = get(image_handle, 'cdata');
    delete(image_handle);
    if ( size(cdate,2) == length(fft_signal))
        cdate(k,:) =uint8((255*fft_signal-min(fft_signal(:)))/(max(fft_signal(:)) - min(fft_signal(:))));
    else
        cdate = zeros(3140/20, length(t));
        cdate(k,:) =uint8((255*fft_signal-min(fft_signal(:)))/(max(fft_signal(:)) - min(fft_signal(:))));
    end
    %h =imshow(cdate, [0 255], 'parent', axes_3);
    h =image(cdate, 'parent', axes_3, 'XData', [-255 256]/512, 'YData', [1 64]);
    set(h, 'tag' , 'DFT_K_Image');

    xlabel('Normalized frequency', 'parent', axes_3, 'fontsize', 10,'fontweight','bold');
    ylabel('K', 'parent', axes_3, 'fontsize', 10,'fontweight','bold');
    set(axes_3,'fontsize',10,'fontweight','bold');

%     title(axes_3, 'Signal spectrum');
    title( axes_3, 'Sampled signal spectra', 'fontweight', 'bold');
    drawnow;
    if ( k>1);    
        pause(0.25);
    end
    end
end