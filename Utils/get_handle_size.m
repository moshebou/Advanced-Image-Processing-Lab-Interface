function size_dim = get_handle_size(handle, units,  dim )
if ( nargin < 1 ) 
    erorr('handle must be specified');
elseif nargin == 1
    units = 'pixels';
end
orig_handle_unit = get(handle,'units');
set(handle, 'units', units);
size_dim = get(handle, 'position');
set( handle, 'units', orig_handle_unit);
if( nargin == 3)
    if ( ischar(dim))
        switch lower(dim)
            case { 'h','height'}
                dim = 4;
            case { 'w', 'width'}
                dim = 3;
            case {'t', 'top'}
                dim = 2;
            case {'l', 'left'}
                dim = 1;
            otherwise
                error(['dim ' dim ' not supported']);
        end
    end
    if ( ~strcmpi(class(dim),'double') || dim>4 || dim < 1 || mod(dim,1) ~= 0)
        error(['dim ' dim ' not supported']);
    end
    size_dim = size_dim(dim);
end