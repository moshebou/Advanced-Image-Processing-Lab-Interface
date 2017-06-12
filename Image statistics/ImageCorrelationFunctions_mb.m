function ImageCorrelationFunctions = ImageCorrelationFunctions_mb( handles )
% Task
% Observe and explain discretization aliasing effects on sinusoidal signals of different
% frequency.
% Instruction
%
	handles = guidata(handles.figure1);
	axes_pos = {[2,2]};
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	ImageCorrelationFunctions = DeployAxes( handles.figure1, ...
										axes_pos, ...
										bottom, ...
										left, ...
										0.9, ...
										0.9);
	ImageCorrelationFunctions.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 
	process_image(ImageCorrelationFunctions.im , ...
	ImageCorrelationFunctions.axes_1, ImageCorrelationFunctions.axes_2, ...
	ImageCorrelationFunctions.axes_3, ImageCorrelationFunctions.axes_4);
end


function process_image(im, axes_1, axes_2, axes_3, axes_4)

    imshow(im, [0 255], 'parent', axes_1);
    DisplayAxesTitle( axes_1,  ['Test image'], 'TM');  
    corr_x=corimg1d_mb(im);
    corr_y=corimg1d_mb(im');
    corr_xy=corimg2d_mb(im);
    
    imshow(corr_xy, [],  'parent', axes_2);
    DisplayAxesTitle( axes_2, '2D autocorrelation function', 'TM'); 
    
    plot([-floor(length(corr_x)/2):floor(length(corr_x)/2)-1],corr_x/max(corr_x(:)),  'parent', axes_3, 'Linewidth', 2);
    grid(axes_3, 'on');
    DisplayAxesTitle( axes_3, 'X-cross section of 2D autocorrelation function', 'TM');  
    
        
    plot([-floor(length(corr_y)/2):floor(length(corr_y)/2)-1],corr_y/max(corr_y(:)),  'parent', axes_4, 'Linewidth', 2);
    grid(axes_4, 'on');
    DisplayAxesTitle( axes_4, 'Y-cross section of 2D autocorrelation function', 'TM'); 

end