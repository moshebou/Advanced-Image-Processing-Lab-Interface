function SetParam(slider_handles,y,k, topic_name, param_name, run_process_image, values_vector)
if ( nargin == 6)
    values_vector = [];
end
handles = guidata(slider_handles);
max_val = get(slider_handles, 'max');
min_val = get(slider_handles, 'min');
slider_step = get(slider_handles, 'sliderstep');
slider_val = get(slider_handles, 'value');
% deal with the case of not slider_step movement
slider_val = max(min_val, min(max_val, min_val + round((slider_val - min_val)/((max_val - min_val)*slider_step(1)))*((max_val - min_val)*slider_step(1))));
set(slider_handles, 'value', slider_val);
% make sure the the value should be integer, and if so, round it.
if ( sum(mod((max_val-min_val).*slider_step,1)))
    handles.(topic_name).(param_name) = get(slider_handles, 'value');
else
    handles.(topic_name).(param_name) = round(get(slider_handles, 'value'));
    set(slider_handles, 'value', handles.(topic_name).(param_name));
    if ( ~isempty(values_vector))
        handles.(topic_name).(param_name) = values_vector(handles.(topic_name).(param_name));
    end
end
guidata(slider_handles, handles);
slider_children = get(get(slider_handles, 'parent'), 'children');
value_handle = slider_children(strcmpi(get(slider_children,'tag'), ['Value' num2str(k)]));
if ( ~isempty(values_vector) )
    set(value_handle, 'string', num2str(values_vector(get(slider_handles, 'value'))));
else
    set(value_handle, 'string', num2str(get(slider_handles, 'value')));   
end
if ( isfield(handles,'waitbar_handle') && ~isempty(handles.waitbar_handle))
    waitfor(handles.waitbar_handle);
end

    run_process_image(handles);

end