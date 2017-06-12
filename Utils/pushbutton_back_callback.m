function pushbutton_back_callback( handles)
    handles  =guidata(handles.figure1);
    SliderOper('delete' );
    delete(handles.buttongroup );
    delete( handles.BACKpushbutton);
    curr_field_names = fieldnames(handles.(handles.current_experiment_name));
%     for i=1:length(curr_field_names)
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
%      if ( strcmpi(class(handles.(handles.current_experiment_name).(curr_field_names{i})), 'double') && ...
%                  (sum(size(handles.(handles.current_experiment_name).(curr_field_names{i})) -[1 1]) == 0) && ...
%                  ishandle(handles.(handles.current_experiment_name).(curr_field_names{i})) &&  ...
%                  (~strcmpi('root', get(handles.(handles.current_experiment_name).(curr_field_names{i}), 'Type'))))
%             delete( handles.(handles.current_experiment_name).(curr_field_names{i}) );
% 
%      end
%     end
    string = 'pushbutton';
    handles_fieldnames = fieldnames(handles);
    handles_fieldnames = handles_fieldnames(strncmp(string,handles_fieldnames,length(string)));
    for i=1:length(handles_fieldnames)
        set(handles.(handles_fieldnames{i}), 'visible', 'on');
        pointerBehavior.enterFcn = @(a,b)SetText(a,b,  i, handles.figure1, handles, handles.(handles_fieldnames{i}));
        pointerBehavior.exitFcn = @(a,b)RemoveText(a,b,  i, handles.figure1, handles);
        pointerBehavior.traverseFcn =[];
        iptSetPointerBehavior(handles.(handles_fieldnames{i}), pointerBehavior);
    end
    curr_fig_name = get(handles.figure1, 'Name');
    k = strfind(curr_fig_name, ':');
    if ( ~isempty(curr_fig_name))
        set(handles.figure1, 'Name', curr_fig_name(1:k-1));
    end
    handles = rmfield(handles, handles.current_experiment_name);
    handles.current_experiment_name = [];
    guidata(handles.figure1, handles);
    cd (handles.head_path);
    SetAdvancedImageProcessingLabText(handles );
end