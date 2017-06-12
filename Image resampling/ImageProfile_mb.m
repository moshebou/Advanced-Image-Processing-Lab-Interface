function ImageProfile = ImageProfile_mb( handles )
% 7.2. Image zoom
% 7.2.1. Compare image fragment zooming with zero-order, bilinear, and cubic (program resize.m) and
% discrete sinc- interpolation (program interp2d.m) methods. Compare and analyze Fourier spectra of
% zoomed images
% 7.2.2Test local image zoom using program loczoom.m. Observe and explain artifacts due to the boundary
% effects. Optional: suggest and implement a method to reduce them.


% Lab. 7 - Image Resampling and Geometrical Transforms
% Study of signal and image interpolation techniques and their applications to image
% geometrical transforms.
% 7.1. Nearest neighbour, linear, spline and discrete sinc-interpolation methods
% 7.1.1. Form test signals (delta-impulse, rectangular impulse and "Mexican hat impulse") and zoom them in
% using nearest neighbor, bilinear, bicubic interpolation (program resize.m). discrete sinc-interpolation
% (programs sincint.m, sincint0.m, sincint1.m). Observe, compare interpolated signals and their spectra.
% Explain Gibbs's effects in discrtete sinc-interpolation. Explain difference between programs sincint.m,
% sincint0.m, sincint1.m.
% 7.1.2. Repeat the same for an image raw and an ECG signal (signals ecg1.mat, ecg256.mat can be used as
% test signals).

% 7.2. Image zoom
% 7.2.1. Compare image fragment zooming with zero-order, bilinear, and cubic (program resize.m) and
% discrete sinc- interpolation (program interp2d.m) methods. Compare and analyze Fourier spectra of
% zoomed images
% 7.2.2Test local image zoom using program loczoom.m. Observe and explain artefacts due to the boundary
% effects. Optional: suggest and implement a method to reduce them.

% 7.3. Image rotation

% 7.3.1Form a test image: a square inscribed into an empty frame of 256x256 pixels. Rotate the test image
% observe and explain aliasing effects in the process of successive rotations through angle 360°/n, n=3,4.
% Make the same experiment with images from the test set.

% 7.3.2. Test image rotation by the 3-pass algorithm and sinc-interpolation (program myrotate.m). Perform
% several successive rotations through angle 360°/n, n=3,4,…. Compute and display error between the initial
% image and that rotated successively through 360° and Fourier spectra of rotation errors.

% 7.4. Image geometric transformations with the use of a “continuous” image model

% 7.4.1. Select a test image and plot image profile along an arbitrary direction with program profile.m using
% different interpolation degree. Observe interpolation effects.

% 7.4.2. Perform image local zoom using program loc_zoom.m. Compare the result with the above results
% obtained with program loczoom.m. Perform image rotation with program rotate_s.m. Compare results
% with the above results obtained with program myrotate.m

% 7.4.3. Image transformation from Cartesian to polar coordinate system with program cart_pol.m.
% 7.4.4. Write a program for arbitrary image mapping from one coordinate system to another through
% “continuous image model” (use image zooming programs)

   handles = guidata(handles.figure1);


   axes_pos = {[1,1],[4,1]};
   button_pos = get(handles.pushbutton12, 'position');
   bottom =button_pos(2);
   left = button_pos(1)+button_pos(3);
        ImageProfile = DeployAxes( handles.figure1, ...
            axes_pos, ...
            bottom, ...
            left, ...
            0.8, ...
            0.9);
      
 % variables initialization    
    ImageProfile.num_of_points = 1024;
    ImageProfile.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
  
	k=1;
	interface_params(k).style = 'pushbutton';
% 	interface_params(k).title = 'Run Experiment';
    interface_params(k).title = 'Select profile left and right ends';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
  	interface_params =  SetSliderParams('Set a number of profile samples', 4096, 256, ImageProfile.num_of_points, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'num_of_points',@update_sliders), interface_params, k);

    
    
    
    
    
    
    
    
    
    ImageProfile.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
                 
    
    % Display initial input image
    axes_im = image(ImageProfile.im,'cdata', ImageProfile.im,  'parent', ImageProfile.axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y));
    grid(ImageProfile.axes_1, 'off'); colormap(gray(256));axis (ImageProfile.axes_1,'off', 'image');
    DisplayAxesTitle( ImageProfile.axes_1,'Test image',   'TM');
    
     % Set Axes_1 pointer appearance
    pointerBehavior.enterFcn = @(a,b)ChangePointerAppearanceToCross(a,b, handles);
    pointerBehavior.exitFcn = @(a,b)ChangePointerAppearanceToArrow(a,b, handles);
    pointerBehavior.traverseFcn =[];%@(a,b)CalcLocalHistogram(a,b, handles);
    iptSetPointerBehavior(axes_im, pointerBehavior);          



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
if ( isfield(handles.(handles.current_experiment_name), 'h_line') && ~isempty(handles.(handles.current_experiment_name).h_line))
    delete(handles.(handles.current_experiment_name).h_line);
    handles.(handles.current_experiment_name) = rmfield(handles.(handles.current_experiment_name), 'h_line');
