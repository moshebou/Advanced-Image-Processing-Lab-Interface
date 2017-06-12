%% Signals Zoom
%% Instruction:
%% Tasks:
% 7.3. Image rotation
%
% 7.3.1
% Form a test image: a square inscribed into an empty frame of 256x256 pixels. Rotate the test image
% observe and explain aliasing effects in the process of successive rotations through angle 360°/n, n=3,4.
% Make the same experiment with images from the test set.
%
% 7.3.2. 
% Test image rotation by the 3-pass algorithm and sinc-interpolation (program myrotate.m). Perform
% several successive rotations through angle 360°/n, n=3,4,…. Compute and display error between the initial
% image and that rotated successively through 360° and Fourier spectra of rotation errors.
%% Theoretical Background:
%% Algorithm:
%% 

function ImageRotation = ImageRotation_mb( handles )
   handles = guidata(handles.figure1);
   axes_hor = 3;
   axes_ver = 2;
   button_pos = get(handles.pushbutton12, 'position');
   bottom =button_pos(2);
   left = button_pos(1)+button_pos(3);
        ImageRotation = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);
    % variables initialization    
    ImageRotation.rotation_degree = 18;
    ImageRotation.rotation_360_degree = 1;
    %    
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
% 	interface_params =  SetSliderParams('Set Rotation Angle', 90, 0, ImageRotation.rotation_degree, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'rotation_degree',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set Rotation Angle', 90, 18, ImageRotation.rotation_degree, 18, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'rotation_degree',@update_sliders), interface_params, k);
    k = k+1;
	interface_params =  SetSliderParams('Set number of 360 degrees rotation', 5, 1, ImageRotation.rotation_360_degree, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'rotation_360_degree',@update_sliders), interface_params, k);

    
    
    
    
    
    
    
    
    
    ImageRotation.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
               

    ImageRotation.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 
    imshow(ImageRotation.im, [], 'parent', ImageRotation.axes_1);
    DisplayAxesTitle( ImageRotation.axes_1, 'Test image', 'TM');
%     process_image(ImageRotation.im, ImageRotation.rotation_degree, ImageRotation.rotation_360_degree, ...
%     ImageRotation.axes_1, ImageRotation.axes_2, ImageRotation.axes_3, ImageRotation.axes_4);
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


    ImageRotation = handles.(handles.current_experiment_name);
    process_image(ImageRotation.im, ImageRotation.rotation_degree, ImageRotation.rotation_360_degree,...
    ImageRotation.axes_1, ImageRotation.axes_2, ImageRotation.axes_3, ImageRotation.axes_4, ImageRotation.axes_5, ImageRotation.axes_6);
end

