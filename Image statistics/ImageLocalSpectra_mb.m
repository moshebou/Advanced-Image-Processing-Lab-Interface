function ImageLocalSpectra= ImageLocalSpectra_mb( handles )
%Task
%   Observe and compare local DFT and DCT image spectra for different images
	handles = guidata(handles.figure1);
	axes_hor = 3;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	ImageLocalSpectra = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);
	ImageLocalSpectra.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 
	axes_im = image(ImageLocalSpectra.im,'cdata', ImageLocalSpectra.im,  'parent', ImageLocalSpectra.axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y));
	grid off; colormap(gray(256));axis image; axis(ImageLocalSpectra.axes_1, 'off');
	DisplayAxesTitle( ImageLocalSpectra.axes_1, [ 'Full Image'], 'TM');

	% Set Axes_1 pointer appearance
	pointerBehavior.enterFcn = @(a,b)ChangePointerAppearanceToCross(a,b, handles);
	pointerBehavior.exitFcn = @(a,b)ChangePointerAppearanceToArrow(a,b, handles);
	pointerBehavior.traverseFcn =[];%@(a,b)CalcLocalHistogram(a,b, handles);
	iptSetPointerBehavior(axes_im, pointerBehavior);      


	%
	ImageLocalSpectra.WndSz =32;
    ImageLocalSpectra.y = 127;
    ImageLocalSpectra.x = 127;
	size = 2.^[0:8];
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
	interface_params =  SetSliderParams('Set Window Size', size, 2, log2(ImageLocalSpectra.WndSz)+1, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSz',@update_sliders, size), interface_params, k);


	%


	ImageLocalSpectra.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		     
    process_image(ImageLocalSpectra.im, ImageLocalSpectra.y, ImageLocalSpectra.x, ImageLocalSpectra.WndSz, ImageLocalSpectra.axes_1, ...
        ImageLocalSpectra.axes_2, ImageLocalSpectra.axes_3, ImageLocalSpectra.axes_4,ImageLocalSpectra.axes_5, ImageLocalSpectra.axes_6);
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
    axes_handles = get(image_handles, 'parent');
    handles = guidata(get(axes_handles, 'parent'));
    pointer_pos = get(axes_handles, 'CurrentPoint');
    handles.(handles.current_experiment_name).x = round(pointer_pos(1,1));
    handles.(handles.current_experiment_name).y = round(pointer_pos(1,2));
    guidata(get(axes_handles, 'parent'), handles);
    process_image(handles.(handles.current_experiment_name).im,  ...
        handles.(handles.current_experiment_name).y, handles.(handles.current_experiment_name).x,  ...
        handles.(handles.current_experiment_name).WndSz, handles.(handles.current_experiment_name).axes_1,  ...
        handles.(handles.current_experiment_name).axes_2, ...
        handles.(handles.current_experiment_name).axes_3, handles.(handles.current_experiment_name).axes_4, ...
        handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6);     
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


    if ( isfield(handles.(handles.current_experiment_name), 'x') && ...
            ~isempty(handles.(handles.current_experiment_name).x) && ...
            isfield(handles.(handles.current_experiment_name), 'y') && ...
            ~isempty(handles.(handles.current_experiment_name).y) )
        process_image(handles.(handles.current_experiment_name).im,  ...
            handles.(handles.current_experiment_name).y, handles.(handles.current_experiment_name).x,  ...
            handles.(handles.current_experiment_name).WndSz, handles.(handles.current_experiment_name).axes_1,  ...
            handles.(handles.current_experiment_name).axes_2, ...
            handles.(handles.current_experiment_name).axes_3, handles.(handles.current_experiment_name).axes_4, ...
            handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6);     
    end
end

function process_image (im, y, x,   WndSz, axes_1 , axes_2, axes_3, axes_4, axes_5, axes_6)

rect_handle = get(axes_1, 'children');
rect_handle = rect_handle(strcmpi(get(rect_handle, 'type'), 'rectangle'));
delete(rect_handle);
rectangle('Position', [max(1, x-WndSz/2), max(1, y-WndSz/2), WndSz, WndSz], 'parent', axes_1);

     [ frgm, fft_res, dct_res,  walsh_res, haar_res] = displcsp_mb(im,y, x,WndSz,WndSz);      
    imshow(frgm, [0 255], 'parent', axes_4);
    DisplayAxesTitle( axes_4, [ 'Selected Window'], 'BM');  
    show_spectrum(fft_res, axes_2);
    DisplayAxesTitle( axes_2, [ 'Selected Window Fourier Transform'], 'TM');  
    show_spectrum(dct_res, axes_3);
    DisplayAxesTitle( axes_3, [  'Selected Window DCT Transform'], 'TM');  
    show_spectrum(walsh_res, axes_5);
    DisplayAxesTitle( axes_5,  ['Selected Window Walsh Transform'], 'BM');  
    show_spectrum(haar_res, axes_6);
    DisplayAxesTitle( axes_6, [  'Selected Window Haar Transform'], 'BM');  
end