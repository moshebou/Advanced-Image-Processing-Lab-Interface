function handle_ret = RunTopic (handles)
    
    funcStr = get(get(handles.buttongroup, 'SelectedObject'), 'string');
    if( isempty( funcStr ) )
        funcStr = get(get(handles.buttongroup, 'SelectedObject'), 'tag');
    end
    funcStr = funcStr(funcStr~=' ');
    funcStr = funcStr(funcStr~=',');
    funcStr = funcStr(funcStr~='&');
    funcStr(funcStr=='/') = '_';
    funcStr(funcStr=='-') = '_';
    funcStr(funcStr==':') = '';
    func = str2func([funcStr '_mb']);
    handle_ret = func(handles);
end
