%% Composite Models
%  
%% Experiment Description:
% 
%% Tasks: 
% 6.2.3.
%
% * PWT-LF model. Generate a figure texture using the above program for
% generating binary image with a given probability of ones and program
% conv2.m.
% * LF-PWT model. Generate a pseudo-random binary images using programs for
% generating Gaussian pseudo-random fields with different power spectrum
% (programs corrgauss.m, gtexture.m).  
%
%
%% Instruction:
% 
%% Theoretical Background: 
% 
%% Reference:
% * [1]
% <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/PatrnForm_Gromov.pdf,
% Leonid P. Yaroslavsky, "From pseudo-random numbers to stochastic growth
% models and texture images">
function CompositeModels = CompositeModels_mb( handles )
    handles = guidata(handles.figure1);
    axes_hor = 3;
    axes_ver = 2;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    CompositeModels = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9);
    % initial params
    CompositeModels.Sz =5;
    CompositeModels.RE = 0.1;
    CompositeModels.RI = 0.09;
    CompositeModels.RD = 0.1;
    CompositeModels.P  =0.001;
    CompositeModels.Amp=3; %Set amplification factor for PWTtransformation I, LF-PWT model
    CompositeModels.WSzX=5;
    CompositeModels.WSzY=9; %"Set X-Y sizes of rectangle PSF of linear filter for PWT-LF model"  = 0;


    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;
    interface_params =  SetSliderParams('Set X sizes of rectangular PSF of linear filter for PWT-LF model', 25, 1, CompositeModels.WSzX , 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WSzX',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set Y sizes of rectangular PSF of linear filter for PWT-LF model', 25, 1, CompositeModels.WSzY , 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WSzY',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Threshold value for PWTransformation in PWT-LF model', 0.1, 0, CompositeModels.P , 1/1000, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'P',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set amplification factor for PWTtransformation I, LF-PWT model', 10, 0, CompositeModels.Amp , 1/10, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Amp',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set Ring Internal Radius', CompositeModels.RE, 0, CompositeModels.RI , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RI',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set Ring External Radius', 1, 0.01, CompositeModels.RE , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RE',@update_sliders), interface_params, k);
%     k=k+1;    
%     interface_params(k).style = 'buttongroup';
%     interface_params(k).title = 'Choose Order Of Operations';
%     interface_params(k).selection ={ 'PWT - Linear Filter', 'Linear Filter - PWT'};   
%     interface_params(k).callback = @(a,b)ChooseOperation(a,b,handles);  

    
    
    
    
    
    
    
    
    

    CompositeModels.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
     

    process_image(CompositeModels.WSzX, CompositeModels.WSzY, CompositeModels.Amp, CompositeModels.P, ...
    CompositeModels.RI, CompositeModels.RE, ...
    CompositeModels.axes_1, CompositeModels.axes_2, CompositeModels.axes_3,CompositeModels.axes_4, CompositeModels.axes_5, CompositeModels.axes_6);
end


