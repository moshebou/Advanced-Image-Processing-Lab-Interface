%% Noise Model
%  Illustration of different noise types in digital images.
%% Experiment Description:
% This experiment illustrates the different noises effect digital image
% capturing, and the noise effect on the 1D power spectrum and auto
% correlation function of the image.
%
% a method of detecting the noise from the power spectrum is also
% introduced, and its sensitivity is controllable.
% 
% The noises introduced are:
%
% * Additive Gaussian Noise
% * Periodic Noise
% * Row - Column Noise
% * Shot Noise
% * Impulse Noise
%% Tasks: 
%% Instruction:
%
%% Theoretical Background:
% 
%% Reference:
% * [1]
% <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/PatrnForm_Gromov.pdf,
% Leonid P. Yaroslavsky, "From pseudo-random numbers to stochastic growth
% models and texture images">

function LinearFilterSpace_InvariantModel = LinearFilterSpace_InvariantModel_mb( handles )
    handles = guidata(handles.figure1);
    axes_hor = 2;
    axes_ver = 2;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    LinearFilterSpace_InvariantModel = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9);
    % initial params
    LinearFilterSpace_InvariantModel.RE = 0.1;
    LinearFilterSpace_InvariantModel.RI = 0.09;
    LinearFilterSpace_InvariantModel.RD = 0.1;
%     LinearFilterSpace_InvariantModel.rand_std = 1/10;
%     LinearFilterSpace_InvariantModel.filter_type ='Degrading Circle';
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;
    interface_params =  SetSliderParams('Set radius of circular spectral mask', 1, 0, LinearFilterSpace_InvariantModel.RD , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RD',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set internal radius of ring spectral mask', LinearFilterSpace_InvariantModel.RE, 0, LinearFilterSpace_InvariantModel.RI , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RI',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set external radius of ring spectral mask', 1, 0.01, LinearFilterSpace_InvariantModel.RE , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'RE',@update_sliders), interface_params, k);
%     k=k+1;
%     interface_params(k).style = 'buttongroup';
%     interface_params(k).title = 'Choose Filter Type (Frequency Domain)';
%     interface_params(k).selection ={ 'Degrading Circle', 'Ring' };   
%     interface_params(k).callback = @(a,b)ChooseFilterType(a,b,handles);  

    
    
    
    
    
    
    
    
    

    LinearFilterSpace_InvariantModel.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
     

    process_image( LinearFilterSpace_InvariantModel.RI, LinearFilterSpace_InvariantModel.RE, LinearFilterSpace_InvariantModel.RD, ...
    LinearFilterSpace_InvariantModel.axes_1, LinearFilterSpace_InvariantModel.axes_2, LinearFilterSpace_InvariantModel.axes_3, LinearFilterSpace_InvariantModel.axes_4);
end



function update_sliders(handles)
    if ( ~isstruct(handles))
		handles = guidata(handles);
    end
    val = min(handles.(handles.current_experiment_name).RI, handles.(handles.current_experiment_name).RE);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider3');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', handles.(handles.current_experiment_name).RE);
    set(slider_handle, 'sliderstep', [1/100, 1/100]);
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value3');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText3');
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
    LinearFilterSpace_InvariantModel = handles.(handles.current_experiment_name);
    process_image( LinearFilterSpace_InvariantModel.RI, LinearFilterSpace_InvariantModel.RE, LinearFilterSpace_InvariantModel.RD, ...
    LinearFilterSpace_InvariantModel.axes_1, LinearFilterSpace_InvariantModel.axes_2, LinearFilterSpace_InvariantModel.axes_3, LinearFilterSpace_InvariantModel.axes_4);
end

function process_image( RI, RE, RD,axes_1, axes_2, axes_3, axes_4)

    delete(get(axes_1, 'children'));
    delete(get(axes_2, 'children'));
    delete(get(axes_3, 'children'));
    im_size = 256;
    rand_std = 128;
    im = fft2(randn(im_size));
    im = rand_std*real(im)/std(real(im(:)),1) + 1i*rand_std*imag(im)/std(imag(im(:)), 1) ;

%     imshow(abs(fftshift(ifft2(im))), [], 'parent', axes_1);
%     DisplayAxesTitle( axes_1,{ 'Initial Gaussian random field'}, 'TM');
%     switch filter_type


%     case 'Degrading Circle'
        R=RD*im_size.^2;
        r=radius_mb(im_size/2);
        mask=exp(-(r.^2)/R);
        mask = 255*mask;
        mask_r = fftshift(mask);
%         mask_r = mask;
        imshow(fftshift(mask_r), [], 'parent', axes_1);
        
%     case 'binary Circle'                
%         mask=255*ones(im_size);CX=im_size/2+1;CY=im_size/2+1;
%         [x,y] = meshgrid(1:im_size, 1:im_size);
%         mask(((x-CX).^2 + (y-CY).^2)>(RD*im_size/2).^2) = 0;
%         mask_r = fftshift(mask);
%         imshow(fftshift(mask_r), [], 'parent', axes_1);        
        
%         DisplayAxesTitle( axes_2,{ '''Degrading Circle'' filter frequency response', ['R = ' num2str(R)]}, 'TM');
        DisplayAxesTitle( axes_1,{ 'Degrading Circle', ['R = ' num2str(RD)]}, 'TM');
%     case 'Ring'
        mask=255*ones(im_size);CX=im_size/2+1;CY=im_size/2+1;
        [x,y] = meshgrid(1:im_size, 1:im_size);
        mask(((x-CX).^2 + (y-CY).^2)<(RI*im_size/2).^2) = 0;
        mask(((x-CX).^2 + (y-CY).^2)>(RE*im_size/2).^2) = 0;
        mask_ri_re = fftshift(mask);
        imshow(fftshift(mask_ri_re), [], 'parent', axes_2);
        DisplayAxesTitle( axes_2,{ 'Ring spectral mask', ['R_{internal} = ' num2str(RI) ', R_{exsternal} = ' num2str(RE)]}, 'TM');
%     end

    imshow(real(ifft2(im.*mask_r)), [], 'parent', axes_3);
    DisplayAxesTitle( axes_3,{ 'pseudo-random pattern with circular spectrum'}, 'BM');
    imshow(real(ifft2(im.*mask_ri_re)), [], 'parent', axes_4);
    DisplayAxesTitle( axes_4,{ 'pseudo-random pattern with ring-shaped spectrum'}, 'BM');
end
    
function I = im_p(im )
    P = sum(im(:)>=0.5)/length(im(:));
    I= rand(size(im,1), size(im,2));
    I = (I<P);
    I = I(ceil(size(im,1)/2), ceil(size(im,2)/2));
end



