function SetText(eventSource, eventData, i, hObject, handles, button_handle)
handles = guidata(hObject);
button_num = get(button_handle, 'tag');
button_num = str2num(button_num(11:end));

x = linspace(0 ,1, 5);
x = x(1:end-1);
y = linspace(0 , 1, 4);
y = y(2:end);

x = x(mod(button_num-1, 4)+1);
y = y(end -ceil(button_num/4) +1);

button_string = get(button_handle, 'string');
string = {[button_string ':']} ;
button_string = button_string(button_string~=':');
button_string(button_string==' ') = '_';
button_string(button_string=='&') = '_';

string =[ string; cellfun(@(v) ['- ', v], handles.TopicList.([button_string]), 'Uniform', 0) ];
handle_units = get(handles.axes1, 'units');
set(handles.axes1, 'units', 'inches');


handles.AxesTextChildren = get( handles.axes1, 'Children');

handles.AxesTextChildren = handles.AxesTextChildren(strcmpi('text', get(handles.AxesTextChildren, 'Type')));
delete(handles.AxesTextChildren)


t = text('parent', handles.axes1, ...
    'string', string, ...
    'units', 'normalized', ...
    'Clipping', 'off', ...
    'interpreter', 'tex', ...
    'color', 'w', ...
    'position', [x y], ...
    'HorizontalAlignment','left', ...
    'VerticalAlignment', 'top', ...
    'Visible', 'on', ...
    'fontsize', 14);

% align( [ handles.axes1 handles.AxesTextChildren] , ...
%     'HorizontalAlignment', ...
%     'Distribute', ...
%     'VerticalAlignment', ...
%     'Distribute')
set(handles.axes1, 'units', handle_units);
guidata(handles.figure1, handles); 