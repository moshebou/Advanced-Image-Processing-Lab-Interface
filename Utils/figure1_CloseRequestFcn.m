% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
HandleFileList('clear global' );
image_index = handles.image_index;
image_index2 = handles.image_index2;
signal_index = handles.signal_index;
signal_index2 = handles.signal_index2;
save([ScriptCurrentDirectory '\input_indexs.mat'], 'image_index', 'image_index2', 'signal_index', 'signal_index2');
cd( handles.curr_dir );
path(handles.curr_path);

% rmpath([ScriptCurrentDirectory]);
% rmpath([handles.head_path]);
%  if (~isempty(handles.AxesTextChildren)); clear  handles.AxesTextChildren; end;
%  if (~isempty(handles.S));clear  handles.S; end;
%  guidata(hObject, handles);

% cd(handles.head_path);

    delete(hObject);
    
    
    
function scd = ScriptCurrentDirectory
    scd = mfilename('fullpath');
    scd = scd(1:end - length(mfilename));
