function ClearButtons(  handles )
    string = 'pushbutton';
    handles_fieldnames = fieldnames(handles);
    handles_fieldnames = handles_fieldnames(strncmp(string,handles_fieldnames,length(string)));
    for i=1:length(handles_fieldnames)
        set(handles.(handles_fieldnames{i}), 'visible', 'off');
        pointerBehavior.enterFcn = [];
        pointerBehavior.exitFcn = [];
        pointerBehavior.traverseFcn =[];
        iptSetPointerBehavior(handles.(['pushbutton' num2str(i) ]), pointerBehavior);
    end
end