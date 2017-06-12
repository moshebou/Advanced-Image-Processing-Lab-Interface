function RemoveText(eventSource, eventData, i, hObject, handles)
handles = guidata(hObject);
handles.AxesTextChildren = get( handles.axes1, 'Children');

handles.AxesTextChildren = handles.AxesTextChildren(strcmpi('text', get(handles.AxesTextChildren, 'Type')));
delete(handles.AxesTextChildren)
if ( ~isfield(handles,'current_experiment_name') || isempty(handles.current_experiment_name))
    SetAdvancedImageProcessingLabText(handles )
end
guidata(hObject, handles); 