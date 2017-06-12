function change_str_in_another(path, file, original_string, new_string)

end

function recursive_folder_run(head_path, original_string)
    for i=1:length(original_string)
        srch_org_str{i} = original_string{i}(1:strfind(original_string{i},'%'));
    end

    list = dir(head_path);
    for i=1:length(list)
        if( list(i).isdir && list(i).name(end) ~= '.')
        elseif ( strcmpi(list(i).name(end-1:end), '.m'))
            fid_read = fopen([head_path list(i).name], 'rt' );
            fid_write = fopen([head_path list(i).name 'tmp'], 'wt' );
            tline = fgetl(fid);
            while ischar(tline)
                k{1} = strfind(tline, original_string{1});
                if ( ~isempty(k{1}) )
                    
                else
                    fprintf(fid_write, [tline '\n']);
                end
                end
                disp(tline)
                tline = fgetl(fid);
            end
            fclose(fid);
        end
    end
end