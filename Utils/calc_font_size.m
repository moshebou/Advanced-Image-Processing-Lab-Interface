function font_size = calc_font_size(string_length, deploy_length, units, min_font_size)
    if ( nargin < 3)
        units = 'inches';
    end
    if ( nargin < 4 )
        min_font_size = 8;
    end

    ratio = deploy_length/string_length;
    switch units
        case 'inches'
            %inches per character
            font_size = ratio*72;
        case 'pixels'
            % pixels per character
            ppi = get(0,'ScreenPixelsPerInch');
            ratio = ratio/ppi;
            font_size = ratio*72;
    end
    font_size = max(font_size, min_font_size);
end
    
        