function process_image(im, rotation_degree, rotation_360_degree, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
    im_rot_nn       = im;
    im_rot_bilinear = im;
    im_rot_bicubic  = im;
    im_rot_size = size(im_rot_nn);
    max_width_height = ceil(sqrt(2.1*size(im,1)*size(im,2)))+7;
    im_ext = zeros(max_width_height);
    im_ext(floor((size(im_ext,1) - size(im,1))/2) : floor((size(im_ext,1) + size(im,1))/2)-1 , floor((size(im_ext,1) - size(im,2))/2) : floor((size(im_ext,1) + size(im,2))/2)-1) = im;
    
    three_step_rotation=im_ext;
    
    if (rotation_360_degree ~= 0 )
        for i = 1 : rotation_360_degree
            for j=1:360/rotation_degree;
                im_rot_nn       = imrotate(im_rot_nn, rotation_degree, 'nearest');
                curr_max_h = min( size(im_rot_nn, 1), max_width_height);
                curr_max_w = min( size(im_rot_nn, 2), max_width_height);
                im_rot_nn = im_rot_nn(max(1,floor((size(im_rot_nn,1) -curr_max_h)/2)) :min(ceil((size(im_rot_nn,1) +curr_max_h)/2),size(im_rot_nn,1)) , max(1,floor((size(im_rot_nn,2) -curr_max_w)/2)) :min(ceil((size(im_rot_nn,2) +curr_max_w)/2),size(im_rot_nn,2)) );
                imshow(im_rot_nn, [0 255], 'parent', axes_2);
                DisplayAxesTitle( axes_2, 'Nearest-neighbor Interpolation', 'TM');
                drawnow

                im_rot_bilinear = imrotate(im_rot_bilinear,rotation_degree, 'bilinear');
                im_rot_bilinear = im_rot_bilinear(max(1,floor((size(im_rot_bilinear,1) -curr_max_h)/2)) :min(ceil((size(im_rot_bilinear,1) +curr_max_h)/2),size(im_rot_bilinear,1)) , max(1,floor((size(im_rot_bilinear,2) -curr_max_w)/2)) :min(ceil((size(im_rot_bilinear,2) +curr_max_w)/2),size(im_rot_bilinear,2)) );
                imshow(im_rot_bilinear, [0 255], 'parent', axes_3);
                DisplayAxesTitle( axes_3, 'Bilinear Interpolation', 'TM');
                drawnow

                im_rot_bicubic  = imrotate(im_rot_bicubic, rotation_degree, 'bicubic');
                im_rot_bicubic = im_rot_bicubic(max(1,floor((size(im_rot_bicubic,1) -curr_max_h)/2)) :min(ceil((size(im_rot_bicubic,1) +curr_max_h)/2),size(im_rot_bicubic,1)) , max(1,floor((size(im_rot_bicubic,2) -curr_max_w)/2)) :min(ceil((size(im_rot_bicubic,2) +curr_max_w)/2),size(im_rot_bicubic,2)) );
                imshow(im_rot_bicubic, [0 255], 'parent', axes_5);
                DisplayAxesTitle( axes_5, 'Bicubic Interpolation', 'BM');
                drawnow 
                
                three_step_rotation = myrotate_mb(three_step_rotation,-rotation_degree);
                imshow(three_step_rotation, [], 'parent', axes_6);
                DisplayAxesTitle( axes_6, '3-step image rotation', 'BM');
                drawnow
            end
        end
    end
    im_rot_nn = im_rot_nn(max(1,floor((size(im_rot_nn,1) -size(im,1))/2)) :min(ceil((size(im_rot_nn,1) +size(im,1))/2),size(im_rot_nn,1)) , max(1,floor((size(im_rot_nn,2) -size(im,2))/2)) :min(ceil((size(im_rot_nn,2) +size(im,2))/2),size(im_rot_nn,2)) );
    im_rot_bilinear = im_rot_bilinear(max(1,floor((size(im_rot_bilinear,1) -size(im,1))/2)) :min(ceil((size(im_rot_bilinear,1) +size(im,1))/2),size(im_rot_bilinear,1)) , max(1,floor((size(im_rot_bilinear,2) -size(im,2))/2)) :min(ceil((size(im_rot_bilinear,2) +size(im,2))/2),size(im_rot_bilinear,2)) );
    im_rot_bicubic = im_rot_bicubic(max(1,floor((size(im_rot_bicubic,1) -size(im,1))/2)) :min(ceil((size(im_rot_bicubic,1) +size(im,1))/2),size(im_rot_bicubic,1)) , max(1,floor((size(im_rot_bicubic,2) -size(im,2))/2)) :min(ceil((size(im_rot_bicubic,2) +size(im,2))/2),size(im_rot_bicubic,2)) );

    
%     im_rot_nn = imrotate(im_rot_nn, rotation_degree, 'nearest', 'crop');
    imshow(im_rot_nn, [], 'parent', axes_2);
    DisplayAxesTitle( axes_2, 'Nearest-neighbor Interpolation','TM');
    
%     im_rot_bilinear = imrotate(im_rot_bilinear, rotation_degree, 'bilinear', 'crop');
    imshow(im_rot_bilinear, [], 'parent', axes_3);
    DisplayAxesTitle( axes_3, 'Bilinear Interpolation','TM');

%     im_rot_bicubic = imrotate(im_rot_bicubic, rotation_degree, 'bicubic', 'crop');
    imshow(im_rot_bicubic, [], 'parent', axes_5);
    DisplayAxesTitle( axes_5, 'Bicubic Interpolation','BM');

    im_rot_size = size(im_rot_nn);
    three_step_rotation = three_step_rotation(floor((size(three_step_rotation,1) - im_rot_size(1))/2):floor((size(three_step_rotation,1) +im_rot_size(1))/2)-1, floor((size(three_step_rotation,2) - im_rot_size(2))/2):floor((size(three_step_rotation,2) +im_rot_size(2))/2)-1);
    imshow(three_step_rotation, [], 'parent', axes_6);
    DisplayAxesTitle( axes_6, '3-step image rotation', 'BM');

end
