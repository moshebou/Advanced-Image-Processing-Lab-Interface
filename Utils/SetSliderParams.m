function interface_params = SetSliderParams( title, max_val, min_val, curr_val, jump_step, call_back, in_interface_params, k) 
    if ( nargin <= 6 )
        interface_params.style = 'slider';
        interface_params.title = title;
        if ( length(max_val) == 1 )
            interface_params.right_text = num2str(max_val);
            interface_params.left_text = num2str(min_val);
            interface_params.min = min_val;
            interface_params.max = max_val;
            interface_params.value = curr_val; 
            interface_params.value_text = [];
            interface_params.sliderstep = jump_step*[1/(max_val-min_val) 1/(max_val-min_val)];
        else
            interface_params.right_text = num2str(max(max_val));
            interface_params.left_text = num2str(min(max_val));
            interface_params.min = 1;
            interface_params.max = length(max_val);
            interface_params.value = curr_val; 
            interface_params.value_text = num2str(max_val(curr_val));
            interface_params.sliderstep = jump_step*[1/(length(max_val)-1) 1/(length(max_val)-1)];
        end
        interface_params.callback = call_back; 
    else
        in_interface_params(k).style = 'slider';
        in_interface_params(k).title = title;
        if ( length(max_val) == 1 )
            in_interface_params(k).right_text = num2str(max_val);
            in_interface_params(k).left_text = num2str(min_val);
            in_interface_params(k).min = min_val;
            in_interface_params(k).max = max_val;
            in_interface_params(k).value = curr_val; 
            in_interface_params(k).value_text = [];
            in_interface_params(k).sliderstep = jump_step*[1/(max_val-min_val) 1/(max_val-min_val)];
        else
            in_interface_params(k).right_text = num2str(max(max_val));
            in_interface_params(k).left_text = num2str(min(max_val));
            in_interface_params(k).min = 1;
            in_interface_params(k).max = length(max_val);
            in_interface_params(k).value = curr_val; 
            in_interface_params(k).value_text = num2str(max_val(curr_val));
            in_interface_params(k).sliderstep = jump_step*[1/(length(max_val)-1) 1/(length(max_val)-1)];
        end
        in_interface_params(k).callback = call_back;
        interface_params = in_interface_params;
    end
end