end

if ( isfield(handles.(handles.current_experiment_name), 'h_marker2') && ~isempty(handles.(handles.current_experiment_name).h_marker2))
    delete(handles.(handles.current_experiment_name).h_marker2);
    handles.(handles.current_experiment_name) = rmfield(handles.(handles.current_experiment_name),'h_marker2');
end
if ( ~isfield(handles.(handles.current_experiment_name), 'x_left') ||isempty(handles.(handles.current_experiment_name).x_left))
    if ( isfield(handles.(handles.current_experiment_name), 'h_marker1') && ~isempty(handles.(handles.current_experiment_name).h_marker1))
        delete(handles.(handles.current_experiment_name).h_marker1);
        handles.(handles.current_experiment_name) = rmfield(handles.(handles.current_experiment_name),'h_marker1');
    end
    handles.(handles.current_experiment_name).x1 = pointer_pos(1,1);
    handles.(handles.current_experiment_name).y1 = pointer_pos(1,2);
    handles.(handles.current_experiment_name).x_left = handles.(handles.current_experiment_name).x1;
    handles.(handles.current_experiment_name).y_top = handles.(handles.current_experiment_name).y1;
    hold(handles.(handles.current_experiment_name).axes_1, 'on');
    handles.(handles.current_experiment_name).h_marker1 = plot( handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).x1, handles.(handles.current_experiment_name).y1, 'rx');
elseif ( ~isfield(handles.(handles.current_experiment_name), 'x_right') ||isempty(handles.(handles.current_experiment_name).x_right))
    handles.(handles.current_experiment_name).x2 = pointer_pos(1,1);
    handles.(handles.current_experiment_name).y2 = pointer_pos(1,2);
    handles.(handles.current_experiment_name).x_right = handles.(handles.current_experiment_name).x2;
    handles.(handles.current_experiment_name).y_bottom = handles.(handles.current_experiment_name).y2;
    handles.(handles.current_experiment_name).h_marker2 = plot( handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).x2, handles.(handles.current_experiment_name).y2, 'ro');

    handles.(handles.current_experiment_name).h_line = line([handles.(handles.current_experiment_name).x1, handles.(handles.current_experiment_name).x2 ], ...
    [handles.(handles.current_experiment_name).y1, handles.(handles.current_experiment_name).y2], 'color','r' , 'parent', axes_handles);
    ImageProfile = handles.(handles.current_experiment_name);
    process_image(ImageProfile.im, ImageProfile.x_left, ImageProfile.y_top, ImageProfile.x_right, ImageProfile.y_bottom, ImageProfile.num_of_points, ...
    ImageProfile.axes_1,  ImageProfile.axes_2, ImageProfile.axes_3, ImageProfile.axes_4, ImageProfile.axes_5)
    handles.(handles.current_experiment_name).x1 = [];
    handles.(handles.current_experiment_name).y1 = [];
    handles.(handles.current_experiment_name).x_left = [];
    handles.(handles.current_experiment_name).y_top = [];
    handles.(handles.current_experiment_name).x2 = [];
    handles.(handles.current_experiment_name).y2 = [];
    handles.(handles.current_experiment_name).x_right = [];
    handles.(handles.current_experiment_name).y_bottom = [];
else
    handles.(handles.current_experiment_name).x1 = handles.(handles.current_experiment_name).x2;
    handles.(handles.current_experiment_name).y1 = handles.(handles.current_experiment_name).y2;
    handles.(handles.current_experiment_name).x2 = pointer_pos(1,1);
    handles.(handles.current_experiment_name).y2 = pointer_pos(1,2);
    handles.(handles.current_experiment_name).x_left = handles.(handles.current_experiment_name).x1;
    handles.(handles.current_experiment_name).y_top = handles.(handles.current_experiment_name).y1;    
    handles.(handles.current_experiment_name).x_right = handles.(handles.current_experiment_name).x2;
    handles.(handles.current_experiment_name).y_bottom = handles.(handles.current_experiment_name).y2;
    handles.(handles.current_experiment_name).h_line = line([handles.(handles.current_experiment_name).x1, handles.(handles.current_experiment_name).x2 ], ...
    [handles.(handles.current_experiment_name).y1, handles.(handles.current_experiment_name).y2], 'parent', axes_handles);
    ImageProfile = handles.(handles.current_experiment_name);
    process_image(ImageProfile.im, ImageProfile.x_left, ImageProfile.y_top, ImageProfile.x_right, ImageProfile.y_bottom, ImageProfile.num_of_points, ...
    ImageProfile.axes_1,  ImageProfile.axes_2, ImageProfile.axes_3, ImageProfile.axes_4, ImageProfile.axes_5);
