function string_length = estimate_string_length_pixels( string, font_size )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if ( nargin < 2 )
    font_size = 9;
end

tmp = text('string', string, 'visible', 'off', 'units', 'pixels', 'fontsize', font_size);
tmp_pos = get(tmp, 'Extent');
string_length = tmp_pos(3);

end

