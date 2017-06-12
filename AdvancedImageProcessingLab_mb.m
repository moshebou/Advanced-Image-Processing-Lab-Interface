
function varargout = AdvancedImageProcessingLab_mb(varargin)
%% Advanced Image Processing Lab Program
% Advanced image processing lab is an important step on the path of a student to become an expert in the field of image processing and computer vision.
% The lab gives the student the opportunity to link his accumulated theoretical knowledge with actual practices using tools which are industry standard, such as matlab.
% More advantages which the lab provides is the dealing with real life problems, the ability to identify problems which may occur in real application and the way to fix those problems.
% The �Advanced image processing lab project� aims to bring all those advantages together, to a single program which will:
% Give a single interactive interface to many programs and experiments
% Allows the student to customize the experiment and interactively modify the result
% For experiments with graduate behavior, give the student and graduate appearance
% Familiarize the students with professional notations from the field of image processing
% Link between the theoretical to the practice
% The following chapters will describe the structure of the program, each experiment theoretical background experiment description, and experiment results.
% The project was greatly relied on the lectures and articles of Prof. Leonid Yaroslavsky, and most of the theoretical background is taken from Prof. Yaroslavsky book: �Theoretical Foundations of Digital Imaging Using MATLAB�.
% 
    %      AdvancedImageProcessingLab_MB, by itself, creates a new AdvancedImageProcessingLab_MB or raises the existing
    %      singleton*.
    %
    %      H = AdvancedImageProcessingLab_MB returns the handle to a new AdvancedImageProcessingLab_MB or the handle to
    %      the existing singleton*.
    %
    %      AdvancedImageProcessingLab_MB('CALLBACK',hObject,eventData,handles,...) calls the local
    %      function named CALLBACK in AdvancedImageProcessingLab_MB.M with the given input arguments.
    %
    %      AdvancedImageProcessingLab_MB('Property','Value',...) creates a new AdvancedImageProcessingLab_MB or raises the
    %      existing singleton*.  Starting from the left, property value pairs are
    %      applied to the GUI before AdvancedImageProcessingLab_mb_OpeningFcn gets called.  An
    %      unrecognized property name or invalid value makes property application
    %      stop.  All inputs are passed to AdvancedImageProcessingLab_mb_OpeningFcn via varargin.
    %
    %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
    %      instance to run (singleton)".
    %
    % See also: GUIDE, GUIDATA, GUIHANDLES

    % Edit the above text to modify the response to help AdvancedImageProcessingLab_mb

    % Last Modified by GUIDE v2.5 11-Feb-2015 20:01:48

    % Begin initialization code - DO NOT EDIT
    gui_Singleton = 1;
    gui_State = struct('gui_Name',       mfilename, ...
                       'gui_Singleton',  gui_Singleton, ...
                       'gui_OpeningFcn', @AdvancedImageProcessingLab_mb_OpeningFcn, ...
                       'gui_OutputFcn',  @AdvancedImageProcessingLab_mb_OutputFcn, ...
                       'gui_LayoutFcn',  [] , ...
                       'gui_Callback',   []);
    if nargin && ischar(varargin{1})
        gui_State.gui_Callback = str2func(varargin{1});
    end

    if nargout
        [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
    else
        gui_mainfcn(gui_State, varargin{:});
    end
    % End initialization code - DO NOT EDIT


% --- Executes just before AdvancedImageProcessingLab_mb is made visible.
function AdvancedImageProcessingLab_mb_OpeningFcn(hObject, eventdata, handles, varargin)
    % This function has no output args, see OutputFcn.
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    % varargin   command line arguments to AdvancedImageProcessingLab_mb (see VARARGIN)

    % Choose default command line output for AdvancedImageProcessingLab_mb
    clc;
    if( ~exist([ScriptCurrentDirectory 'Data'], 'dir'))
        error( [ScriptCurrentDirectory 'data folder does not exist']);
    end
    if( ~exist([ScriptCurrentDirectory 'htm'], 'dir'))
        error(  [ScriptCurrentDirectory 'htm folder does not exist']);
    end
    if( ~exist([ScriptCurrentDirectory 'Utils'], 'dir'))
        error( [ScriptCurrentDirectory 'utils folder does not exist']);
    end
    handles.current_experiment_name = [];
    handles.output = hObject;
    handles.curr_dir = pwd;
    handles.curr_path = path;
    handles.interactive = 'off';
    handles.busy = 0;
    handles.head_path = ScriptCurrentDirectory;
    DescriptionFolder =[ScriptCurrentDirectory 'description\'];
    handles.description_path = DescriptionFolder;
    addpath([ScriptCurrentDirectory 'Utils']);
    addpath(ScriptCurrentDirectory);
    handles.utilspath = [ScriptCurrentDirectory 'Utils'];
    % Update handles structure
    guidata(hObject, handles);
    iptPointerManager(hObject);
    button_handles = zeros(12,1);       
    load(fullfile(ScriptCurrentDirectory, 'utils', 'TopicList.mat'));
    load(fullfile(ScriptCurrentDirectory, 'utils', 'Defaults.mat'));
%     indexs = load([ScriptCurrentDirectory '\utils\input_indexs.mat']);
    handles.image_index = 1;%indexs.image_index;
    handles.image_index2 = 2;%indexs.image_index2;
    handles.signal_index = 1;%indexs.signal_index;
    handles.signal_index2 = 2;%indexs.signal_index2;   
    handles.TopicList = TopicList;
    handles.defaults = default;
    HandleFileList('load list');
    
    string = 'pushbutton';
    handles_fieldnames = fieldnames(handles);
    handles_fieldnames = handles_fieldnames(strncmp(string,handles_fieldnames,length(string)));
    for i=1:length(handles_fieldnames)
        pointerBehavior.enterFcn = @(a,b)SetText(a,b,  i, hObject, handles, handles.(handles_fieldnames{i}));
        pointerBehavior.exitFcn = @(a,b)RemoveText(a,b,  i, hObject, handles);
        pointerBehavior.traverseFcn =[];
        iptSetPointerBehavior(handles.(handles_fieldnames{i}), pointerBehavior);
        button_handles(i) = handles.(handles_fieldnames{i});
    end
    setfontsize_pushbutton(button_handles);
    SetAdvancedImageProcessingLabText(handles );
    guidata(handles.figure1, handles); handles = guidata(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = AdvancedImageProcessingLab_mb_OutputFcn(hObject, eventdata, handles) 
    % varargout  cell array for returning output args (see VARARGOUT);
    % hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
    pause(0.1);
    SetWindow_mb('AdvancedImageProcessingLab_mb', 'on');


% --- Executes on button press in pushbutton1.
function pushbutton_Callback(hObject, eventdata, handles)
    % hObject    handle to pushbutton1 (see GCBO)
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)
    func_name = get(hObject, 'string') ;
    set(handles.figure1, 'Name', [get(handles.figure1, 'Name') ': ' func_name]);
    func_name = func_name(func_name~=':');
    folder = [ScriptCurrentDirectory func_name];
    handles.current_experiment_path = folder;
    cd(folder);
    
    func_name(func_name==' ') = '_';
    handles.current_experiment_name = func_name;
    curr_expr = handles.TopicList.(func_name){1};

    
    curr_expr(curr_expr==' ')= '_';
    curr_expr(curr_expr==',')= '';
    curr_expr(curr_expr=='&')= '_';
    curr_expr(curr_expr==':')= [];
    curr_expr(curr_expr=='-')= [];
    
    curr_default = handles.defaults.(curr_expr).im_1;
    if ( strcmpi(curr_default.type,  'signal') )
        handles.signal_index = curr_default;
    else
        handles.image_index = curr_default;
    end
    if ( isfield(handles.defaults.(curr_expr), 'im_2'))
        curr_default = handles.defaults.(curr_expr).im_2;
        if ( strcmpi(curr_default.type,  'signal') )
            handles.signal_index2 = curr_default;
        else
            handles.image_index2 = curr_default;
        end
    end
    if ( isfield(handles.defaults.(curr_expr), 'im_3'))
        curr_default = handles.defaults.(curr_expr).im_3;
        if ( strcmpi(curr_default.type,  'signal') )
            handles.signal_index3 = curr_default;
        else
            handles.image_index3 = curr_default;
        end
    end
    guidata(handles.figure1, handles);
    % Clear Buttons
    ClearButtons(  handles );    
    delete(get( handles.axes1, 'Children'))
    handles = RunExperiment(handles);
    guidata(handles.figure1, handles); handles = guidata(hObject);

function setfontsize_pushbutton( Handle )
    ref_fontsize = 8;
    ref_width = 2;
    for i=1:length(Handle)
        handle = Handle(i);
        if (~isprop(handle,  'Units')); continue; end;        
        if (~isprop(handle,  'FontSize')); continue; end;
        if (~isprop(handle,  'Position')); continue; end;
        units = get(handle, 'Units');
        set(handle, 'Units', 'inch');    
        HandlePosition = get(handle , 'position');
        set(handle, 'FontSize', floor(ref_fontsize*HandlePosition(3)/ref_width));
        set(handle, 'Units', units);
    end
    
    


function scd = ScriptCurrentDirectory
    scd = mfilename('fullpath');
    scd = scd(1:end - length(mfilename));

% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
LoadImage_callback(hObject, eventdata, handles);

% --------------------------------------------------------------------
function help_button_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to help_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% option = struct('format', 'html','outputDir', handles.description_path, 'showCode', false, 'evalCode' , false);

% if( isfield(handles, 'current_experiment_name') && ~isempty(handles.current_experiment_name))
%     funcStr = get(get(handles.buttongroup, 'SelectedObject'), 'string');
%     funcStr = funcStr(funcStr~=' ');
%     funcStr = funcStr(funcStr~='&');
%     funcStr(funcStr=='/') = '_';
%     funcStr(funcStr=='-') = '_';
%     funcStr(funcStr==':') = '';
%     func = [funcStr '_mb.m'];
%     %delete([handles.utilspath '\' func]);
%     delete([handles.utilspath '\' func(1:end-2) '*.png']);
%     func = [ handles.current_experiment_path '\' func];
%     option = struct('format', 'html','outputDir', [handles.current_experiment_path, '\html\'], 'showCode', false, 'evalCode' , false);
%     %file_name = publish(func, option, 26);
%     file_name = publish(func, option);
% else
%     func =mfilename('fullpath');
%     %file_name = publish ( func, option, 26);
%     file_name = publish(func, option);
% end
% file_name = 
handles = guidata(handles.figure1);
if ( isempty(handles.current_experiment_name)) 
    file_name = [ScriptCurrentDirectory 'htm/Advanced image processing lab project layout.htm'];
else
    file_name = [ ScriptCurrentDirectory 'htm/' strrep(handles.current_experiment_name, '_', ' ') '.htm'];
end
pause(0.01);
web(file_name, '-helpbrowser');


% --------------------------------------------------------------------
function InteractiveMode_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to InteractiveMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(hObject);
if ( strcmpi(handles.interactive, 'on' ) )
    interactive_off_icon = imread('off_icon.png');
    handles.interactive = 'off';
    set(hObject, 'cdata', interactive_off_icon);
else
    interactive_on_icon = imread('on_icon.png');
    handles.interactive = 'on';
    set(hObject, 'cdata', interactive_on_icon);
end
guidata(hObject, handles);




% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles = guidata(handles.figure1);
C = round(clock);
curr_date = [num2str(C(1)), '_', num2str(C(2), '%02d'), '_', num2str(C(3), '%02d'), '_', num2str(C(4), '%02d'), '_', num2str(C(5), '%02d'), '_', num2str(C(6), '%02d')];
result_folder = [ScriptCurrentDirectory, 'Results\'];
set(handles.figure1,'PaperPositionMode','auto');
if (~exist([result_folder,  handles.current_experiment_name] , 'dir'))
    mkdir([result_folder,  handles.current_experiment_name]);
end
% fig_img = print(handles.figure1, '-r0', '-RGBImage');% '-noui');

if ( isempty(handles.current_experiment_name))
%     button_units = get(handles.pushbutton1, 'units');
%     set(handles.pushbutton1, 'units', 'normalized');
%     button_pos = get(handles.pushbutton1, 'position');
%     set(handles.axes1, 'units', button_units);
%     fig_img = fig_img(:, ceil(size(fig_img,2)*(0.01+button_pos(1)+button_pos(3))):end, :);
    experiment_str = 'main';
else
%     button_units = get(handles.pushbutton1, 'units');
%     set(handles.pushbutton1, 'units', 'normalized');
%     button_pos = get(handles.pushbutton1, 'position');
%     set(handles.axes1, 'units', button_units);
%     fig_img = fig_img(:, ceil(size(fig_img,2)*(0.001+button_pos(1)+button_pos(3))):end, :);
    
    experiment_str = get(get(handles.buttongroup, 'selectedObject'), 'string');
    if ( isempty(experiment_str) ) 
        experiment_str = get(get(handles.buttongroup, 'selectedObject'), 'tag');
    end
    experiment_str = strrep(experiment_str, ' ', '_');
    experiment_str = strrep(experiment_str, ':', '');
    experiment_str = strrep(experiment_str, ',', '');
end
% imwrite(fig_img, [result_folder,  handles.current_experiment_name, '/', curr_date, '_', experiment_str, '.jpg']);

saveas(handles.figure1,[result_folder,  handles.current_experiment_name, '/', curr_date, '_', experiment_str, '.jpg']);
