%% ImageZoom_mb Zoom
%  Nearest neighbor, linear, spline and discrete sinc-interpolation methods
%% Instruction:
% * Select a window fragment of the input image by left click anywere in
% the "Test Image" axes.
% * The Window size is controlled by the 'Set Window Size' slider.
% * The Zoom factor is controlled by the 'Set Zoom Factor' slider.
%% Tasks:
%
% 7.2.1. 
% 
% * Compare image fragment zooming with zero-order, bilinear, and cubic
% (program resize.m) and discrete sinc- interpolation (program interp2d.m)
% methods. 
% * Compare and analyze Fourier spectra of  zoomed images.
%
% 7.2.2
% 
% * Test local image zoom using program loczoom.m. 
% * Observe and explain artefacts due to the boundary effects. 
% * Optional: suggest and implement a method to reduce them.
%
%% Theoretical Background:
% Signal (or Image) digital zoom is the process of creating a signal which
% represents higher sampled version of the original signal.
%
% The method of constructing this new signal is called interpulation.
%
% Four different interpulation method are represented in this experiment:
%
% * Nearest neighbor interpulation
% * Bilinear interpulation
% * Cubic interpulation
% * Sinc interpulation
%
% 
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
function ImageZoom = ImageZoom_mb( handles )
% 7.2. Image zoom
% 7.2.1. Compare image fragment zooming with zero-order, bilinear, and cubic (program resize.m) and
% discrete sinc- interpolation (program interp2d.m) methods. Compare and analyze Fourier spectra of
% zoomed images
% 7.2.2Test local image zoom using program loczoom.m. Observe and explain artifacts due to the boundary
% effects. Optional: suggest and implement a method to reduce them.


   handles = guidata(handles.figure1);


   axes_hor = 3;
   axes_ver = 2;
   button_pos = get(handles.pushbutton12, 'position');
   bottom =button_pos(2);
   left = button_pos(1)+button_pos(3);
        ImageZoom = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);
      
 % variables initialization    
    ImageZoom.WndSz = 15;
    ImageZoom.ZoomFactor = 5;
    ImageZoom.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    
	k=1;
	interface_params(k).style = 'pushbutton';
% 	interface_params(k).title = 'Run Experiment';
    interface_params(k).title = 'Select a fragment for zoming';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
    interface_params =  SetSliderParams('Set Zoom Factor', 6, 1, ImageZoom.ZoomFactor, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'ZoomFactor',@update_sliders), interface_params, k);
    k = k+1;
	interface_params =  SetSliderParams('Set Window Size', 128, 1, ImageZoom.WndSz, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSz',@update_sliders), interface_params, k);
    

    
    
    
    
    
    
    
    
    
    ImageZoom.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
                 
    
    %% Display initial input image
    axes_im = image(ImageZoom.im,'cdata', ImageZoom.im,  'parent', ImageZoom.axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y));
    grid(ImageZoom.axes_1, 'off'); colormap(gray(256));axis image; axis (ImageZoom.axes_1,'off');
    DisplayAxesTitle( ImageZoom.axes_1,'Test Image',   'TM');
    
     %% Set Axes_1 pointer appearance
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
handles.(handles.current_experiment_name).x = round(pointer_pos(1,1));
handles.(handles.current_experiment_name).y = round(pointer_pos(1,2));
guidata(figure_handle,handles);
ImageZoom = handles.(handles.current_experiment_name);
process_image(ImageZoom.im, ImageZoom.x, ImageZoom.y, ImageZoom.WndSz, ImageZoom.ZoomFactor, ...
    ImageZoom.axes_1, ImageZoom.axes_2, ImageZoom.axes_3, ImageZoom.axes_4, ImageZoom.axes_5, ImageZoom.axes_6);
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



ImageZoom = handles.(handles.current_experiment_name);
process_image(ImageZoom.im, ImageZoom.x, ImageZoom.y, ImageZoom.WndSz, ImageZoom.ZoomFactor,...
    ImageZoom.axes_1, ImageZoom.axes_2, ImageZoom.axes_3, ImageZoom.axes_4, ImageZoom.axes_5, ImageZoom.axes_6);
end

function process_image(im, x, y, WndSz, ZoomFactor, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
    if ( ~isempty(x) && ~isempty(y))

        x_grid = max(1, x-floor(WndSz/2)):min(size(im,2),x+ceil(WndSz/2) -1);
        y_grid = max(1, y-floor(WndSz/2)):min(size(im,1),y+ceil(WndSz/2) -1);
        image(im,'cdata', im,  'parent', axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y));
        grid(axes_1, 'off'); colormap(gray(256));axis(axes_1,  'image'); axis (axes_1,'off');
        DisplayAxesTitle( axes_1,'Test image','TM');
        rectangle('parent', axes_1, 'Position', [x_grid(1), y_grid(1), (x_grid(end)-x_grid(1)), (y_grid(end) - y_grid(1))]) ;
        im_seg = im(y_grid,x_grid);
        [X, Y] = meshgrid(linspace(max(1, x-floor(WndSz/2)), min(size(im,2),x+ceil(WndSz/2) -1), WndSz*ZoomFactor), linspace(max(1, y-floor(WndSz/2)), min(size(im,1),y+ceil(WndSz/2) -1), WndSz*ZoomFactor));
        h = waitbar(0, 'please wait');
        im_nn = interp2(im,X,Y, 'nearest');
        waitbar(1/4,h);
        im_lin = interp2(im, X,Y, 'linear');
        waitbar(2/4,h);
        im_cub = interp2(im, X, Y, 'cubic');
        waitbar(3/4,h);
%         im_sinc = interp2d_mb(im_seg,ZoomFactor,ZoomFactor,1,0);
        im_sinc_ = interp2d_mb(im,ZoomFactor,ZoomFactor,0,0);
        waitbar(4/4,h);
        close(h);
        im_sinc=im_sinc_(ZoomFactor*min(y_grid):ZoomFactor*max(y_grid),ZoomFactor*min(x_grid):ZoomFactor*max(x_grid));
        

%         imshow(im_nn, [0 255], 'parent', axes_2);
        imshow(im_nn, [], 'parent', axes_2);
        DisplayAxesTitle( axes_2,'Nearest Neighbor Interpolation','TM');
%         imshow(im_lin, [0 255], 'parent', axes_3);
        imshow(im_lin, [], 'parent', axes_3);
        DisplayAxesTitle( axes_3,'Bilinear Interpolation','TM');
%         imshow(im_cub, [0 255], 'parent', axes_5);
        imshow(im_cub, [], 'parent', axes_5);
        DisplayAxesTitle( axes_5,'Bicubic Interpolation','BM');
%         imshow(im_sinc, [0 255], 'parent', axes_6);
        imshow(im_sinc, [], 'parent', axes_6);
        DisplayAxesTitle( axes_6,'Sinc Interpolation','BM');

    end
end
