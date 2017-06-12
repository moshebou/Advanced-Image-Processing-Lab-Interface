%% Signals Zoom
%  Nearest neighbor, linear, spline and discrete sinc-interpolation methods

%% Instruction:
% * Choose a section in the input signal plot which you wish to zoom by left
% click the center of the section.  
% * The Window size is controlled by the 'Set Window Size' slider.     
%% Tasks:
%
% 7.1.1. 
%
% Form test signals (delta-impulse, rectangular impulse and “Mexican hat
% impulse”) and zoom them in using nearest neighbor, bilinear, bi-cubic
% interpolation and discrete sinc-interpolation.
% 
% Observe, compare interpolated signals and their spectra.
% Explain Gibbs's effects in discrete sinc-interpolation. 
%
% Explain difference between programs sincint.m, sincint0.m, sincint1.m.
%
% 7.1.2. 
%
% Repeat the same for an image raw and an ECG signal (signals ecg1.mat,
% ecg256.mat can be used as test signals).
%
%% Theoretical Background:
%% Algorithm:
%% 
% * [1]
% <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/sinc_interp.pdf
% L. Yaroslavsky, FAST SIGNAL SINC-INTERPOLATION AND ITS APPLICATIONS IN
% IMAGE PROCESSING>
% * [2]
% <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/BoundEffFreeAdaptSincInterp_ApplOpt.pdf
% L. Yaroslavsky, Boundary effect free and adaptive discrete signal
% sinc-interpolation algorithms for signal and image resampling>  

function SignalsZoom = SignalsZoom_mb( handles )
    axes_pos = {[7,1]};
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    SignalsZoom = DeployAxes( handles.figure1, ...
    axes_pos, ...
    bottom, ...
    left, ...
    0.9, ...
    0.9    );
    %variables initialization    
    SignalsZoom.ZoomFactor = 7;
    
    SignalsZoom.signal = HandleFileList('load' , HandleFileList('get signal' , handles.signal_index));
    SignalsZoom.x = floor(length(SignalsZoom.signal)/2 -1);
    SignalsZoom.WindowSize = 37;
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Press signal plot to zoom in';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;
    % 	interface_params =  SetSliderParams('Set Window Size', round(length(SignalsZoom.signal)/2), 1, SignalsZoom.WindowSize, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WindowSize',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set Window Size',65, 1, SignalsZoom.WindowSize, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WindowSize',@update_sliders), interface_params, k);
    k = k+1;
    interface_params =  SetSliderParams('Set Zoom Factor', 10, 1, SignalsZoom.ZoomFactor, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'ZoomFactor',@update_sliders), interface_params, k);
    SignalsZoom.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 

    % Display initial input image
    plot([ 1 : length(SignalsZoom.signal)], SignalsZoom.signal ,  'parent', SignalsZoom.axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y), 'linewidth', 2);
    grid(SignalsZoom.axes_1,  'on'); 
    axis(SignalsZoom.axes_1, 'tight');
    title(SignalsZoom.axes_1, 'Test signal', 'fontweight', 'bold');

    % Set Axes_1 pointer appearance
    pointerBehavior.enterFcn = @(a,b)ChangePointerAppearanceToCross(a,b, handles);
    pointerBehavior.exitFcn = @(a,b)ChangePointerAppearanceToArrow(a,b, handles);
    pointerBehavior.traverseFcn =[];%@(a,b)CalcLocalHistogram(a,b, handles);
    iptSetPointerBehavior(SignalsZoom.axes_1, pointerBehavior);          
    process_image(SignalsZoom.signal, SignalsZoom.x, SignalsZoom.WindowSize, SignalsZoom.ZoomFactor, ...
    SignalsZoom.axes_1,     SignalsZoom.axes_2, SignalsZoom.axes_3, SignalsZoom.axes_4, ...
    SignalsZoom.axes_5, SignalsZoom.axes_6, SignalsZoom.axes_7);

end


function ChangePointerAppearanceToCross(a,b,  handles)
 handles = guidata(handles.figure1);
set(handles.figure1,'Pointer', 'crosshair');
end

function ChangePointerAppearanceToArrow(a,b,  handles)
 handles = guidata(handles.figure1);
set(handles.figure1,'Pointer', 'arrow');
end

