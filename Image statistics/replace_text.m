function collected_text = replace_text(head_folder, file_type, start_str, end_str, retrive_params_format, result_str)
    collected_text = replace_text_recursive(head_folder, file_type, start_str, end_str, retrive_params_format, result_str)
end

function text = replace_text_recursive(head_folder, file_type, start_str, end_str, retrive_params_format, result_str)
    list = dir (head_folder);
    text = [];
    for i=1:length(list)
        if ( list(i).isdir && ~(list(i).name(end) == '.'))
            tmp =  collect_text_recursive([head_folder list(i).name '\'], file_type, start_str, end_str, retrive_params_format, result_str);
            if ( isempty(text) ) 
                text = tmp; 
            elseif ( ~isempty(tmp))
                tmp_fn = fieldnames(tmp);
                for i_fn =1:length(tmp_fn)
                    text.(tmp_fn{i_fn}) = tmp.(tmp_fn{i_fn});
                end
            end
        else
            [pth, name, ext] = fileparts(list(i).name);
            if ( sum(strcmpi(ext, file_type)))
                fid = fopen([ head_folder list(i).name], 'rt');
                input_txt = textscan(fid,'%s','delimiter','\n');
                fclose(fid);
                input_txt = input_txt{1};
                l1=[]; l2=[];
                for k=1:length(input_txt)
                    l1 = strfind(input_txt{k}, start_str);
                    if( ~isempty(l1));    break; end;
                end
                if( ~isempty(l1))
                    k1=k;
                    p=1;
                    for k=k1:length(input_txt)
                        param{p} = sscanf( input_txt{k}, retrive_params_format);
                        l2 = strfind(input_txt{k}, end_str);
                        if( ~isempty(l2));   break; end;                        
                    end
                end
                
                if( ~isempty(l2) && ~isempty(l1))
                    k2 = k;
                    C = textscan([input_txt{k1:k2}],'%s', 'Delimiter',',', 'MultipleDelimsAsOne', 1);
                    C = C{1};
                    for p=1:length(C)
                        for u=1:length(rmv_str)
                            C{p} = strrep(C{p}, rmv_str{u}, '');
                        end
                    end
                    text.(name) = C;
                end
            end
        end
    end
end
