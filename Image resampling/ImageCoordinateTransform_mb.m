function ImageCoordinateTransform = ImageCoordinateTransform_mb( handles )
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
    ImageCoordinateTransform = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9);
      
 % variables initialization    
    ImageCoordinateTransform.Scale = 3;
    ImageCoordinateTransform.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    ImageCoordinateTransform.x_func = 'r.*cos(p)';
    ImageCoordinateTransform.y_func = 'r.*sin(p)';    
    ImageCoordinateTransform.r_min = '1';
    ImageCoordinateTransform.r_max = num2str(sqrt((size(ImageCoordinateTransform.im,2)/2)^2+(size(ImageCoordinateTransform.im,1)/2)^2));
    ImageCoordinateTransform.p_min = '-pi';
    ImageCoordinateTransform.p_max = 'pi'; 
    ImageCoordinateTransform.X0 = size(ImageCoordinateTransform.im,2)/2;
    ImageCoordinateTransform.Y0 = size(ImageCoordinateTransform.im,1)/2;
    %
    font_size = 15;
    button_units = get(handles.pushbutton1, 'units');
    set(handles.pushbutton1, 'units', 'points');
    button_pos1 = get(handles.pushbutton1, 'position');
    set(handles.pushbutton1, 'units', button_units);
    title_pos = button_pos1;
    title_pos = title_pos +[ 0, (title_pos(4)-font_size), 0, font_size - title_pos(4)];    
    ImageCoordinateTransform.uicontrol_h_title = uicontrol('style', 'text', 'units', 'points', 'position', title_pos, 'string', 'Set Image Coordinates Transformation');
    
    x_pos = title_pos + [ 0, -font_size, (3*font_size-title_pos(3)), 0];
    ImageCoordinateTransform.uicontrol_h_X = uicontrol('style', 'text', 'units', 'points', 'position', x_pos, 'string', 'X(r,p) = ');
    fx_pos = x_pos + [ x_pos(3), 0, (button_pos1(3) -2*x_pos(3)) , 0] ;
    ImageCoordinateTransform.uicontrol_h_X_edit = uicontrol('style', 'edit', 'units', 'points', 'position', fx_pos, 'string', ImageCoordinateTransform.x_func,  'callback', @(a,b)SetR(a,b, 'x_func'));
    
    y_pos = x_pos + [ 0, -font_size, 0, 0];
    ImageCoordinateTransform.uicontrol_h_Y = uicontrol('style', 'text', 'units', 'points', 'position', y_pos, 'string', 'Y(r,p) = ');
    fy_pos = y_pos + [ x_pos(3), 0, (button_pos1(3) -2*x_pos(3)) , 0] ;
    ImageCoordinateTransform.uicontrol_h_Y_edit = uicontrol('style', 'edit', 'units', 'points', 'position', fy_pos, 'string', ImageCoordinateTransform.y_func,  'callback', @(a,b)SetR(a,b, 'y_func'));
    % r
    min_r_pos = y_pos + [ 0, -font_size, (button_pos1(3)/4-y_pos(3)), 0];
    ImageCoordinateTransform.uicontrol_h_r_max = uicontrol('style', 'text', 'units', 'points', 'position', min_r_pos, 'string', 'min r = ');
    min_r_pos_edit = min_r_pos + [ min_r_pos(3), 0, 0 , 0] ;
    ImageCoordinateTransform.uicontrol_h_r_max_edit = uicontrol('style', 'edit', 'units', 'points', 'position', min_r_pos_edit, 'string', ImageCoordinateTransform.r_min, 'callback', @(a,b)SetR(a,b, 'r_min'));
 
    max_r_pos = min_r_pos_edit + [ min_r_pos_edit(3), 0, 0 , 0] ;
    ImageCoordinateTransform.uicontrol_h_r_min = uicontrol('style', 'text', 'units', 'points', 'position', max_r_pos, 'string', 'max r = ');
    min_r_pos_edit = max_r_pos + [ max_r_pos(3), 0, 0 , 0] ;
    ImageCoordinateTransform.uicontrol_h_r_min_edit = uicontrol('style', 'edit', 'units', 'points', 'position', min_r_pos_edit, 'string', ImageCoordinateTransform.r_max, 'callback', @(a,b)SetR(a,b, 'r_max'));
    % p
    min_p_pos = min_r_pos + [ 0, -font_size, 0, 0];
    ImageCoordinateTransform.uicontrol_h_p_min = uicontrol('style', 'text', 'units', 'points', 'position', min_p_pos, 'string', 'min p = ');
    min_p_pos_edit = min_p_pos + [ min_p_pos(3), 0, 0 , 0] ;
    ImageCoordinateTransform.uicontrol_h_p_min_edit = uicontrol('style', 'edit', 'units', 'points', 'position', min_p_pos_edit, 'string', ImageCoordinateTransform.p_min, 'callback', @(a,b)SetR(a,b, 'p_min'));
 
    max_p_pos = min_p_pos_edit + [ min_p_pos_edit(3), 0, 0 , 0] ;
    ImageCoordinateTransform.uicontrol_h_p_max = uicontrol('style', 'text', 'units', 'points', 'position', max_p_pos, 'string', 'max p = ');
    max_p_pos_edit = max_p_pos + [ max_p_pos(3), 0, 0 , 0] ;
    ImageCoordinateTransform.uicontrol_h_p_max_edit = uicontrol('style', 'edit', 'units', 'points', 'position', max_p_pos_edit, 'string', ImageCoordinateTransform.p_max, 'callback', @(a,b)SetR(a,b, 'p_max'));
       
    
    %% Display initial input image
    axes_im = image(ImageCoordinateTransform.im,'cdata', ImageCoordinateTransform.im,  'parent', ImageCoordinateTransform.axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y));
    grid(ImageCoordinateTransform.axes_1, 'off'); colormap(gray(256));axis image; axis (ImageCoordinateTransform.axes_1,'off');
    DisplayAxesTitle( ImageCoordinateTransform.axes_1,'Test image','TM');
    
     %% Set Axes_1 pointer appearance
    pointerBehavior.enterFcn = @(a,b)ChangePointerAppearanceToCross(a,b, handles);
    pointerBehavior.exitFcn = @(a,b)ChangePointerAppearanceToArrow(a,b, handles);
    pointerBehavior.traverseFcn =[];%@(a,b)CalcLocalHistogram(a,b, handles);
    iptSetPointerBehavior(axes_im, pointerBehavior);          


    process_image(ImageCoordinateTransform.im , ImageCoordinateTransform.x_func, ImageCoordinateTransform.y_func, ImageCoordinateTransform.X0, ImageCoordinateTransform.Y0, ...
        ImageCoordinateTransform.Scale, ImageCoordinateTransform.r_min, ImageCoordinateTransform.r_max, ...
        ImageCoordinateTransform.p_min, ImageCoordinateTransform.p_max, ImageCoordinateTransform.axes_1, ImageCoordinateTransform.axes_2,...
        ImageCoordinateTransform.axes_3,ImageCoordinateTransform.axes_4, ImageCoordinateTransform.axes_5, ImageCoordinateTransform.axes_6);
