%% Pointwise Transformation
%  Point-wise transformation (PWT-) models.
%% Experiment Description:
% 
%% Tasks: 
% 6.2.1. 
%
% * Write a program for generating binary images with a given probability of ones.
% * Generate an inhomogeneous pseudo-random field with local probability of ones controlled by
% an auxiliary image.
% * Generate an inhomogeneous pseudo-random field with local variance controlled by
% an auxiliary image.
%
%
%% Instruction:
% 
%% Theoretical Background: 
% 
%% Reference:
% * [1]
% <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/PatrnForm_Gromov.pdf,
% Leonid P. Yaroslavsky, "From pseudo-random numbers to stochastic growth
% models and texture images">


function Point_wiseTransformationModel = Point_wiseTransformationModel_mb( handles )
% 8.3 Image registration
% Write a program for alignment; using matched filtering, images arbitrarily displaced in both co-ordinates. Use for experiments video frames or stereo images.
    handles = guidata(handles.figure1);
    axes_hor = 2;
    axes_ver = 2;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
        Point_wiseTransformationModel = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);
    % initial params
    Point_wiseTransformationModel.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    Point_wiseTransformationModel.SzWx =5;
    Point_wiseTransformationModel.SzWy =5;
    Point_wiseTransformationModel.binary_thr = 127;
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;
    interface_params =  SetSliderParams('Set Window Width', 35, 1, Point_wiseTransformationModel.SzWx , 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzWx',@update_sliders), interface_params, k);
    k=k+1;    
    interface_params =  SetSliderParams('Set Window Height', 35, 1, Point_wiseTransformationModel.SzWy , 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzWy',@update_sliders), interface_params, k);
    k=k+1;    
    interface_params =  SetSliderParams('Set Binary Threshold', 255, 0, Point_wiseTransformationModel.binary_thr , 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'binary_thr',@update_sliders), interface_params, k);
    k=k+1;   
    
    
    
    
    
    
    
    
    
    Point_wiseTransformationModel.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
     
    process_image(Point_wiseTransformationModel.im,Point_wiseTransformationModel.SzWx, Point_wiseTransformationModel.SzWy, Point_wiseTransformationModel.binary_thr,...
    Point_wiseTransformationModel.axes_1, Point_wiseTransformationModel.axes_2, Point_wiseTransformationModel.axes_3, Point_wiseTransformationModel.axes_4);
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
    Point_wiseTransformationModel = handles.(handles.current_experiment_name);
    process_image(Point_wiseTransformationModel.im,Point_wiseTransformationModel.SzWx, Point_wiseTransformationModel.SzWy, Point_wiseTransformationModel.binary_thr,...
    Point_wiseTransformationModel.axes_1, Point_wiseTransformationModel.axes_2, Point_wiseTransformationModel.axes_3, Point_wiseTransformationModel.axes_4);
end

function process_image(im, SzWx, SzWy,bin_thr, axes_1, axes_2, axes_3, axes_4)
    delete(get(axes_1, 'children'));
    delete(get(axes_2, 'children'));
    delete(get(axes_3, 'children'));
    delete(get(axes_4, 'children'));
    imshow(im, [0 255],  'parent', axes_1); 
    DisplayAxesTitle( axes_1, ['Test image'], 'TM',10);  
    im_binary = im>bin_thr; % Introduce ineractive binarization threshold!
    imshow(im_binary, [0 1],  'parent', axes_2); 
    DisplayAxesTitle( axes_2, ['Binarized image'], 'TM',10);   
    im_local_mean = imfilter(im,ones(SzWy,SzWx)/(SzWy*SzWx));
    im_local_var = imfilter(im.^2 ,ones(SzWy,SzWx)/(SzWy*SzWx)) - im_local_mean.^2; 
    PWT_rand =(im_local_var.^0.5).* randn(size(im)) + im_local_mean;
    imshow(PWT_rand, [0 255],  'parent', axes_4); 
    DisplayAxesTitle(axes_4, {'Pseudo-random field with local mean','and variance of the test image'}, 'BM',10);   
    I= rand(size(im));
    PWT_prob = I<(im-min(im(:)))/(max(im(:))-min(im(:)));
    imshow(PWT_prob, [0 1],  'parent', axes_3); 
    DisplayAxesTitle( axes_3,{ 'Binary pseudo-random pattern local probability of ones','equal to normalized test image gray level'}, 'BM',10);   
end



