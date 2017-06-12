function handles = DeployAxes( parent, axes_num, bottom, left, width, height, is_outerposition )
%
    if ( nargin < 6 )
        height = 0.8;
    end
    if ( nargin < 5 )
        width = 0.8;
    end
    if ( nargin < 4 )
        error ( 'left param must be defined');
    end


    if ( ~ iscell ( axes_num ) )
        if ( nargin < 7 )
            is_outerposition = zeros(1, axes_num(1)*axes_num(2));
        end
        middle_y =bottom + (1-bottom)*height/2 +0.037;%(1+bottom)/2 ;
        middle_x = left+(1-left)*width/2+0.03;%(1+left)/2;
        max_width_per_one = width/axes_num(1);
        max_height_per_one = height/axes_num(2);
        fig_unit = get(parent, 'units');
        set(parent, 'units', 'pixels');
        fig_pos = get(parent, 'position');
        set(parent, 'units',fig_unit);
        width_pixels = fig_pos(3)*(1-left)*max_width_per_one;
        height_pixels = fig_pos(4)*(1-bottom)*max_height_per_one;
        if  ( width_pixels > height_pixels )
            width = height_pixels/fig_pos(3);
            height = height_pixels/fig_pos(4);
        else
            height = width_pixels/fig_pos(4);
            width = width_pixels/fig_pos(3);
        end
        x_start= middle_x - width*axes_num(1)/2;
        y_start= middle_y - height*axes_num(2)/2;

        for j=1:axes_num(2)
            for i=1:axes_num(1)
                if ( is_outerposition(i+(axes_num(2) - j)*axes_num(1)))
                    handles.(['axes_' num2str(i+(axes_num(2) - j)*axes_num(1))]) = axes('parent', parent, ...
                    'units', 'normalized', ... 
                    'fontweight','bold','fontsize',9, ...
                    ...'fontsize', 6, ...
                    'outerPosition', [x_start+width*(i-1) + 0.005*(i-1),  y_start+(j-1)*height+ 0.005*(j-1), width, height], ...
                    'visible', 'off' ...
                    );
                else
                    handles.(['axes_' num2str(i+(axes_num(2) - j)*axes_num(1))]) = axes('parent', parent, ...
                    'units', 'normalized', ... 
                    'fontweight','bold','fontsize',9, ...
                    ...'fontsize', 6, ...
                    'Position', [x_start+width*(i-1) + 0.005*(i-1),  y_start+(j-1)*height+ 0.005*(j-1), width, height], ...
                    'visible', 'off' ...
                    );
                end
                axis off;