end

function SetR(a, b, type)
handles = guidata(a);

handles.(handles.current_experiment_name).(type) = get(a, 'string');
guidata(a, handles);
ImageCoordinateTransform = handles.(handles.current_experiment_name);
    process_image(ImageCoordinateTransform.im , ImageCoordinateTransform.x_func, ImageCoordinateTransform.y_func, ImageCoordinateTransform.X0, ImageCoordinateTransform.Y0, ...
        ImageCoordinateTransform.Scale, ImageCoordinateTransform.r_min, ImageCoordinateTransform.r_max, ...
        ImageCoordinateTransform.p_min, ImageCoordinateTransform.p_max, ImageCoordinateTransform.axes_1, ImageCoordinateTransform.axes_2,...
        ImageCoordinateTransform.axes_3,ImageCoordinateTransform.axes_4, ImageCoordinateTransform.axes_5, ImageCoordinateTransform.axes_6);


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
handles.(handles.current_experiment_name).X0 = round(pointer_pos(1,1));
handles.(handles.current_experiment_name).Y0 = round(pointer_pos(1,2));
guidata(figure_handle,handles);
ImageCoordinateTransform = handles.(handles.current_experiment_name);
    process_image(ImageCoordinateTransform.im , ImageCoordinateTransform.x_func, ImageCoordinateTransform.y_func, ImageCoordinateTransform.X0, ImageCoordinateTransform.Y0, ...
        ImageCoordinateTransform.Scale, ImageCoordinateTransform.r_min, ImageCoordinateTransform.r_max, ...
        ImageCoordinateTransform.p_min, ImageCoordinateTransform.p_max, ImageCoordinateTransform.axes_1, ImageCoordinateTransform.axes_2,...
        ImageCoordinateTransform.axes_3,ImageCoordinateTransform.axes_4, ImageCoordinateTransform.axes_5, ImageCoordinateTransform.axes_6);
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



