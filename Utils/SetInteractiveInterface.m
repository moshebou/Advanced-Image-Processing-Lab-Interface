function buttongroup_handle = SetInteractiveInterface(handles,children_params)
%%  
    handles = guidata(handles.figure1);
    k= length(children_params);
    button_units = get(handles.(['pushbutton' num2str(k)]), 'units');
    set(handles.(['pushbutton' num2str(k)]), 'units', 'normalized');
    position_norm = get(handles.(['pushbutton' num2str(k)]), 'position');
    set(handles.(['pushbutton' num2str(k)]), 'units', button_units);
    button_units = get(handles.pushbutton1, 'units');
    set(handles.pushbutton1, 'units', 'normalized');
    button_pos1 = get(handles.pushbutton1, 'position');
    set(handles.pushbutton1, 'units', button_units);
    position_norm(4) = abs(button_pos1(2)-position_norm(2))+position_norm(4); 
    parent = handles.figure1; 
    K = 0;
    font_size = 9;
    for i = 1: k
        switch lower(children_params(i).style)
            case 'buttongroup'
                if (  isfield(children_params(i), 'selection' ) && ~isempty(children_params(i).selection))
                    K = K+2+length(children_params(i).selection);
                elseif (  isfield(children_params(i), 'choose' ) && ~isempty(children_params(i).choose))
                    K = K+2+length(children_params(i).choose);
                end
            otherwise
                K = K+4;
        end
    end
    
    parent_height_points = get_handle_size(parent, 'points',  4 );
    height_old = position_norm(4);
    position_norm(4) =  1.25*K*font_size/parent_height_points;
    slider_height_only = 4*k/K;
    position_norm(2) = position_norm(2) - position_norm(4) + height_old;
    buttongroup_unitg = get(handles.buttongroup, 'units');
    set(handles.buttongroup, 'units', 'normalized');
    buttongroup_pos = get(handles.buttongroup, 'position');
    set(handles.buttongroup, 'units', buttongroup_unitg);
    
    position_norm(2) = max(position_norm(2), buttongroup_pos(2)+buttongroup_pos(4)+0.001);
    position_norm(4) =min(position_norm(4), abs(button_pos1(2)-position_norm(2))+button_pos1(4));
    buttongroup_handle = uibuttongroup('parent', parent, 'position', position_norm);

    if (nargin <2 ||  isempty(children_params ))
        return;
    end
            
    num_of_obj = length(children_params);   
    curr_height = 0;
    for i=1:num_of_obj
            
            switch lower(children_params(i).style)
                case 'slider'

                        if ( isfield(children_params,  'title')&&~isempty(children_params(i).title))
                            title_length = length(children_params(i).title);
                            buttongroup_units = get(buttongroup_handle, 'units');
                            set(buttongroup_handle, 'units', 'points');
                            buttongroup_position = get(buttongroup_handle, 'position');
                            set(buttongroup_handle, 'units', buttongroup_units);
                            font_size_title = min(floor(1.85*buttongroup_position(3)/ title_length), 8 );
                            uicontrol( 'parent', buttongroup_handle, ...
                               'units', 'normalized', ...
                                'style', 'text', ...
                                'string', children_params(i).title, ...
                                'position', [0 curr_height+(0.8*3*slider_height_only/(num_of_obj*4)) 1 1.4*slider_height_only/(num_of_obj*4)], ...
                                'HorizontalAlignment', 'center',...
                                'Tag', ['Title' num2str(i)], ...
                                'fontsize', font_size_title, ...
                                'FontWeight', 'bold');
                        end
                        if ( isfield(children_params,  'style')&&~isempty(children_params(i).style))
                            handle_ui = uicontrol('style',children_params(i).style,  'parent', buttongroup_handle, ...
                                'Tag', ['Slider' num2str(i)], ...
                                'units', 'normalized', ...
                                'position',  [0 curr_height+slider_height_only/(num_of_obj*4) 1 0.6*2*slider_height_only/(num_of_obj*4)], ...
                                'min', 0, 'max', 100, 'SliderStep', [1/101 1/101], 'value', 0);
                        end
                        if ( isfield(children_params,  'callback')&&~isempty(children_params(i).callback))
                            set(handle_ui, 'callback', children_params(i).callback);
                        end
                        if ( isfield(children_params,  'value')&&~isempty(children_params(i).value))
                            set(handle_ui, 'value', children_params(i).value);
                        end   
                        if ( isfield(children_params,  'min')&&~isempty(children_params(i).min))
                            set(handle_ui, 'min', children_params(i).min);
                        end
                        if ( isfield(children_params,  'max')&&~isempty(children_params(i).max))
                            set(handle_ui, 'max', children_params(i).max);
                        end
                        if ( isfield(children_params,  'sliderstep')&&~isempty(children_params(i).sliderstep))
                            set(handle_ui, 'sliderstep', children_params(i).sliderstep);
                        end

                        if ( isfield(children_params,  'left_text')&&~isempty(children_params(i).left_text))
                            uicontrol( 'parent', buttongroup_handle, ...
                                'style', 'text', ...
                                'units', 'normalized', ...
                                'string', children_params(i).left_text, ...
                                'position', [0 curr_height 0.3333 slider_height_only/(num_of_obj*4)], ...
                                'HorizontalAlignment', 'left',...
                                'Tag', ['LeftText' num2str(i)], ...
                                ...'fontsize', font_size, ...
                                'FontWeight', 'bold');
                        end    
                        if ( isfield(children_params,  'right_text')&&~isempty(children_params(i).right_text))

                            uicontrol( 'parent', buttongroup_handle, ...
                                'style', 'text', ...
                                'units', 'normalized', ...
                                'string', children_params(i).right_text, ...
                                'position', [0.6666667, curr_height, 0.3333, slider_height_only/(num_of_obj*4)], ...
                                'HorizontalAlignment', 'right',...
                                'Tag', ['RightText' num2str(i)], ...
                                ...'fontsize', font_size, ...
                                'FontWeight', 'bold');
                        end    
            %             if ( ~isempty(get(handle_ui,  'value'))
                        if ( isfield(children_params,  'value_text')&&~isempty(children_params(i).value_text))
                            uicontrol( 'parent', buttongroup_handle, ...
                                'style', 'text', ...
                                'units', 'normalized', ...
                                'string',  children_params(i).value_text, ...
                                'position', [0.3334, curr_height, 0.3333, slider_height_only/(num_of_obj*4)], ...
                                'HorizontalAlignment', 'center',...
                                'Tag', ['Value' num2str(i)], ...
                                ...'fontsize', font_size, ...
                                'FontWeight', 'bold');                            
                        else
                            uicontrol( 'parent', buttongroup_handle, ...
                                'style', 'text', ...
                                'units', 'normalized', ...
                                'string',  num2str(get(handle_ui,  'value')), ...
                                'position', [0.3334, curr_height, 0.3333, slider_height_only/(num_of_obj*4)], ...
                                'HorizontalAlignment', 'center',...
                                'Tag', ['Value' num2str(i)], ...
                                ...'fontsize', font_size, ...
                                'FontWeight', 'bold');
                        end
                        curr_height =   curr_height + slider_height_only/num_of_obj;
                case 'buttongroup'
                    if ( isfield(children_params(i), 'selection' ) && ~isempty(children_params(i).selection))
                        
                        ui_bg = uibuttongroup('parent', buttongroup_handle, 'units', 'normalized', ...
                            'position', [0, curr_height, 1, (length(children_params(i).selection)+2)/K], ...%length(children_params(i).selection)/(2*slider_height_only*num_of_obj)], ...
                            'title', children_params(i).title, 'FontWeight', 'bold', 'SelectionChangeFcn', children_params(i).callback);
                        for ui_index = 1:length(children_params(i).selection)
                            radio_button(ui_index) = uicontrol('Style','Radio','String',children_params(i).selection{ui_index}, 'units', 'normalized', ...
                            'position',[0 (ui_index-1)/length(children_params(i).selection) 1 1/length(children_params(i).selection)],'parent',ui_bg);
                        end
                        if( isfield(children_params(i), 'value') && ~isempty(children_params(i).value))
                            set(ui_bg, 'SelectedObject', radio_button(children_params(i).value));
                        end
                        curr_height = curr_height + length(children_params(i).selection)/(2*num_of_obj);
                        
                    elseif ( isfield(children_params(i), 'choose' ) && ~isempty(children_params(i).choose))

                        ui_bg = uibuttongroup('parent', buttongroup_handle, 'units', 'normalized', ...
                            'position', [0, curr_height, 1, (length(children_params(i).choose)+2)/K], ...
                            'title', children_params(i).title, 'FontWeight', 'bold');
                        for ui_index = 1:length(children_params(i).choose)
                            radio_button(ui_index) = uicontrol('Style','checkbox','String',children_params(i).choose{ui_index}, ...
                                'units', 'normalized', 'position',[0 (ui_index-1)/length(children_params(i).choose) 1 1/length(children_params(i).choose)], ...
                                'parent',ui_bg, 'callback', children_params(i).callback, 'value', children_params(i).value);
                        end
%                         if( isfield(children_params(i), 'value') && ~isempty(children_params(i).value))
%                             set(ui_bg, 'SelectedObject', radio_button(children_params(i).value));
%                         end
                        curr_height = curr_height + (length(children_params(i).choose)+2)/K;
                    end
                case 'pushbutton'
                    handle_ui = uicontrol('style','pushbutton',  'parent', buttongroup_handle, ...
                        'Tag', ['pushbutton' num2str(i)], ...
                        'units', 'normalized', ...
                        'position',  [0 curr_height 1 slider_height_only/(num_of_obj)], ...
                        'String', children_params(i).title);
                    if ( isfield(children_params,  'callback')&&~isempty(children_params(i).callback))
                        set(handle_ui, 'callback', children_params(i).callback);
                    end
                    curr_height =   curr_height + slider_height_only/num_of_obj;
            end

    end    
end