% function ChooseOperation(a,b,handles)
%     handles = guidata(handles.figure1);
%     handles.(handles.current_experiment_name).operation = get(b.NewValue, 'string');
%     delete(handles.(handles.current_experiment_name).buttongroup_handle);
% 	k=1;
% 	interface_params(k).style = 'pushbutton';
% 	interface_params(k).title = 'Run Experiment';
% 	interface_params(k).callback = @(a,b)run_process_image(a);
%     k=k+1;
%     interface_params =  SetSliderParams('Set Ring Internal Radius', 0.25, 0, handles.(handles.current_experiment_name).RI , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RI',@update_sliders), interface_params, k);
%     k=k+1;
%     interface_params =  SetSliderParams('Set Ring External Radius', 1, 0, handles.(handles.current_experiment_name).RE , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RE',@update_sliders), interface_params, k);
%     switch handles.(handles.current_experiment_name).operation 
%         case 'PWT - Linear Filter'
%             val2 = 1;
%         case 'Linear Filter - PWT'
%             val2 = 2;
%     end
%     k=k+1; 
%     interface_params =  SetSliderParams('Set Window Size', 17, 1, handles.(handles.current_experiment_name).Sz , 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Sz',@update_sliders), interface_params, k);
%     k=k+1;    
%     interface_params(k).style = 'buttongroup';
%     interface_params(k).title = 'Choose Order Of Operations';
%     interface_params(k).selection ={ 'PWT - Linear Filter', 'Linear Filter - PWT'};   
%     interface_params(k).callback = @(a,b)ChooseOperation(a,b,handles); 
%     interface_params(k).value = val2;
% 
%     
%     
%     
%     
%     
%     
%     
%     
%     
% 
%     handles.(handles.current_experiment_name).buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
%          
%    guidata(    handles.figure1, handles);
%     CompositeModels = handles.(handles.current_experiment_name);
%     process_image(CompositeModels.im,CompositeModels.Sz, CompositeModels.operation , ...
%     CompositeModels.rand_mean, CompositeModels.rand_std, CompositeModels.RI, CompositeModels.RE, ...
%     CompositeModels.axes_1, CompositeModels.axes_2, CompositeModels.axes_3,CompositeModels.axes_4);
% end

function update_sliders(handles)
	if ( ~isstruct(handles))
		handles = guidata(handles);
    end
    val = min(handles.(handles.current_experiment_name).RI, handles.(handles.current_experiment_name).RE);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider6');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', handles.(handles.current_experiment_name).RE);
    set(slider_handle, 'sliderstep', [1/100, 1/100]);
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value6');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText6');
    set(slider_title_handle, 'string',  num2str(handles.(handles.current_experiment_name).RE));
    handles.(handles.current_experiment_name).RI = val;
	if ( strcmpi(handles.interactive, 'on'))
		run_process_image(handles);
	end
	guidata(handles.figure1,handles );
end

function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end
    CompositeModels = handles.(handles.current_experiment_name);
    process_image(CompositeModels.WSzX, CompositeModels.WSzY,CompositeModels.Amp, CompositeModels.P , ...
    CompositeModels.RI, CompositeModels.RE, ...
    CompositeModels.axes_1, CompositeModels.axes_2, CompositeModels.axes_3,CompositeModels.axes_4, CompositeModels.axes_5, CompositeModels.axes_6);
end

function process_image(WSzX, WSzY, Amp, P, RI, RE, ...
axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
%     switch operation
%         case  'PWT - Linear Filter'
%             imshow(im, [0 255],  'parent', axes_1); 
%             DisplayAxesTitle( axes_1, ['Input Image'], 'TM');    
%             im_binary = im>127;
%             imshow(im_binary, [0 1],  'parent', axes_2); 
%             DisplayAxesTitle( axes_2, ['Input Image - Binary'], 'TM');   
%             %nlfilter(im_binary , [SzWy SzWx], @(x)im_p(x, );
%             P = imfilter(im_binary,ones(Sz,Sz)/(Sz*Sz));
%             I= rand(size(im));
%             PWT_prob = double(I<P);
%             im_size  = 256;
%             mask=255*ones(im_size);CX=im_size/2+1;CY=im_size/2+1;
%             [x,y] = meshgrid(1:im_size, 1:im_size);
%             mask(((x-CX).^2 + (y-CY).^2)<(RI*im_size/2).^2) = 0;
%             mask(((x-CX).^2 + (y-CY).^2)>(RE*im_size/2).^2) = 0;
%             mask = fftshift(mask);
%             %PWT_Lin = filter2(ones(FiltSz, FiltSz)/FiltSz*FiltSz,  PWT_prob);
%             PWT_Lin = ifft2(fft2(PWT_prob).*mask);
%             imshow(abs(PWT_Lin), [],  'parent', axes_3); 
%             DisplayAxesTitle( axes_3,{ 'Linear Filtered', 'inhomogeneous pseudo-random field','with local probability'}, 'BM');
%             delete(get(axes_4, 'children'));
%         case 'Linear Filter - PWT'
            im_size = 256;     
            im = randn(im_size)+1i*randn(im_size);
%             im = im - mean(im(:)) + rand_mean;
%             im = rand_std*real(im)/std(real(im(:)),1) + 1i*rand_std*imag(im)/std(imag(im(:)),1) ;
            mask=255*ones(im_size);CX=im_size/2+1;CY=im_size/2+1;
            [x,y] = meshgrid(1:im_size, 1:im_size);
            mask(((x-CX).^2 + (y-CY).^2)<(RI*im_size/2).^2) = 0;
            mask(((x-CX).^2 + (y-CY).^2)>(RE*im_size/2).^2) = 0;
            mask = fftshift(mask);
            lin_filt_rand_field = real(ifft2(im.*mask));
            imshow(abs(ifft2(im)), [], 'parent', axes_1); 
            DisplayAxesTitle( axes_1,{'LF-PWN\_model Seed'}, 'TM',10);
            imshow(lin_filt_rand_field, [], 'parent', axes_2); 
            DisplayAxesTitle( axes_2,{'LF-PWN\_model: linear filter output'}, 'TM',10);
            lin_filt_rand_field = (lin_filt_rand_field - min(lin_filt_rand_field(:)))/(max(lin_filt_rand_field(:)) - min(lin_filt_rand_field(:)));
            cos_lin_filt_rand_field=255*(1+cos(Amp*pi*lin_filt_rand_field))/2;
            imshow(cos_lin_filt_rand_field, [0 255], 'parent', axes_3);
            DisplayAxesTitle( axes_3,{ 'LF-PWT\_model:cosine noninearity output '},'TM',10);
            % Parameter to be set by user 0<P<0.1 
            im = rand(size(im));
            PWT_prob = im<P;      
            imshow(im, [0 1],  'parent', axes_4); 
            DisplayAxesTitle( axes_4, ['PWT-LF\_model Seed'], 'BM',10);
            imshow(PWT_prob, [0 1],  'parent', axes_5); 
            DisplayAxesTitle( axes_5, ['PWT-LF\_model: theshold nonilinearity output'], 'BM',10);
            PWT_LF_prob=conv2(double(PWT_prob),ones(WSzX,WSzY),'same');
            imshow(PWT_LF_prob, [],  'parent', axes_6); 
            DisplayAxesTitle( axes_6, ['PWT-LF\_model: linear filter output'], 'BM',10);
end




