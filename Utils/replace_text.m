function collected_text = replace_text(head_folder, file_type, start_str, end_str, retrive_params_format, result_str)
    collected_text = replace_text_recursive(head_folder, file_type, start_str, end_str, retrive_params_format, result_str);
end

function  replace_text_recursive(head_folder, file_type, start_str, end_str, retrive_params_format, result_str)
    list = dir (head_folder);

    for i=1:length(list)
        if ( list(i).isdir && ~(list(i).name(end) == '.'))
            collect_text_recursive([head_folder list(i).name '\'], file_type, start_str, end_str, retrive_params_format, result_str);
        else
            [pth, name, ext] = fileparts(list(i).name);
            if ( sum(strcmpi(ext, file_type)))
                fid = fopen([ head_folder list(i).name], 'rt');
                input_txt = textscan(fid,'%s','delimiter','\n');
                fclose(fid);
                input_txt = input_txt{1};
                src_str = start_str;
                l1=[]; l2=[]; l=[]; k1=[]; k2=[];
                for k=1:length(input_txt)
                    output_txt{out_k} = input_txt{k};
                    out_k = out_k +1;
                    if (~ isempty(k1) )
                        for par_i=1:length(retrive_params_format)
                            param{par_i} = sscanf( input_txt{k}, retrive_params_format{par_i});
                        end
                    end
                    l = strfind(input_txt{k}, src_str);
                    if( ~isempty(l))
                        if ( isempty(k1))
                            k1=k;
                            src_str = end_str; 
                        else
                            k2=k;
                            src_str = start_str; 
                            output_txt{k1} = sprintf(result_str, param{:});
                            out_k = k1 +1 ;
                        end
                    end
                end
                fid = fopen([ head_folder list(i).name], 'wt');
                for out_txt_index = 1:length(output_txt)
                    fprintf(fid, '%s\n', output_txt{out_txt_index});
                end
                fclose(fid);
            end
        end
    end
end
