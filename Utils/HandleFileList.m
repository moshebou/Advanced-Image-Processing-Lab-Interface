function ReturnVal = HandleFileList(operation, params, im_2_col )

global signal_list
global image_cdata
global image_descriptor


if(nargin == 2 )
    im_2_col = [];
end
    switch lower(operation)
        case 'change image'
                if (params.value == 1)
                    image = HandleFileList('open dialog');
                end
                ReturnVal = HandleFileList('load', image );
        case 'load list'
            %%

                signal_list(1).filename = [ScriptCurrentDirectory '..\Data\Ecg256.mat'];
                signal_list(1).title = 'Ecg256';           
                signal_list(1).width = 1;
                signal_list(1).height = 10000;   
                signal_list(1).index = 1;
                signal_list(1).type = 'signal';
                signal_list = orderfields(signal_list);


        case 'open dialog'
                    image_formats = imformats;     
                    image_formats = [image_formats.ext , {'img'}]';
                    image_formats=strcat('*.' ,image_formats ,';');
                    image_formats = [image_formats{:}];
                    signal_format = '*.mat';
                    FilterSpec =  {image_formats , [ 'Image Files (' image_formats ')'] ; ...
                                    signal_format, [ 'Signal Files (' signal_format ')']};
                    [File.Name,File.Path, File.Index]  = uigetfile(FilterSpec,    'Please Select An Image File', '..\data\','MultiSelect', 'off');
                    if ( File.Name ~=0 )
                        ReturnVal = HandleFileList('add to list', File );
                    else
                        ReturnVal = [];
                    end
                    
        case 'get'
            if ( isstruct(params))
                ReturnVal = params;
            elseif (isfinite(params))
                ReturnVal = HandleFileList('open dialog');
            end
        case 'get signal'
            if ( isstruct(params))
                ReturnVal = params;
            elseif (isfinite(params))
                if ( length(signal_list) >= params)
                    ReturnVal = signal_list(params);
                else %if ( length(signal_list)== params-1)
                    ReturnVal = HandleFileList('open dialog');
%                 else
%                     error(['no image on index ' num2str(params) ]);
                end
            end
        case 'getcurrent'
            if ( strcmpi('cdata',params))
                ReturnVal = image_cdata;
            elseif ( strcmpi('descriptor',params))
                ReturnVal =image_descriptor;
            end            
        case 'load'
            if( strcmpi(params.type, 'image'))
                ReturnVal =  load_image_mb(params); 
                if(isfield(params, 'im_2_col') && ~isempty(params.im_2_col))
                    switch lower(params.im_2_col)
                        case 'im'
                            ReturnVal = ReturnVal.im;
                        case 'sliding'
                            ReturnVal = ReturnVal.sliding;
                        case 'distinc'
                            ReturnVal = ReturnVal.distinc;
                    end
                else 
                    ReturnVal = ReturnVal.im;
                end
            elseif (strcmpi(params.type,'signal'))
                ReturnVal = load(params.filename);
                fieldsname = fieldnames(ReturnVal);
                ReturnVal = ReturnVal.(fieldsname{1});
            end

        case 'add to list'
            filename = [params.Path, params.Name];
            [pathstr, name, ext] = fileparts(filename);  
            if ( strcmpi(ext, '.img'))
                prompt = {'Enter Image Width:','Enter Image Heigh:'};
                dlg_title = 'Image Dimensions';
                num_lines = 1;
                def = {'256','256'};
                answer = inputdlg(prompt,dlg_title,num_lines,def);
                image.width = str2double(answer{1});
                image.height = str2double(answer{2});             
            else
                image.width = [];
                image.height = [];
            end
            image.filename = filename;
            image.title = upper(name);
            if( params.Index == 1 )
                image.type = 'image';
                image.index = 1;
            elseif ( params.Index == 2 )
                image.type = 'signal';
                if ( sum(strcmpi({signal_list.filename}, filename)) )
                    image.index = find(strcmpi({signal_list.filename}, filename));
                    signal_list(image.index) = orderfields( image) ;
                else
                    image.index = length(signal_list) +1;
                    signal_list(end+1) =  signal_list(1);
                    signal_list(1) = orderfields(image);
                end
                save([ ScriptCurrentDirectory 'signal_list.mat'], 'signal_list');  
            end
            ReturnVal = image;
        case 'clear global'
            clear global image_cdata
            clear global image_descriptor
        otherwise
            error([ 'operation ' operation ' not supported']);
    end
end

function scd = ScriptCurrentDirectory
    scd = mfilename('fullpath');
    scd = scd(1:end - length(mfilename));
end