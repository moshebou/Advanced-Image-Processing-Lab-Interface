function DisplayAxesTitle( axes_handle, String, Position, font_size)
    if ( nargin < 2 )
        error('not enough arguments');
    elseif ( nargin < 3 )
            Position = 'TL';
            font_size = 9;
    end
    if ( nargin < 4 )
            font_size = 9;
    end
    
    if ( iscell (String ))
        text_height = length(String);
        text_width = 0;
        for i = 1: text_height
            text_width = max(text_width, length(String{i}));
        end
    else
        text_height = 1;
        text_width = length(String);
    end
    
    factor = 0.02;
    figure_handle = get(axes_handle, 'parent');
    axes_units = get(axes_handle, 'units');
    set(axes_handle, 'units', 'points');
    axes_position = get(axes_handle, 'position' );
    set(axes_handle, 'units', axes_units);
    
    figure_units = get(figure_handle, 'units');
    set(figure_handle, 'units', 'points');
    figure_position = get(figure_handle, 'position' );
    set(figure_handle, 'units', figure_units);
    
    available_height_top   = figure_position(4) - (axes_position(2)+axes_position(4));
    available_height_bottom = axes_position(2);
    available_width_right  = figure_position(3) - (axes_position(1)+axes_position(3));
%     available_width_left   = figure_position(3) - (axes_position(1)+axes_position(3));
    if ( ischar(Position))
        switch Position
            case 'TL'
                Position = [0 1];
                HorizontalAlignment = 'left';
                VerticalAlignment = 'bottom';
                Rotation = 90;
                font_size = floor(min(font_size, available_height_top/text_height));
                
            case 'TR'
                Position = [1 1];
                HorizontalAlignment = 'right';
                VerticalAlignment = 'bottom';
                font_size = floor(min(font_size, available_height_top/text_height));
            case 'TM'
                Position = [0.5 1+factor];
                HorizontalAlignment = 'center';
                VerticalAlignment = 'bottom';
                font_size = floor(min(font_size, available_height_top/text_height));
                font_size = floor(min(font_size, 1.83*axes_position(3)/text_width));
            case 'LT'
                Position = [0 1];
                HorizontalAlignment = 'right';
                VerticalAlignment = 'top';
                Rotation = 90;
            case 'LM'
                Position = [0-2.5*factor 0.5];
                HorizontalAlignment = 'center';
                VerticalAlignment = 'bottom';
                Rotation = 90;
            case 'LB'
                Position = [0 0];
                HorizontalAlignment = 'right';
                VerticalAlignment = 'bottom';
                Rotation = 90;
            case 'RT'
                Position = [1 1];
                HorizontalAlignment = 'left';
                VerticalAlignment = 'top';
                font_size = floor(min(font_size, available_width_right/text_height));
            case 'RM'
                Position = [1+0.5*factor 0.5];
                HorizontalAlignment = 'center';
                VerticalAlignment = 'top';%'bottom';
                Rotation = 90;%-90;
                font_size = floor(min(font_size, available_width_right/text_height));
            case 'RB'
                Position = [1 0];
                HorizontalAlignment = 'left';
                VerticalAlignment = 'bottom';
                font_size = floor(min(font_size, available_width_right/text_height));
            case 'BL'
                Position = [0 0];
                HorizontalAlignment = 'left';
                VerticalAlignment = 'top';
                Rotation = 90;
                font_size = floor(min(font_size, available_height_bottom/text_height));
            case 'BM'
                Position = [0.5 -factor];
                HorizontalAlignment = 'center';
                VerticalAlignment = 'top';
                font_size = floor(min(font_size, available_height_bottom/text_height));
                font_size = floor(min(font_size, 1.83*axes_position(3)/text_width));
            case 'BR'
                Position = [1 0];
                HorizontalAlignment = 'right';
                VerticalAlignment = 'top';
                font_size = floor(min(font_size, available_height_bottom/text_height));
        end
    end
    if ( ~exist('Rotation', 'var'))
        Rotation = 0;
    end
    axes_children = get(axes_handle, 'children');
    axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
    if ( length(axes_children) > 1 )
        axes_children = axes_children(strcmpi(get(axes_children, 'tag'), 'title'));
    elseif ( isempty(axes_children) )
        axes_children =  text('position', [Position(1), Position(2)],  'units', 'normalized', 'parent', axes_handle, ...
            'Interpreter','tex',  'HorizontalAlignment', HorizontalAlignment, 'VerticalAlignment', VerticalAlignment, 'Rotation', Rotation, ...
            'fontsize', font_size, 'fontweight', 'bold', 'BackgroundColor', [0.498 , 0.58, 0.902] );
    end
    
    set(axes_children, 'string',String, 'fontweight', 'bold', 'position', [Position(1), Position(2)]);