ImageCoordinateTransform = handles.(handles.current_experiment_name);
    process_image(ImageCoordinateTransform.im , ImageCoordinateTransform.x_func, ImageCoordinateTransform.y_func, ImageCoordinateTransform.X0, ImageCoordinateTransform.Y0, ...
        ImageCoordinateTransform.Scale, ImageCoordinateTransform.r_min, ImageCoordinateTransform.r_max, ...
        ImageCoordinateTransform.p_min, ImageCoordinateTransform.p_max, ImageCoordinateTransform.axes_1, ImageCoordinateTransform.axes_2,...
        ImageCoordinateTransform.axes_3,ImageCoordinateTransform.axes_4, ImageCoordinateTransform.axes_5, ImageCoordinateTransform.axes_6);
end

function process_image(im, Xi, Yi, X0, Y0, L, min_r, max_r, min_p, max_p, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
    

    [r, p]= meshgrid(linspace(eval(min_r),eval(max_r), 256), linspace(eval(min_p), eval(max_p), 256));
    try
        [X, Y]  =meshgrid(1:size(im,2), 1:size(im,1));
        
        Xi = max(1, min(eval(Xi)+X0, size(im,2)));
        Yi = max(1, min(eval(Yi)+ Y0, size(im,1))) ;
        im_nearest = interp2(X, Y, im, Xi, Yi, 'nearest');
        imshow(uint8(im_nearest), 'parent', axes_2);
        DisplayAxesTitle( axes_2, 'Nearest neighbor interpolation',   'TM');        
        im_linear = interp2(X, Y, im, Xi, Yi, 'linear');
        imshow(uint8(im_linear), 'parent', axes_3);
        DisplayAxesTitle( axes_3, 'Bilinear interpolation',   'TM');     
        im_spline = interp2(X, Y, im, Xi, Yi, 'spline');
        imshow(uint8(im_spline), 'parent', axes_5);
        DisplayAxesTitle( axes_5, 'Cubic spline interpolation',   'BM');

        
        sinc_interp = interp2d_mb(im,L,L);
        sinc_interp = reshape(sinc_interp(sub2ind([256*L,256*L], min(max(1,round(L*Yi(:))),256*L),min(256*L, max(1,round(L*Xi(:)))))), 256,256);
        imshow(uint8(sinc_interp), 'parent', axes_6);
        DisplayAxesTitle( axes_6, 'Discrete sinc interpolation',   'BM');
    catch exp
        display(exp.message);
    end

end

% 
% function [x y] = find_significant_area( im )
%     im_x = sum(im);
%     x = find(0~= (im_x(1:floor(end/2)) +im_x(end:-1:ceil(end/2)+1)), 1 );
%     im_y = sum(im, 2);
%     y = find(0~= (im_y(1:floor(end/2)) +im_y(end:-1:ceil(end/2)+1)), 1 );
% end