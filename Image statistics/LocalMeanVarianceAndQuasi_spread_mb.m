function LocalMeanVarianceAndQuasi_spread = LocalMeanVarianceAndQuasi_spread_mb( handles)
    handles = guidata(handles.figure1);

    k=1;
    axes_hor = 2;
    axes_ver = 2;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    LocalMeanVarianceAndQuasi_spread = DeployAxes( handles.figure1, ...
        [axes_hor, ...
        axes_ver], ...
        bottom, ...
        left, ...
        0.9, ...
        0.9);    
    LocalMeanVarianceAndQuasi_spread.WndSzX = 5;
    LocalMeanVarianceAndQuasi_spread.WndSzY = 5;
    LocalMeanVarianceAndQuasi_spread.ros_l = 5;
    LocalMeanVarianceAndQuasi_spread.ros_r = 95;
	
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k = k +1;
    interface_params =  SetSliderParams('Set left rank (%)', 100, 0,  LocalMeanVarianceAndQuasi_spread.ros_l, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'ros_l',@update_sliders), interface_params, k);
    k = k +1;
    interface_params =  SetSliderParams('Set right rank (%)', 100, 1,  LocalMeanVarianceAndQuasi_spread.ros_r, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'ros_r',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set Window Width', 25, 1,  LocalMeanVarianceAndQuasi_spread.WndSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSzX',@update_sliders), interface_params, k);
    k = k +1;
    interface_params =  SetSliderParams('Set Window Height', 25, 1,  LocalMeanVarianceAndQuasi_spread.WndSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSzY',@update_sliders), interface_params, k);
    
    
    
    
    
    
    
    
    

    LocalMeanVarianceAndQuasi_spread.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
           
            
    LocalMeanVarianceAndQuasi_spread.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
     guidata(handles.figure1, handles);
    process_image( LocalMeanVarianceAndQuasi_spread.im, LocalMeanVarianceAndQuasi_spread.WndSzX, LocalMeanVarianceAndQuasi_spread.WndSzY, LocalMeanVarianceAndQuasi_spread.ros_l, LocalMeanVarianceAndQuasi_spread.ros_r, LocalMeanVarianceAndQuasi_spread.axes_1 ,LocalMeanVarianceAndQuasi_spread.axes_2, LocalMeanVarianceAndQuasi_spread.axes_3, LocalMeanVarianceAndQuasi_spread.axes_4);


end

function update_sliders(handles)
	if ( ~isstruct(handles))
		handles = guidata(handles);
    end
    val = min(handles.(handles.current_experiment_name).ros_r, handles.(handles.current_experiment_name).ros_l);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider2');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', handles.(handles.current_experiment_name).ros_r);
    set(slider_handle, 'sliderstep', [1, 1]/(handles.(handles.current_experiment_name).ros_r));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value2');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText2');
    set(slider_title_handle, 'string',  num2str(handles.(handles.current_experiment_name).ros_r));
    handles.(handles.current_experiment_name).ros_l = val;
	if ( strcmpi(handles.interactive, 'on'))
		run_process_image(handles);
	end
	guidata(handles.figure1,handles );
end

function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end



LocalMeanVarianceAndQuasi_spread = handles.(handles.current_experiment_name);
   process_image( LocalMeanVarianceAndQuasi_spread.im, LocalMeanVarianceAndQuasi_spread.WndSzX, LocalMeanVarianceAndQuasi_spread.WndSzY, LocalMeanVarianceAndQuasi_spread.ros_l, LocalMeanVarianceAndQuasi_spread.ros_r, LocalMeanVarianceAndQuasi_spread.axes_1 ,LocalMeanVarianceAndQuasi_spread.axes_2, LocalMeanVarianceAndQuasi_spread.axes_3, LocalMeanVarianceAndQuasi_spread.axes_4);

end

function process_image(im, WndSzX, WndSzY, ros_l, ros_r, axes_1, axes_2, axes_3, axes_4)
    h = waitbar(0, 'please wait');
    
    imshow( im, [], 'parent', axes_1);
    DisplayAxesTitle( axes_1, [ 'Test image'], 'TM',10);  
    waitbar(1/5,h);
    
    img_ext = img_ext_mb(im, (WndSzX-1)/2,(WndSzY-1)/2) ;
    im_col = im2col(img_ext, [ WndSzY, WndSzX], 'sliding');
    waitbar(2/5,h);
    
    im_mean = imfilter(im, ones(WndSzY,WndSzX)/(WndSzY*WndSzX), 'symmetric');
    im_var = sqrt(imfilter(double(im).^2, ones(WndSzY,WndSzX)/(WndSzY*WndSzX), 'symmetric') - im_mean.^2);
    imshow(reshape(mean(im_col, 1), size(im,1), size(im,2)), [], 'parent', axes_2);
    DisplayAxesTitle( axes_2, [ 'Image local mean '], 'TM',10);
    waitbar(3/5,h);

    imshow(reshape(var(im_col, 1), size(im,1), size(im,2)), [], 'parent', axes_3);
    DisplayAxesTitle( axes_3, [ 'Image local variance'], 'BM',10);
    waitbar(3/5,h);
    ros_r = max(1,round(WndSzY*WndSzX*ros_r/100));
    ros_l = max(1,round(WndSzY*WndSzX*ros_l/100));
    im_col_sort = sort(im_col, 1);
    imshow(reshape(im_col_sort(ros_r,:)-im_col_sort(ros_l,:), size(im,1), size(im,2)), [], 'parent', axes_4);
    DisplayAxesTitle( axes_4, [ 'Image quasi-spread: ROS\_R-ROS\_L'], 'BM',10);  
    waitbar(1,h);
    close ( h);
end

function im = calc_local_mean ( im, WndSz)
    im = imfilter(im, ones(WndSz,WndSz)/(WndSz^2), 'symmetric');
end

function im = calc_local_var( im, WndSz)
    im = imfilter(double(im).^2, ones(WndSz,WndSz)/(WndSz^2), 'symmetric') - imfilter(im, ones(WndSz,WndSz)/(WndSz^2), 'symmetric').^2;
end

function im = calc_local_ros( im, WndSz, ROS_l, ROS_R)
    im  = lcrosvar_mb(im,WndSz,WndSz,ROS_l, ROS_R);
end