function UpdateLocalData(image_handles,y,z)
axes_handles  =get(image_handles, 'parent');
figure_handle = get(axes_handles, 'parent');
handles = guidata(figure_handle);
pointer_pos = get(axes_handles, 'CurrentPoint');
handles.(handles.current_experiment_name).x = round(pointer_pos(1,1));
guidata(figure_handle, handles);
SignalsZoom = handles.(handles.current_experiment_name);
process_image(SignalsZoom.signal, SignalsZoom.x, SignalsZoom.WindowSize, SignalsZoom.ZoomFactor, ...
SignalsZoom.axes_1,     SignalsZoom.axes_2, SignalsZoom.axes_3, SignalsZoom.axes_4, ...
SignalsZoom.axes_5, SignalsZoom.axes_6, SignalsZoom.axes_7);
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
    SignalsZoom = handles.(handles.current_experiment_name);
    if ( isfield(SignalsZoom, 'x') && ~isempty(SignalsZoom.x))
        
        process_image(SignalsZoom.signal, SignalsZoom.x, SignalsZoom.WindowSize, SignalsZoom.ZoomFactor, ...
        SignalsZoom.axes_1,     SignalsZoom.axes_2, SignalsZoom.axes_3, SignalsZoom.axes_4, ...
        SignalsZoom.axes_5, SignalsZoom.axes_6, SignalsZoom.axes_7);
    end
end

function process_image(im, x, window_size, zoom_ratio, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6, axes_7)
axes_1_children = get(axes_1, 'children');
x_marker = axes_1_children ( strcmpi(get(axes_1_children, 'tag'), 'x_marker'));
zoom_marker = axes_1_children ( strcmpi(get(axes_1_children, 'tag'), 'zoom_marker'));
delete(x_marker);
delete(zoom_marker);

x_start = max(1, x-ceil(window_size/2)+1);
x_end = min(length(im), x_start+window_size-1);
if ( x_end == length(im) )
    x_start = (x_end-window_size);
end
hold( axes_1, 'on');
plot(axes_1, x, im(x), 'x', 'color', 'r', 'tag', 'x_marker');
axes_1_y_lim = get(axes_1, 'ylim');
plot(axes_1, [x_start:x_end], mean(axes_1_y_lim)*ones(length([x_start:x_end]), 1), 'k', 'LineWidth', 2, 'tag', 'zoom_marker');
plot(axes_1, [x_end], mean(axes_1_y_lim), 'k', 'Marker', '>', 'LineWidth', 1, 'tag', 'zoom_marker');
plot(axes_1, [x_start], mean(axes_1_y_lim), 'k', 'Marker', '<', 'LineWidth', 1, 'tag', 'zoom_marker');


interp_length = zoom_ratio*window_size;
Y = im(x_start:x_end);
Y = Y(:);
Lx = round(interp_length/length(Y));
interp_length = Lx*length(Y);
xi = linspace(x_start , x_end+1, interp_length+1);
xi = xi(1:end-1);
hold(axes_2, 'off'); hold(axes_3, 'off'); hold(axes_4, 'off'); hold(axes_5, 'off'); hold(axes_6, 'off'); hold(axes_7, 'off'); 
plot(x_start:x_end,  Y, 'parent', axes_2,'LineStyle', 'none', 'Marker', 'o', 'color', 'r', 'linewidth', 2); set(axes_2, 'xlim',[x_start-1, x_end+1], 'ylim', [min(Y)-1, max(Y)+1]);
grid(axes_2, 'on' );hold(axes_2, 'on');
plot(x_start:x_end,  Y, 'parent', axes_3,'LineStyle', 'none', 'Marker', 'o', 'color', 'r', 'linewidth', 2); set(axes_3, 'xlim',[x_start-1, x_end+1], 'ylim', [min(Y)-1, max(Y)+1]);
grid(axes_3, 'on' );hold(axes_3, 'on');
plot(x_start:x_end,  Y, 'parent', axes_4,'LineStyle', 'none', 'Marker', 'o', 'color', 'r', 'linewidth', 2); set(axes_4, 'xlim',[x_start-1, x_end+1], 'ylim', [min(Y)-1, max(Y)+1]);
grid(axes_4, 'on' );hold(axes_4, 'on');
plot(x_start:x_end,  Y, 'parent', axes_5,'LineStyle', 'none', 'Marker', 'o', 'color', 'r', 'linewidth', 2); set(axes_5, 'xlim',[x_start-1, x_end+1], 'ylim', [min(Y)-1, max(Y)+1]);
grid(axes_5, 'on' );hold(axes_5, 'on');
plot(x_start:x_end,  Y, 'parent', axes_6,'LineStyle', 'none', 'Marker', 'o', 'color', 'r', 'linewidth', 2); set(axes_6, 'xlim',[x_start-1, x_end+1], 'ylim', [min(Y)-1, max(Y)+1]);
grid(axes_6, 'on' );hold(axes_6, 'on');
plot(x_start:x_end, Y, 'parent', axes_7,'LineStyle', 'none', 'Marker', 'o', 'color', 'r', 'linewidth', 2); set(axes_7, 'xlim',[x_start-1, x_end+1], 'ylim', [min(Y)-1, max(Y)+1]);
grid(axes_7, 'on' );hold(axes_7, 'on');

