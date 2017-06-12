function handles = RunExperiment( handles, image_discriptor )
%RunExperiment Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(handles.figure1);
    TopicList = handles.TopicList.([handles.current_experiment_name ]);

    try
        if ( nargin == 1) 
			bottom_left_buttongroup_pos = get(handles.pushbutton11, 'position');
			handles.buttongroup = SetTopicsRadioButtons( TopicList, ... 
                                                       @(a,b,c)radiobutton_callback(a,b, handles), ...
                                                       bottom_left_buttongroup_pos, ...
                                                       handles.figure1);
			handles.BACKpushbutton = uicontrol( ...
				'Style', 'pushbutton', ...
				'Units', 'normalized', ...
				'position', get(handles.pushbutton12, 'position'), ...
				'visible', 'on', ...
				'FontWeight',  'bold', ...     
				'fontsize', 12, ...                                                          
				'string', '<-- Back', ...
				'callback', @(a,b,c)pushbutton_back_callback(handles));
			guidata(handles.figure1, handles);
			handles = guidata(handles.figure1);
		else
			handles  =guidata(handles.figure1);
			curr_field_names = fieldnames(handles.(handles.current_experiment_name));
% 			for i=1:length(fields_name)
% 				 if ( strcmpi(class(handles.(handles.current_experiment_name).(fields_name{i})), 'double') && ...
% 							 (sum(size(handles.(handles.current_experiment_name).(fields_name{i})) -[1 1]) == 0) && ...
% 							 ishandle(handles.(handles.current_experiment_name).(fields_name{i})) &&  ...
% 							 (~strcmpi('root', get(handles.(handles.current_experiment_name).(fields_name{i}), 'Type'))))
% 						delete( handles.(handles.current_experiment_name).(fields_name{i}) );
% 
% 				 end
% 			 end
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

		end
		handles.(handles.current_experiment_name) = RunTopic ( handles);
		guidata(handles.figure1, handles);
        
    catch exception
        cd(handles.head_path);
        close all;
        rethrow(exception);
    end
end