end



guidata(figure_handle,handles);

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



ImageProfile = handles.(handles.current_experiment_name);
if ( isfield(handles.(handles.current_experiment_name), 'x_right') &&~isempty(handles.(handles.current_experiment_name).x_right))
     process_image(ImageProfile.im, ImageProfile.x_left, ImageProfile.y_top, ImageProfile.x_right, ImageProfile.y_bottom, ImageProfile.num_of_points, ...
     ImageProfile.axes_1,  ImageProfile.axes_2, ImageProfile.axes_3, ImageProfile.axes_4, ImageProfile.axes_5);
end
end

function process_image(im, x_left, y_top, x_right, y_bottom, num_of_points,  axes_1,  axes_2, axes_3, axes_4, axes_5)
    X = linspace(floor(x_left), ceil(x_right), num_of_points);
    Y = linspace(floor(y_top), ceil(y_bottom), num_of_points);
    z_nearest = interp2(1:size(im,2), 1:size(im,1), im, X, Y, 'nearest');
    plot(z_nearest, 'parent', axes_2, 'linewidth', 2); axis(axes_2,'tight')
    grid(axes_2, 'on');
    set(axes_2, 'XTickLabel', []);
    axis(axes_2, 'tight');
    title( axes_2, 'Nearest Neighbor','fontweight', 'bold');
    
    z_linear = interp2(1:size(im,2), 1:size(im,1), im, X, Y, 'linear');
    plot(z_linear, 'parent', axes_3, 'linewidth', 2);
    grid(axes_3, 'on');
    set(axes_3, 'XTickLabel', []);
    axis(axes_3, 'tight');
    title( axes_3, 'Bilinear','fontweight', 'bold');
    
    z_spline  = interp2(1:size(im,2), 1:size(im,1), im, X, Y, 'spline');
    plot(z_spline, 'parent', axes_4, 'linewidth', 2);
    axis(axes_4, 'tight');
    grid(axes_4, 'on'); 
    set(axes_4, 'XTickLabel', []);
    title( axes_4, 'Cubic spline','fontweight', 'bold');
    
    min_x = floor(min(x_left, x_right));
    max_x = ceil(max(x_left, x_right));
    min_y = floor(min(y_top, y_bottom));
    max_y = ceil(max(y_top, y_bottom));    
    Lx = ceil(num_of_points/length(min_x:max_x));
    Ly = ceil(num_of_points/length(min_y:max_y));
    
    interp_im= interp2d_mb(im(min_y:max_y, min_x:max_x), Ly, Lx);
    min_length = min(size(interp_im,1), size(interp_im,2));
    if (y_top <= y_bottom) && (x_left<= x_right)
        z_sinc = interp_im(sub2ind(size(interp_im), round(linspace(1,size(interp_im,1), min_length)),round(linspace(1,size(interp_im,2), min_length))));
    elseif (y_top > y_bottom) && (x_left<= x_right)
        z_sinc = interp_im(sub2ind(size(interp_im), round(linspace(size(interp_im,1), 1, min_length)),round(linspace(1,size(interp_im,2), min_length))));
    elseif (y_top <= y_bottom) && (x_left> x_right)
        z_sinc = interp_im(sub2ind(size(interp_im), round(linspace(1,size(interp_im,1), min_length)),round(linspace(size(interp_im,2), 1, min_length))));
    elseif (y_top > y_bottom) && (x_left> x_right)
        z_sinc = interp_im(sub2ind(size(interp_im), round(linspace(size(interp_im,1), 1, min_length)),round(linspace(size(interp_im,2), 1, min_length))));
    end
    plot(z_sinc, 'parent', axes_5, 'linewidth', 2);
    grid(axes_5, 'on');
    axis(axes_5, 'tight');
    set(axes_5, 'XTickLabel', []);
    title( axes_5, 'Discrete sinc','fontweight', 'bold');
end

