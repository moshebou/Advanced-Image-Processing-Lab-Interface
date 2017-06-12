function LocalMeanMedianAndOrderStatistics = LocalMeanMedianAndOrderStatistics_mb( handles)
	handles = guidata(handles.figure1);
	axes_hor = 2;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	LocalMeanMedianAndOrderStatistics = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);
	% initialization
	LocalMeanMedianAndOrderStatistics.WndSzX = 5;
	LocalMeanMedianAndOrderStatistics.WndSzY = 5;
	LocalMeanMedianAndOrderStatistics.ros = 5;

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
	interface_params =  SetSliderParams('Set Window Width', 17, 1, LocalMeanMedianAndOrderStatistics.WndSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSzX',@update_sliders), interface_params, k);

	k=k+1;
	%
	interface_params =  SetSliderParams('Set Window Height', 17, 1, LocalMeanMedianAndOrderStatistics.WndSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSzY',@update_sliders), interface_params, k);

	k=k+1;
	% should be smaller then WndSzY*WndSzX.
	interface_params =  SetSliderParams('Set Rank Order Statistics (%)', 100, 1, LocalMeanMedianAndOrderStatistics.ros, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'ros',@update_sliders), interface_params, k);
	 


	LocalMeanMedianAndOrderStatistics.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		        

	LocalMeanMedianAndOrderStatistics.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
	guidata(handles.figure1, handles);

	process_image( LocalMeanMedianAndOrderStatistics.im, ...
	LocalMeanMedianAndOrderStatistics.WndSzX, ...
	LocalMeanMedianAndOrderStatistics.WndSzY, ...
	LocalMeanMedianAndOrderStatistics.ros, ...
	LocalMeanMedianAndOrderStatistics.axes_1, ...
	LocalMeanMedianAndOrderStatistics.axes_2, ...
	LocalMeanMedianAndOrderStatistics.axes_3, ...
	LocalMeanMedianAndOrderStatistics.axes_4);
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



        process_image( handles.(handles.current_experiment_name).im, ...
            handles.(handles.current_experiment_name).WndSzX, ...
            handles.(handles.current_experiment_name).WndSzY, ...
            handles.(handles.current_experiment_name).ros, ...
            handles.(handles.current_experiment_name).axes_1, ...
            handles.(handles.current_experiment_name).axes_2, ...
            handles.(handles.current_experiment_name).axes_3, ...
            handles.(handles.current_experiment_name).axes_4);
 end
function process_image( im, WndSzX, WndSzY, ros, axes_1, axes_2, axes_3, axes_4)
    h = waitbar(0, 'please wait');
    
    imshow( im, [0 255], 'parent', axes_1);
    DisplayAxesTitle( axes_1, [ 'Test image'], 'TM');  
    waitbar(1/5,h);
    
    img_ext = img_ext_mb(im, (WndSzX-1)/2,(WndSzY-1)/2) ;
    im_col = im2col(img_ext, [ WndSzY, WndSzX], 'sliding');
    waitbar(2/5,h);
    
    imshow(reshape(mean(im_col, 1), size(im,1), size(im,2)), [0 255], 'parent', axes_2);
    DisplayAxesTitle( axes_2, [ 'Local mean image'], 'TM');
    waitbar(3/5,h);
    
    im_col_sort = sort(im_col, 1);
    imshow(reshape( im_col_sort(max(1,floor(size(im_col_sort,1)/2)), :),  size(im,1), size(im,2)), [0 255], 'parent', axes_3);
    DisplayAxesTitle( axes_3, [ 'Local median image'], 'BM');  
    waitbar(4/5,h);
    
    imshow(reshape( im_col_sort(round( max(1, min(size(im_col_sort,1), ros*size(im_col_sort,1)/100))), :),   size(im,1), size(im,2)), [0 255], 'parent', axes_4);
    DisplayAxesTitle( axes_4, [ 'Local rank-order statistics image'], 'BM');  
    waitbar(1,h);
    close ( h);
end

% function im = calc_local_mean ( im, WndSzX, WndSzY)
%     im = imfilter(im, ones(WndSzY,WndSzX)/(WndSzY*WndSzX), 'symmetric');
% end
% 
% function im = calc_local_med( im, WndSzX, WndSzY)
%     im = medfilt2(img_ext_mb(im,WndSzX, WndSzY) , [WndSzY, WndSzX]);
%     im = im(WndSzY+1:end- WndSzY, WndSzX+1:end-WndSzX);
% end
% 
% function im = calc_local_ros( im, WndSzX, WndSzY, ROS)
%     im  = lcros_mb(im,WndSzY,WndSzX,ROS);
% end
