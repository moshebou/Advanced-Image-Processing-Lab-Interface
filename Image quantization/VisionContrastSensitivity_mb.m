%% Vision Contrast Sensitivity
%  rectangle stimulus on uniform background.   
%% Experiment Description:
% Illustration of the contrast notion, and demonstration of the Weber-Fechner_law.
%
% The effect of size, intensity and background on the perceived contrast.
%
% Two experiment types are used:
%
% Variant size with fixed contrast and Variant contrast with fixed size.
%
% *Variant size with fixed contrast*
%
% On a 8 step-wedge image, a rectangle stimulus is displayed.

%% Tasks:
% 2.1.1 
%
% * Generate a step-wedge test image (STW) and an image of a rectangle stimulus on the uniform background (STIM). 
% * Form an image STW+gSTIM. 
% * Obtain threshold visibility contrast of the stimulus as a function of the stimulus's size and of the stimulus contrast parameter g.
%
%% Instruction:
% Using the left mouse button, press the stimulus rectangle as accurately as
% possible.
%
% Upon failure, the stimulus rectangle will change its location, and either
% increase in size (in case of "Variant size with fixed contrast"
% experiment) or increase contrast (in case of "Variant contrast with fixed
% size" experiment.
%
% Upon success, the plot will update, and a new stimulus with smallest size
% or contrast (depending of the experiment) will appear on the next uniform background.
%
% In the "Variant size with fixed contrast" experiment, the contrast can be
% set using the 'Set Contrast' slider.
%
% In the "Variant contrast with fixed size" experiment, the stimulus size can be
% set using the 'Set Size' slider.
%
% In order to switch experiment type, change selection by pressing the
% desired experiments radio button on the radio-button panel.
%% Theoretical Background:
% 
% *Contrast-* 
% 
% Assuming the luminance of an object is $f$ and the luminance difference 
% between the object and its surrounding is $df$, then according to 
% <http://en.wikipedia.org/wiki/Weber-Fechner_law {Weber-Fechner law}>,
% the perceived contrast $dp$ (luminance difference) between the object and its 
% surrounding is
% 
% $$dp=\frac{df}{f}=d(\ln(f))$$
% 
% which indicates that at higher level $f$, larger $df$ is needed to perceive 
% the same contrast at lower level $f$ with a smaller $df$. 
%
% In other words, equal increment in $ln\,f$, instead of in $f$, is perceived to be equally
% different (equal contrast). 
% 				   
% Integrating both sides, we get the perceived luminance
% 
% $$p=\int{ d(\ln(f))}=\ln(f) + C$$
% 
% The constant of integration $C$ can be obtained by assuming the perceived 
% luminance is zero $p=0$:
% 
% $$C=-\ln(f_0)$$
% 
% where $f_0$ is the threshold luminance not perceivable. Now we have
% 
% $$p=\ln(\frac{f}{f_0})$$
% 
% The relationship between stimulus $f$ and perception $p$ is logarithmic. 
% 
%
% Weber-Fechner law of eye sensitivity to object’s contrast:
%
% << Weber-Fechner_law.png >>
%% Reference:
% [1]
% <http://books.google.co.il/books?id=qemYYMOZQIcC&pg=PA107&lpg=PA107&source=bl&ots=3WyNNQnj4O&sig=fmmV6a2EPxBlszNcVmuJLaHw6pY&hl=iw&sa=X&ei=7X3pUr2bFaqP5ASGiIHYCA&ved=0CCkQ6AEwAA#v=onepage&q&f=false
% Leonid P. Yaroslavsky, Theoretical Foundations of Digital Imaging Using
% MATLAB, page 107>
function VisionContrastSensitivity = VisionContrastSensitivity_mb(handles)
    axes_cnt = {[2,1]};
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    VisionContrastSensitivity = DeployAxes( handles.figure1, ...
                                    axes_cnt, ...
                                    bottom, ...
                                    left, ...
                                    0.9, ...
                                    0.9);
    set(VisionContrastSensitivity.axes_2, 'visible', 'off');
    VisionContrastSensitivity.background = [16, 128, 220];
    VisionContrastSensitivity.max_stim_size = 15;
    VisionContrastSensitivity.min_stim_size = 1;
    VisionContrastSensitivity.max_intensity_diff = 35;
    VisionContrastSensitivity.min_intensity_diff = 1;
    axes_units = get(VisionContrastSensitivity.axes_1, 'units');   
    set(VisionContrastSensitivity.axes_1, 'units',  'pixels');
    axes_pos = round(get(VisionContrastSensitivity.axes_1, 'position'));
    set(VisionContrastSensitivity.axes_1, 'units', axes_units);        
    width = axes_pos(3); 
    
    VisionContrastSensitivity.num_bits = log2(3);
    rect_width = floor(width/(2^VisionContrastSensitivity.num_bits));
    VisionContrastSensitivity.pos_x = rect_width:rect_width:width; 
    VisionContrastSensitivity.index = 1;
    
    
    VisionContrastSensitivity.intensity_diff = VisionContrastSensitivity.min_intensity_diff;
    VisionContrastSensitivity.stim_size = VisionContrastSensitivity.min_stim_size;
    VisionContrastSensitivity.line_plot = zeros(length(VisionContrastSensitivity.pos_x), ceil((VisionContrastSensitivity.max_stim_size-VisionContrastSensitivity.min_stim_size+1)/2));
    %
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);

        

    VisionContrastSensitivity.buttongroup_handle = SetInteractiveInterface(handles, interface_params);

    process_image(VisionContrastSensitivity.num_bits,VisionContrastSensitivity.pos_x(VisionContrastSensitivity.index) , ...
    VisionContrastSensitivity.intensity_diff, VisionContrastSensitivity.stim_size, VisionContrastSensitivity.background, ...
    VisionContrastSensitivity.axes_1, VisionContrastSensitivity.axes_2)
