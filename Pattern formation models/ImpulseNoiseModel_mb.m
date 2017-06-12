function ImpulseNoiseModel = ImpulseNoiseModel_mb( handles )
% 8.3 Image registration
% Write a program for alignment; using matched filtering, images arbitrarily displaced in both co-ordinates. Use for experiments video frames or stereo images.
    handles = guidata(handles.figure1);
    axes_hor = 2;
    axes_ver = 2;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    ImpulseNoiseModel = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9);
    % initial params
    ImpulseNoiseModel.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    ImpulseNoiseModel.probability = 0.5;
    ImpulseNoiseModel.thr = 0.01;      
    %
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;
    interface_params =  SetSliderParams('Set Probability of impulse', 1, 0, ImpulseNoiseModel.probability , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'probability',@update_sliders), interface_params, k);
    k=k+1;

    interface_params =  SetSliderParams('Set Threshold for noise detection', 0.1, 0, ImpulseNoiseModel.thr , 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'thr',@update_sliders), interface_params, k);
    k=k+1;
    
    
    
    
    
    
    
    
    

    ImpulseNoiseModel.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
         



    process_image(ImpulseNoiseModel.im,ImpulseNoiseModel.probability,    ImpulseNoiseModel.thr, ...
    ImpulseNoiseModel.axes_1, ImpulseNoiseModel.axes_2, ImpulseNoiseModel.axes_3, ImpulseNoiseModel.axes_4);

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



ImpulseNoiseModel = handles.(handles.current_experiment_name);

    process_image(ImpulseNoiseModel.im,ImpulseNoiseModel.probability,    ImpulseNoiseModel.thr, ...
    ImpulseNoiseModel.axes_1, ImpulseNoiseModel.axes_2, ImpulseNoiseModel.axes_3, ImpulseNoiseModel.axes_4);
end
function process_image(im, probability, thr, ...
    axes_1, axes_2, axes_3, axes_4)
     %%   
    delete(get(axes_1, 'children'));
    delete(get(axes_2, 'children'));
    delete(get(axes_3, 'children'));
    delete(get(axes_4, 'children'));
    imshow(im, [0 255],  'parent', axes_1); 
    DisplayAxesTitle( axes_1, ['Input Image'], 'TM');  

     %%   

    [SzX SzY]=size(im);
    noisemask=rand(SzX,SzY)<probability;
    im_w_noise=(ones(SzX,SzY)-noisemask).*im+256*rand(SzX,SzY).*noisemask;

    imshow(im_w_noise, [0 255],  'parent', axes_2); 
    DisplayAxesTitle( axes_2, ['Image with impulse noise, P = ' num2str(probability)], 'TM');  
    %%
    [SzX SzY]=size(im_w_noise);
    sp=fft(im_w_noise');
    sp2=abs(sp).^2;
    sp1d_im_w_noise=(sum(sp2'));
    sp1d_im_w_noise = sp1d_im_w_noise(1:round(SzX/2) + 1);
    sp1dsm=monotone_mb(sp1d_im_w_noise,thr);
    sp1d_noise=sp1d_im_w_noise-sp1dsm;
    
    sp=fft(im');
    sp2=abs(sp).^2;
    sp1d_im=(sum(sp2'));
    sp1d_im =sp1d_im(1:round(SzX/2) + 1);
    plot( sp1d_im.^0.3, 'parent', axes_3, 'color', 'g', 'LineStyle', '-', 'Marker', '*', 'linewidth', 2); hold(axes_3, 'on');
    plot( sp1d_im_w_noise.^0.3, 'parent', axes_3, 'color', 'r', 'LineStyle', '-', 'Marker', '.', 'linewidth', 2); hold(axes_3, 'on');
    plot( sp1d_noise.^0.3, 'parent', axes_3, 'color', 'b', 'LineStyle', '-', 'Marker', '+', 'linewidth', 2);
    set(axes_3, 'XLim', [1 50]);
    h_l = legend(axes_3, 'Test Image Spectrum', 'Noisy Image Spectrum', 'Noise Only Spectrum');
    set(h_l, 'fontsize', 8);
    grid(axes_3, 'on');
    DisplayAxesTitle( axes_3, ['Power spectrum'], 'BM');  
    
    

%OUTIMG=sp1d(1:SzX/2+1)-sp1dsm;

   %% noise spectrum
    
    [OUT cor_im]=noisevar_mb(im);
    [OUT cor_im_w_noise]=noisevar_mb(im_w_noise);
    plot([-floor(length(cor_im)/2) : floor(length(cor_im)/2) - 1], fftshift(cor_im), 'parent', axes_4, 'color' , 'b', 'linewidth', 2); hold(axes_4, 'on');
    plot([-floor(length(cor_im_w_noise)/2) : floor(length(cor_im_w_noise)/2) - 1], fftshift(cor_im_w_noise), 'parent', axes_4, 'color', 'g', 'linewidth', 2); hold(axes_4, 'on');
    h_l = legend(axes_4, 'Test Image Correlation', 'Noisy Image Correlation');
    set(h_l, 'fontsize', 8);
    grid(axes_4, 'on');
    DisplayAxesTitle( axes_4, ['Auto-correlation function'], 'BM');

end
    


