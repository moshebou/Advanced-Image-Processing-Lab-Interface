function ChangeDefaultExperimentImage( experiment_name, image_file, image_num )
if ( nargin < 3 ) 
    image_num = 1;
end
if ( nargin < 2 ) 
    image_descriptor = HandleFileList('open dialog' );
    image_file = image_descriptor.filename;
end
 

[pathstr,name,ext] = fileparts(image_file) ;
image_descriptor.filename = [fullpath_to_relative(ScriptCurrentDirectory, pathstr),name,ext];
image_descriptor.title =name;
if ( strcmpi('.mat', ext ) ) 
    image_descriptor.type = 'signal';
else
    image_descriptor.type = 'image';
end
im = load_image_mb(image_descriptor); 
image_descriptor.width = size(im.im,2);
image_descriptor.height = size(im.im,1);
if ( isfield(image_descriptor, 'index'))
    image_descriptor = rmfield(image_descriptor, 'index');
end

dflt = load('./defaults.mat');
default = dflt.default;

curr_expr = experiment_name;
curr_expr(curr_expr==' ')= '_';
curr_expr(curr_expr==',')= '';
curr_expr(curr_expr=='&')= '_';
curr_expr(curr_expr==':')= [];
curr_expr(curr_expr=='-')= [];    
fn = fieldnames(default);
max_index = 0;
experiment_exist  = false;
for i = 1 : length(fn)
    if ( strcmpi(default.(fn{i}).im_1.filename, image_descriptor.filename ))
        image_descriptor.index = default.(fn{i}).im_1.index;
    else
        max_index = max(max_index, default.(fn{i}).im_1.index);
    end
    if( isfield(default.(fn{i}), 'im_2') )
        if ( strcmpi(default.(fn{i}).im_2.filename, image_descriptor.filename ))
            image_descriptor.index = default.(fn{i}).im_2.index;
        else
            max_index = max(max_index, default.(fn{i}).im_2.index);
        end
    end
    if( isfield(default.(fn{i}), 'im_3') )
        if ( strcmpi(default.(fn{i}).im_3.filename, image_descriptor.filename ))
            image_descriptor.index = default.(fn{i}).im_3.index;
        else
            max_index = max(max_index, default.(fn{i}).im_3.index);
        end
    end
    if ( strcmpi(curr_expr, fn{i}) )
        experiment_exist = true;
    end
end
if ( ~isfield(image_descriptor, 'index'))
    image_descriptor.index  = max_index+1;
end
if ( experiment_exist == true ) 
default.(curr_expr).(['im_', num2str(image_num)]) = image_descriptor;
save('./defaults.mat', 'default');
else
    error(['experiment ', curr_expr, ' does not exist']);
end



end

function scd = ScriptCurrentDirectory
    scd = mfilename('fullpath');
    scd = scd(1:end - length(mfilename));
end