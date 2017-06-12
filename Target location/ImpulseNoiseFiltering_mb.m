function ImpulseNoiseFiltering = ImpulseNoiseFiltering_mb( handles )
%% ImpulseNoiseFiltering
% Tasks:
%%
% 8.1 Target ImpulseNoiseFiltering in white noise
% Generate two test target images of the same energy: sharp and smooth ones. 
% Generate test image with targets on uniform background. 
% Write a program that adds to the test image a Gaussian noise of different variance. 
% Implements matched filters for each target, measures ImpulseNoiseFiltering error and can be run repeatedly to measure RMS of the ImpulseNoiseFiltering
% error over a set of experiments and to compute ImpulseNoiseFiltering error histogram. 
% Perform statistical experiment to compute distribution histogram of the ImpulseNoiseFiltering error and to
% determine how RMS of the ImpulseNoiseFiltering error depends on the SNR. Observe and explain
% the threshold effect in the ImpulseNoiseFiltering reliability. Compare ImpulseNoiseFiltering error for the two
% test target images.
% 8.2 Target ImpulseNoiseFiltering in correlated noise
% Repeat the same for correlated Gaussian noise of the same intensity. For target
% ImpulseNoiseFiltering, modify appropriately matched filter to implement optimal filter. For
% generating correlated Gaussian noise, use results of the Lab. 6. Compare RMS of the
% ImpulseNoiseFiltering error with corresponding results for white noise of the same intensity.
%
% Instructions:
%
% pseudo code:
%
% 

   handles = guidata(handles.figure1);
   axes_hor = 2;
   axes_ver = 2;
   button_pos = get(handles.pushbutton12, 'position');
   bottom =button_pos(2);
   left = button_pos(1)+button_pos(3);
        ImpulseNoiseFiltering = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);


    
    %% initial params
    ImpulseNoiseFiltering.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    ImpulseNoiseFiltering.p = 0.15;
    ImpulseNoiseFiltering.Threshold = 15;
    ImpulseNoiseFiltering.delta = 10;
    ImpulseNoiseFiltering.iter = 3;
    
    % Noise param slider
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);

    k=k+1;
    interface_params =  SetSliderParams( 'Noise detection threshold', 50, 0, ImpulseNoiseFiltering.Threshold, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Threshold',@update_sliders), interface_params, k);             

    k=k+1;
    interface_params =  SetSliderParams(  'Edge preserving delta (recurs. filter)', 50, 0, ImpulseNoiseFiltering.delta,1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'delta',@update_sliders), interface_params, k);             
    
    k=k+1;
    interface_params =  SetSliderParams(  'Number of iterations (iter. filter)', 10, 0, ImpulseNoiseFiltering.iter, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'iter',@update_sliders), interface_params, k);             
    
    k=k+1;  
    interface_params =  SetSliderParams(  'Probability of impulse noise ', 1, 0, ImpulseNoiseFiltering.p, 0.05, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'p',@update_sliders), interface_params, k);             
  
    
    
    
    
    
    
    
    
    
    
    

    ImpulseNoiseFiltering.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
         
    process_image(    ImpulseNoiseFiltering.im, ...
                        ImpulseNoiseFiltering.p, ...
                        ImpulseNoiseFiltering.Threshold, ...
                        ImpulseNoiseFiltering.delta, ...
                        ImpulseNoiseFiltering.iter, ...
                        ImpulseNoiseFiltering.axes_1, ...
                        ImpulseNoiseFiltering.axes_2, ...
                        ImpulseNoiseFiltering.axes_3, ...
                        ImpulseNoiseFiltering.axes_4);


end




function process_image( im, p, thr, delta, Niter,  axes_1, axes_2, axes_3, axes_4)
%%
imshow(uint8(im), [0 255], 'parent', axes_1);
DisplayAxesTitle( axes_1, ['Test image'],'TM',10); 

[SzX, SzY]=size(im);
noisemask=rand(SzX,SzY)<p;
im=(ones(SzX,SzY)-noisemask).*im+256*rand(SzX,SzY).*noisemask;

imshow(uint8(im), [0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, {['Test image with impulse Nnoise'], ['P = ' num2str(p)]},'TM',10); 

mask=[0.1 0.15 0.1;0.15 0 0.15;0.1 0.15 0.1];
OUTIMG=im;
for t=1:Niter
    smth=conv2(OUTIMG,mask,'same');
    diff=abs(OUTIMG-smth);
	corrmask=diff>(128*(Niter-t)+thr*(t-1))/(Niter-1);
	OUTIMG=OUTIMG.*(1-corrmask)+smth.*corrmask;
end
% thr = 255*thr;
% delta = 255*delta;
imshow(uint8(OUTIMG), [0 255], 'parent', axes_3);
DisplayAxesTitle( axes_3, ['Iterative impulse noise filtering'],'BM',10); 
%% filtim_r.m

[SzX SzY]=size(im);
INPIMG = double(im);
OUTIMG = INPIMG;
for y=2:SzY,
	diff=INPIMG(1,y)-OUTIMG(1,y-1);
	signdiff=sign(diff);
	absdiff=abs(diff); 
    if absdiff>thr
        OUTIMG(1,y)=OUTIMG(1,y-1)+delta*signdiff;
    end
end
%---------------------- Remaining rows-------------------------------
for x=2:SzX
    for y=2:SzY-1
        smth=0.3*(OUTIMG(x,y-1)+OUTIMG(x-1,y))+0.2*(OUTIMG(x-1,y-1)+OUTIMG(x-1,y+1));
        diff=INPIMG(x,y)-smth;
        signdiff=sign(diff);
        absdiff=abs(diff); 
        if absdiff>thr,
            OUTIMG(x,y)=smth+delta*signdiff;
        end
    end
    % Last pixel in row
    y=SzY;
	smth=0.35*(OUTIMG(x,y-1)+OUTIMG(x-1,y))+0.3*OUTIMG(x-1,y-1);
	diff=INPIMG(x,SzY)-smth;	
	signdiff=sign(diff);
	absdiff=abs(diff); 
    if absdiff>thr, 
        OUTIMG(x,SzY)=smth+delta*signdiff;
    end

end
OUTIMG=round(OUTIMG);	
imshow(uint8(OUTIMG), [0 255], 'parent', axes_4);
DisplayAxesTitle( axes_4, ['Recursive impulse noise filtering'],'BM',10); 
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


  ImpulseNoiseFiltering = handles.(handles.current_experiment_name);
    process_image(    ImpulseNoiseFiltering.im, ...
                        ImpulseNoiseFiltering.p, ...
                        ImpulseNoiseFiltering.Threshold, ...
                        ImpulseNoiseFiltering.delta, ...
                        ImpulseNoiseFiltering.iter, ...
                        ImpulseNoiseFiltering.axes_1, ...
                        ImpulseNoiseFiltering.axes_2, ...
                        ImpulseNoiseFiltering.axes_3, ...
                        ImpulseNoiseFiltering.axes_4);
end