end

function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
    handles.(handles.current_experiment_name) = handles.(handles.current_experiment_name);
    handles.(handles.current_experiment_name).index = 1;
    handles.(handles.current_experiment_name).intensity_diff = handles.(handles.current_experiment_name).min_intensity_diff;
    handles.(handles.current_experiment_name).stim_size = handles.(handles.current_experiment_name).min_stim_size;
    handles.(handles.current_experiment_name).line_plot = zeros(length(handles.(handles.current_experiment_name).pos_x), ceil((handles.(handles.current_experiment_name).max_stim_size-handles.(handles.current_experiment_name).min_stim_size+1)/2));
    plot(handles.(handles.current_experiment_name).min_stim_size:2:handles.(handles.current_experiment_name).max_stim_size, handles.(handles.current_experiment_name).line_plot, ...
            'parent', handles.(handles.current_experiment_name).axes_2, 'linewidth', 2);
    DisplayAxesTitle( handles.(handles.current_experiment_name).axes_2, ['Noticeable Size = F(I)' ], 'TM', 9);
    xlabel( handles.(handles.current_experiment_name).axes_2, 'Stim size', 'fontsize', 9, 'fontweight', 'bold');
    ylabel( handles.(handles.current_experiment_name).axes_2, 'Detection Contrast', 'fontsize', 9, 'fontweight', 'bold');
    legend(handles.(handles.current_experiment_name).axes_2, ...
           [ 'bacakground = ', num2str(handles.(handles.current_experiment_name).background(1)) ], ...
           [ 'bacakground = ', num2str(handles.(handles.current_experiment_name).background(2)) ], ...
           [ 'bacakground = ', num2str(handles.(handles.current_experiment_name).background(3)) ]);
    grid(handles.(handles.current_experiment_name).axes_2, 'on');
    process_image(handles.(handles.current_experiment_name).num_bits,handles.(handles.current_experiment_name).pos_x(handles.(handles.current_experiment_name).index) , ...
    handles.(handles.current_experiment_name).intensity_diff, handles.(handles.current_experiment_name).stim_size,  handles.(handles.current_experiment_name).background, ...
    handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_2);
    guidata(handles.figure1,handles);
end


