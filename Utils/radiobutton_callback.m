%% --- Executes on change in buttongroup.
function radiobutton_callback(radiohandle, eventdata, handles)
    handles  =guidata(handles.figure1);
    curr_field_names = fieldnames(handles.(handles.current_experiment_name));
    for i=1:length(curr_field_names)
        isgraphics1 = strfind(curr_field_names{i}, 'axes_' );
        isgraphics2 = strfind(curr_field_names{i}, 'buttongroup_handle' );
        isgraphics3 = strfind(curr_field_names{i}, 'uicontrol_' );
        if ( (~isempty(isgraphics1) && (1 == isgraphics1))  || ...
             (~isempty(isgraphics2) && (1 == isgraphics2))  || ...
             (~isempty(isgraphics3) && (1 == isgraphics3)) )
            delete( handles.(handles.current_experiment_name).(curr_field_names{i}) );
        else
            handles.(handles.current_experiment_name) = rmfield(handles.(handles.current_experiment_name), curr_field_names{i});
        end
    end
    if ( ~sum(strcmpi(get(radiohandle, 'type'), {'uipanel','uibuttongroup'})) && strcmpi(get(radiohandle, 'style'), 'text'))
        curr_expr = get(radiohandle,'string');
        set(handles.buttongroup, 'SelectedObject', findobj('tag',curr_expr));
    else
        curr_expr = get(eventdata.NewValue, 'string');
        if ( isempty (curr_expr) )
            curr_expr =  get(eventdata.NewValue, 'tag');
        end
    end
    curr_expr(curr_expr==' ')= '_';
    curr_expr(curr_expr==',')= '';
    curr_expr(curr_expr=='&')= '_';
    curr_expr(curr_expr==':')= '';
    curr_expr(curr_expr=='-')= [];
    curr_default = handles.defaults.(curr_expr).im_1;
    if ( strcmpi(curr_default.type,  'signal') )
        handles.signal_index = curr_default;
    else
        handles.image_index = curr_default;
    end
    if ( isfield(handles.defaults.(curr_expr), 'im_2'))
        curr_default = handles.defaults.(curr_expr).im_2;
        if ( strcmpi(curr_default.type,  'signal') )
            handles.signal_index2 = curr_default;
        else
            handles.image_index2 = curr_default;
        end
    end
    if ( isfield(handles.defaults.(curr_expr), 'im_3'))
        curr_default = handles.defaults.(curr_expr).im_3;
        if ( strcmpi(curr_default.type,  'signal') )
            handles.signal_index3 = curr_default;
        else
            handles.image_index3 = curr_default;
        end
    end
    guidata(handles.figure1, handles);
    handles.(handles.current_experiment_name) = RunTopic ( handles);
    guidata(handles.figure1, handles);
end