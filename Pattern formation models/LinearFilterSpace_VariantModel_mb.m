%% Spectrum Controlled By Auxiliary Image
%  inhomogeneous Gaussian pseudo-random field with local power spectrum defined by local power spectrum of an auxiliary image
%% Experiment Description:
% 
%% Tasks: 
% 6.2.2.
%
% * Generate and observe inhomogeneous Gaussian pseudo-random field with
% local power spectrum defined by local power spectrum of an auxiliary
% image (program lcdctrnd.m).  
%% Instruction:
% 
%% Theoretical Background: 
% 
%% Reference:
% * [1]
% <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/PatrnForm_Gromov.pdf,
% Leonid P. Yaroslavsky, "From pseudo-random numbers to stochastic growth
% models and texture images">
function LinearFilterSpace_VariantModel = LinearFilterSpace_VariantModel_mb( handles )
    handles = guidata(handles.figure1);

    axes_hor = 2;
    axes_ver = 2;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    LinearFilterSpace_VariantModel = DeployAxes( handles.figure1, ...
        [axes_hor, ...
        axes_ver], ...
        bottom, ...
        left, ...
        0.9, ...
        0.9);
    % initial params
    LinearFilterSpace_VariantModel.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    LinearFilterSpace_VariantModel.SzX =5;
    LinearFilterSpace_VariantModel.SzY = 5;
    %
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;
%     interface_params =  SetSliderParams('Set Window Width', 17, 1, LinearFilterSpace_VariantModel.SzX , 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzX',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set Window Width', 35, 1, LinearFilterSpace_VariantModel.SzX , 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzX',@update_sliders), interface_params, k);
    k=k+1;
%     interface_params =  SetSliderParams('Set Window Height', 17, 1, LinearFilterSpace_VariantModel.SzY , 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzY',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set Window Height', 35, 1, LinearFilterSpace_VariantModel.SzY , 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzY',@update_sliders), interface_params, k);
    k=k+1;


    
    
    
    
    
    
    
    
    

    LinearFilterSpace_VariantModel.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
     


    process_image(LinearFilterSpace_VariantModel.im,LinearFilterSpace_VariantModel.SzX, LinearFilterSpace_VariantModel.SzY, ...
    LinearFilterSpace_VariantModel.axes_1, LinearFilterSpace_VariantModel.axes_2, LinearFilterSpace_VariantModel.axes_3);
end



function update_sliders(handles)
	if ( ~isstruct(handles))
		handles = guidata(handles);
	end
	if ( strcmpi(handles.interactive, 'on'))
		run_process_image(handles);
	end
	guidata(handles.figure1,handles );
end

function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
    LinearFilterSpace_VariantModel = handles.(handles.current_experiment_name);
    process_image(LinearFilterSpace_VariantModel.im,LinearFilterSpace_VariantModel.SzX, LinearFilterSpace_VariantModel.SzY, ...
    LinearFilterSpace_VariantModel.axes_1, LinearFilterSpace_VariantModel.axes_2, LinearFilterSpace_VariantModel.axes_3);
end

function process_image(im, SzX, SzY,  axes_1, axes_2, axes_3)
    imshow(im, [0 255], 'parent', axes_1);
    DisplayAxesTitle( axes_1,{ 'Test image'}, 'TM',10);
     % Local
    imshow(lcdctrnd_mb(im,SzY,SzX), [0 255], 'parent', axes_2);
    DisplayAxesTitle( axes_2,{ 'Pseudo-random pattern with', 'local spectrum Controlled by the reference image'}, 'TM',10);
    % Global
    alpha = dct2(im);
    dc=alpha(1,1);
    alpha_sign=sign(rand(size(alpha))-0.5);
    alpha_abs=abs(alpha);
    alpha=alpha_abs.*alpha_sign;
    alpha(1,1)=dc;
    im_idct = idct2(alpha);
    imshow(abs(im_idct), [0 255], 'parent', axes_3);
    DisplayAxesTitle( axes_3,{ 'Pseudo-random pattern with',  'global spectrum Controlled by the reference image'}, 'BM',10);
end