%                 if( nargin == 7 )
%                    if (isfield(axes_params, 'string'))
%                        if ( axes_num(2) ==1 && (isfield(axes_params, 'ver_align')))
%                                 switch axes_params(i+(j-1)*axes_num(1)).ver_align
%                                     case 'top'
%                                        pos = [0.5, 0];
%                                        HorizontalAlignment = 'center';
%                                        VerticalAlignment = axes_params.ver_align;
%                                     case 'bottom'
%                                        pos = [0.5, 1];
%                                        HorizontalAlignment = 'center';
%                                        VerticalAlignment = axes_params.ver_align;
%                                     case 'middle'
%                                        pos = [0.5, 0.5];
%                                        HorizontalAlignment = 'center';
%                                        VerticalAlignment = axes_params.ver_align;
%                                 end
%                        elseif (axes_num(1) ==1 && (isfield(axes_params, 'hor_align')))
%                                 switch axes_params(i+(j-1)*axes_num(1)).hor_align
%                                     case 'right'
%                                        pos = [0, 0.5];
%                                        HorizontalAlignment = axes_params.hor_align;
%                                        VerticalAlignment = 'middle';
%                                     case 'left'
%                                        pos = [1, 0.5];
%                                        HorizontalAlignment = axes_params.hor_align;
%                                        VerticalAlignment = 'middle';
%                                     case 'center'
%                                        pos = [0.5, 0.5];
%                                        HorizontalAlignment = axes_params.hor_align;
%                                        VerticalAlignment = 'middle';
%                                 end     
%                        else
%                            if ( j==axes_num(2))
%                                pos = [0.5, 1];
%                                HorizontalAlignment = 'center';
%                                VerticalAlignment = 'bottom';
%                            elseif (j==1)
%                                pos = [0.5, 0];
%                                HorizontalAlignment = 'center';
%                                VerticalAlignment = 'top';
%                            elseif ( i==axes_num(1))
%                                pos = [1, 0.5];
%                                HorizontalAlignment = 'left'; 
%                                VerticalAlignment = 'middle'; 
%                            elseif ( i==1)
%                                pos = [0, 0.5];
%                                HorizontalAlignment = 'right'; 
%                                VerticalAlignment = 'middle'; 
%                            else
%                                pos = [0.5, 0];
%                                HorizontalAlignment = 'center'; 
%                                VerticalAlignment = 'middle'; 
%                            end
%                        end
%                        text( 'parent', handles.(['axes_' num2str(i+(j-1)*axes_num(1))]), ...
%                            'string', axes_params(i+(j-1)*axes_num(1)).string, ...
%                            'units', 'normalized', ...
%                            'position', pos,...
%                            'visible', 'on', ...
%                            'HorizontalAlignment', HorizontalAlignment, ...
%                           'VerticalAlignment', VerticalAlignment, ...
%                            'fontsize', 20);
%                    end
% 
%                    if (isfield(axes_params, 'callback'))
%                        set(handles.(['axes_' num2str(i+(j-1)*axes_num(1))]), 'callback', axes_params(i+(j-1)*axes_num(1)).callback);
%                    end
%                    if (isfield(axes_params, 'slider'))
%                          handles.(['axes_' num2str(k)]) = uicontrol('style', 'slider', ...
%                                                  'callback', axes_params(['axes_' num2str(i+(j-1)*axes_num(1))]).slider.callback, ...
%                                                  'max', axes_params(['axes_' num2str(i+(j-1)*axes_num(1))]).slider.max, ...
%                                                  'min', axes_params(['axes_' num2str(i+(j-1)*axes_num(1))]).slider.min, ...
%                                                  'outerposition', axes_params(['axes_' num2str(i+(j-1)*axes_num(1))]).slider.position, ... 
%                                                  'sliderstep', axes_params(['axes_' num2str(i+(j-1)*axes_num(1))]).slider.sliderstep);
% 
%                    end
% 
%                 end
            end
        end
    else
        middle_y = bottom + (1-bottom)*height/2 + 0.03;%(1+bottom)/2 ;
        middle_x = left   + (1-left)*  width/2  + 0.03;%(1+left)/2;
        
        cell_axes_num = axes_num;
        num_y = size(cell_axes_num,1);
        num_x = size(cell_axes_num,2);
        width_per = min(width*(1-left), 1-0.06-left) /num_x;
        height_per = min(height*(1-bottom), 1-0.06-bottom)/num_y;
        k=1;
        left = middle_x - width*(1-left)/2 ;
        bottom = middle_y - height*(1-bottom)/2 ;
        
        for i=1:num_y 
            for j=1:num_x
                curr_middle_x = width_per/2 +(j-1)*width_per +left ;
                curr_middle_y = height_per/2 +(i-1)*height_per + bottom ;
                curr_width_per_axes = width_per/cell_axes_num{i,j}(2);
                curr_height_per_axes = height_per/cell_axes_num{i,j}(1);
                x_start = curr_middle_x - width_per/2;
                y_start = curr_middle_y - height_per/2;
                for m=cell_axes_num{i,j}(1) : -1 :1
                    for n=1:cell_axes_num{i,j}(2)
                        handles.(['axes_' num2str(k)]) = axes('parent', parent, ...
                        'units', 'normalized', ... 
                        'outerposition', [x_start+curr_width_per_axes*(n-1)+ 0.01*n + 0.022*(j-1), ...
                        y_start+curr_height_per_axes*(m-1) + 0.008*m + 0.02*(i-1),...
                        curr_width_per_axes, ....
                        curr_height_per_axes - 0.02], ...
                        'fontweight','bold','fontsize',9, ...
                        ...'fontsize', 6, ...
                        'visible', 'on' ...
                        );
                        k=k+1;
                    end
                end
            end   
        end
    end
end
