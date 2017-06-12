
% --------------------------------------------------------------------
function LoadImage_callback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
image_descriptor = HandleFileList('open dialog' );
if ( ~isempty(image_descriptor))
    if  ( strcmpi( get(hObject, 'tag'), 'uipushtool1') && strcmpi(image_descriptor.type, 'image'))
        handles.image_index = image_descriptor;
    elseif  ( strcmpi( get(hObject, 'tag'), 'uipushtool12')&& strcmpi(image_descriptor.type, 'image'))
        handles.image_index2 = image_descriptor;
    elseif  ( strcmpi( get(hObject, 'tag'), 'uipushtool1')&& strcmpi(image_descriptor.type, 'signal'))   
        handles.signal_index = image_descriptor;
    elseif  ( strcmpi( get(hObject, 'tag'), 'uipushtool12')&& strcmpi(image_descriptor.type, 'signal'))   
        handles.signal_index2 = image_descriptor;
    elseif  ( strcmpi( get(hObject, 'tag'), 'uipushtool4')&& strcmpi(image_descriptor.type, 'image'))
        handles.image_index3 = image_descriptor;
    elseif  ( strcmpi( get(hObject, 'tag'), 'uipushtool4')&& strcmpi(image_descriptor.type, 'signal'))   
        handles.signal_index3 = image_descriptor;
    end
    guidata(handles.figure1, handles);
    if ( isfield(handles, 'current_experiment_name') && ~isempty(handles.current_experiment_name))
        guidata(handles.figure1, handles);
        handles = RunExperiment(handles, image_descriptor);
        guidata(handles.figure1, handles);        
    end
end