% stem(xi, interp1([1:length(im)],im,   xi,  'nearest'),  'parent', axes_2, 'linewidth', 1);
stem(xi, interp1([1:length(im)],im,   xi,  'nearest'),'.', 'parent', axes_2, 'linewidth', 1);
title( axes_2, { 'Nearest neighbor interpolation'}, 'fontweight', 'bold');

stem(xi, interp1([1:length(im)],im,   xi, 'linear'),'.', 'parent', axes_3, 'linewidth', 1);
title( axes_3, {'Linear interpolation'}, 'fontweight', 'bold');

t = linspace(-2, 2, 4*zoom_ratio +1 );
u = (abs(t)<1).*((3/2)*abs(t).^3 -(5/2)*abs(t).^2 +1 ) + (abs(t)<2).*(abs(t)>1).*(-(1/2)*abs(t).^3 +(5/2)*abs(t).^2 -4*abs(t)+2 );
bcubic_interp = conv(kron(Y',[1, zeros(1,zoom_ratio-1)]) ,u, 'same');
stem(linspace(min(xi), max(xi), length(bcubic_interp)), bcubic_interp,'.', 'parent', axes_4, 'linewidth', 1);
title( axes_4, {'Cubic spline interpolation'}, 'fontweight', 'bold');

SzX =length(Y);
M=zeros(SzX,1);
SzX_half=round(SzX/2);
Ux=1/(Lx);
M(1)=1; M(SzX_half+1)=exp(1i*pi*Ux);
r=2:SzX_half; Wn=1i*2*pi*Ux/SzX;
M(r)=exp(Wn*(r-1)); M(SzX+2-r)=conj(M(r));
spinput=fft(Y);
 
% sincint_mb
    M(SzX_half+1)=exp(1i*pi*Ux);
    spinput_2 =  (spinput*ones(1,Lx)).*(cumprod([ones(size(M,1),1), M*ones(1, Lx-1)], 2));
    spinput_2(SzX_half+1, :) = real(spinput_2(SzX_half+1, :));
    out = real(ifft(spinput_2)');
    OUTPUT=out(:);

    stem(xi, OUTPUT,'.', 'parent', axes_5, 'linewidth', 1);

    title( axes_5, {'Discrete sinc interpolation (Sincint)'}, 'fontweight', 'bold');
    % sincint1_mb
    M(SzX_half+1)=exp(1i*pi*Ux);
    spinput_2 =  (spinput*ones(1,Lx)).*(cumprod([ones(size(M,1),1), M*ones(1, Lx-1)], 2));
    spinput_2(SzX_half+1, :) = 2*real(spinput_2(SzX_half+1, :));
    out = real(ifft(spinput_2)');
    OUTPUT = out(:);

    stem(xi, OUTPUT,'.', 'parent', axes_6, 'linewidth', 1);

    title( axes_6, {'Discrete sinc interpolation (Sinc-int1)'}, 'fontweight', 'bold');

    M(SzX_half+1)=0;

    spinput_2 =  (spinput*ones(1,Lx)).*(cumprod([ones(size(M,1),1), M*ones(1, Lx-1)], 2));

    out_2 = real(ifft(spinput_2)');
    OUTPUT = out_2(:);

    stem(xi,OUTPUT,'.','parent',axes_7, 'linewidth', 1);

    title( axes_7, {'Discrete sinc interpolation (Sinc-int0)'}, 'fontweight', 'bold');
    axis(axes_1, 'tight');
    axis(axes_2, 'tight');
    axis(axes_3, 'tight');
    axis(axes_4, 'tight');
    axis(axes_5, 'tight');
    axis(axes_6, 'tight');
    axis(axes_7, 'tight');

  


end