function get_user_pointer_position(image_handle,b, x, y)
    axes_handle = get(image_handle, 'parent');
    pointer_position = get(axes_handle, 'CurrentPoint');
    handles = guidata(get(axes_handle, 'parent'));
    if ( sum(x==round(pointer_position(1,1))) && sum(y==round(pointer_position(1,2))))
        handles.(handles.current_experiment_name).line_plot( handles.(handles.current_experiment_name).index, 1+((handles.(handles.current_experiment_name).stim_size - handles.(handles.current_experiment_name).min_stim_size + 1)-1)/2) = handles.(handles.current_experiment_name).intensity_diff;
        plot(handles.(handles.current_experiment_name).min_stim_size:2:handles.(handles.current_experiment_name).max_stim_size, handles.(handles.current_experiment_name).line_plot, ...
                'parent', handles.(handles.current_experiment_name).axes_2, 'linewidth', 2);
        DisplayAxesTitle( handles.(handles.current_experiment_name).axes_2, ['constrast vs size' ], 'TM', 9);
        xlabel( handles.(handles.current_experiment_name).axes_2, 'Stim size', 'fontsize', 9, 'fontweight', 'bold');
        ylabel( handles.(handles.current_experiment_name).axes_2, 'Detection constrast', 'fontsize', 9, 'fontweight', 'bold');
        legend(handles.(handles.current_experiment_name).axes_2, ...
               [ 'bacakground = ', num2str(handles.(handles.current_experiment_name).background(1)) ], ...
               [ 'bacakground = ', num2str(handles.(handles.current_experiment_name).background(2)) ], ...
               [ 'bacakground = ', num2str(handles.(handles.current_experiment_name).background(3)) ]);
               
        grid(handles.(handles.current_experiment_name).axes_2, 'on');
        if ( handles.(handles.current_experiment_name).stim_size == handles.(handles.current_experiment_name).max_stim_size )
            if ( handles.(handles.current_experiment_name).index == numel(handles.(handles.current_experiment_name).pos_x))
                helpdlg('Experiment is finished;  for repeating the experiment press button "Run experiment"');
            else
                handles.(handles.current_experiment_name).stim_size = handles.(handles.current_experiment_name).min_stim_size;
                handles.(handles.current_experiment_name).intensity_diff = handles.(handles.current_experiment_name).min_intensity_diff;
                handles.(handles.current_experiment_name).index = mod(handles.(handles.current_experiment_name).index, numel(handles.(handles.current_experiment_name).pos_x))+1;
            end
        else
            handles.(handles.current_experiment_name).stim_size = min(handles.(handles.current_experiment_name).max_stim_size, handles.(handles.current_experiment_name).stim_size+2);
            handles.(handles.current_experiment_name).intensity_diff = handles.(handles.current_experiment_name).min_intensity_diff;
        end
    else
        handles.(handles.current_experiment_name).intensity_diff = min(handles.(handles.current_experiment_name).max_intensity_diff, handles.(handles.current_experiment_name).intensity_diff+1);
    end
    VisionContrastSensitivity = handles.(handles.current_experiment_name);
    process_image(VisionContrastSensitivity.num_bits,VisionContrastSensitivity.pos_x(VisionContrastSensitivity.index) , ...
    VisionContrastSensitivity.intensity_diff, VisionContrastSensitivity.stim_size,  VisionContrastSensitivity.background, ...
    VisionContrastSensitivity.axes_1, VisionContrastSensitivity.axes_2);    
    guidata(get(axes_handle, 'parent'),handles);

end


function process_image(num_bits, pos_x,  intensity_diff, stim_size, background, axes_1, axes_2)
        intensity_diff = intensity_diff/255;
        axes_units = get(axes_1, 'units');
        set(axes_1, 'units',  'pixels');
        axes_pos = round(get(axes_1, 'position'));
        set(axes_1, 'units', axes_units);        
        height = axes_pos(4);
        width = axes_pos(3);
        rect_width = floor(width/(2^num_bits));
        handles = guidata(axes_1);
        stim_size = min(rect_width,stim_size);        
        handles.(handles.current_experiment_name).stim_size  = stim_size;
        guidata(axes_1, handles);
        stw = kron(background, ones(round(height), rect_width))/255;
        if ( isempty(pos_x))
            pos_x = round((size(stw,2)-stim_size)/2);
        end
        if (~sum(0 > [ round((size(stw,1)-stim_size)/2):round((size(stw,1)-stim_size)/2) + stim_size-1, pos_x:pos_x+stim_size-1]))
            x = min(size(stw,2), max(1, floor(pos_x- rect_width/2 - stim_size/2):floor(pos_x- rect_width/2 + stim_size/2)-1));
            y = randi(size(stw,1)-stim_size)+ceil(stim_size/2);
            y = min(max(1,floor(y-stim_size/2):floor(y+stim_size/2)-1),size(stw,1));
            background = stw(max(y)+1, max(x)+1);
            if ( 0 == background )  
                background = 2^(-num_bits-1);
            end

            color1 = double(background) + double(intensity_diff);
            color2 = double(background) - double(intensity_diff);
            if  (color1 > 1) 
                if ( color2 > 0 )
                    color = color2;
                else
                    if ( color1-255 > -color2 )
                        color = color2;
                    else
                        color = color1;
                    end
                end
            else
                color = color1;
            end
            stw(y, x) =  color* ones(length(y),length(x));
            contrast = 255*intensity_diff;
            image(uint8(255*stw), 'cdata', uint8(255*stw), 'parent', axes_1, 'ButtonDownFcn', @(a,b)get_user_pointer_position(a,b, x, y)); 
            grid(axes_1, 'off'); axis(axes_1, 'off');
            colormap( axes_1,  gray(256));
            DisplayAxesTitle( axes_1, ['Contrast = ',  num2str(contrast, '%0.0f'), ', Size = ', num2str(stim_size) ', Background = ', num2str(255*background) ], 'TM');
        end
end