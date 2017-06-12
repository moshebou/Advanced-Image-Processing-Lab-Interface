%% Block Transform Coding
%  Study of transform coding methods: DCT, Walsh transform coding  
%% Experiment Description:
% This experiment illustrates DCT and Walsh block transform coding.
%% Tasks: 
% 4.1.1
%
% Investigate DCT image coding efficiency for different images and
% different coding parameters (program dctcodng.m). Observe artifacts due
% to the block size and coding mask size. Optimize non-linear P-th law
% quantization of spectral coefficients. 
%
% 4.1.2 
%
% Investigate 2-D Walsh transform image coding efficiency for different
% images and different coding parameters (program walsh_codng.m). Observe
% artifacts due to the block size and coding mask size. Optimize non-linear
% P-th law quantization of spectral coefficients.
%
%% Instruction:
% Use the 'Set Mean of Original Image' and 'Set Std of Original Image' slider to set the input image mean and standard deviation.
% 
% Use the  'Load Auxiliary Image' icon on the tool bar to change the
% auxiliary image used for the histogram matching.
% auxiliary image used.
%% Theoretical Background & algorithm:

%%


function BlockTransformCoding = BlockTransformCoding_mb( handles )
%BLOCKTRANSFORMCODING_MB Summary of this function goes here
%Detailed explanation goes here

	handles = guidata(handles.figure1);
	axes_hor = 3;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	BlockTransformCoding = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);
	% initial params

	BlockTransformCoding.SzW = 8;
	BlockTransformCoding.Q = 7;    
	BlockTransformCoding.SzM = 100;
	BlockTransformCoding.P_dct = 0.5;
    BlockTransformCoding.P_walsh = 0.5;
    BlockTransformCoding.LpfType = 'Rectangular';
	BlockTransformCoding.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
	%
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Find min RMS P';
	interface_params(k).callback = @(a,b)find_min_rms_p(handles.figure1);
	k=k+1;
	interface_params =  SetSliderParams('The number of bits per transform coefficient', 8, 1, BlockTransformCoding.Q, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Q',@update_sliders), interface_params, k);             
	k=k+1;
	interface_params =  SetSliderParams('Size Of Coding Mask (% of window size)', 100, 0, BlockTransformCoding.SzM, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzM',@update_sliders), interface_params, k);             
	k=k+1;                   
	interface_params =  SetSliderParams('Window Size', 2.^[1:6], 1, log2(BlockTransformCoding.SzW), 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzW',@update_sliders, 2.^[1:6]), interface_params, k);             
	k=k+1;            
	interface_params =  SetSliderParams('Set P for P-law DCT Quantization', 1, 0, BlockTransformCoding.P_dct, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'P_dct',@update_sliders), interface_params, k);              
	k=k+1;            
	interface_params =  SetSliderParams('Set P for P-law Walsh Quantization', 1, 0, BlockTransformCoding.P_walsh, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'P_walsh',@update_sliders), interface_params, k);              
    k = k+1;
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose LPF type';
    interface_params(k).selection ={ 'Rectangular', 'Circular'};   
    interface_params(k).callback = @(a,b)ChooseLpfType(a,b,handles);
    
          


	BlockTransformCoding.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		 
        
	process_image(BlockTransformCoding.im, BlockTransformCoding.SzW, BlockTransformCoding.SzM , BlockTransformCoding.Q , ...
	BlockTransformCoding.P_dct, BlockTransformCoding.P_walsh, BlockTransformCoding.LpfType, ...
	BlockTransformCoding.axes_1, BlockTransformCoding.axes_2, BlockTransformCoding.axes_3, BlockTransformCoding.axes_4, BlockTransformCoding.axes_5, BlockTransformCoding.axes_6);


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
    BlockTransformCoding = handles.(handles.current_experiment_name);
	process_image(BlockTransformCoding.im, BlockTransformCoding.SzW, BlockTransformCoding.SzM , BlockTransformCoding.Q , ...
	BlockTransformCoding.P_dct, BlockTransformCoding.P_walsh, BlockTransformCoding.LpfType,...
	BlockTransformCoding.axes_1, BlockTransformCoding.axes_2, BlockTransformCoding.axes_3, BlockTransformCoding.axes_4, BlockTransformCoding.axes_5, BlockTransformCoding.axes_6);
end


function process_image(im, SzW, SzM, Q,P_dct, P_walsh, lpf_type, ...
    axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
h = waitbar(0, 'please wait');
Q = 2^Q;
% Generation of the coding mask
[X, Y] = meshgrid(1:SzW, 1:SzW);
mask=zeros(SzW);
if( strcmpi ( lpf_type, 'Rectangular'))
    mask((X<= SzM*SzW/100)& (Y<= SzM*SzW/100) ) = 1;
elseif ( strcmpi ( lpf_type, 'Circular'))
    mask(sqrt((X-1).^2+ (Y-1).^2) <= SzM*SzW/100 ) = 1;
end
relative_size = sum(mask(:))/(SzW*SzW);
% SzM = round(SzM*SzW/100);
% if ( SzW == SzM ) 
%     mask(:) = 1;
% else
%     mask(1:SzM+1, 1:SzM+1) = flipud(tril(ones(SzM+1,SzM+1),-1));
% end




n=log2(SzW);
WALSH = walsh_mb(n)/sqrt(SzW);
DCT   = dctmtx(SzW);
for j = 1 : SzW:size(im,2)
    for i = 1 : SzW:size(im,1)
        fragment = im(i:i+SzW-1, j:j+SzW-1);
        % walsh
        frgmsp = WALSH*fragment*WALSH';
        frgmsp_sign = sign(frgmsp); 
        abs_frgmsp=abs(frgmsp);
        mx=max(frgmsp(:));
        abs_frgmsp_q = mx.*((round(Q*((abs_frgmsp./mx).^P_walsh))/Q).^(1/P_walsh));
        frgmsp_res = mask.*frgmsp_sign.*abs_frgmsp_q;
        walsh_im(i:i+SzW-1, j:j+SzW-1) = WALSH*frgmsp_res*WALSH';
        % dct
        frgmsp = DCT*fragment*DCT';
        frgmsp_sign = sign(frgmsp);
        abs_frgmsp=abs(frgmsp);
        mx=max(frgmsp(:));
        abs_frgmsp_q = mx.*((round(Q*((abs_frgmsp./mx).^P_dct))/Q).^(1/P_dct));
        frgmsp_res = mask.*frgmsp_sign.*abs_frgmsp_q;
        dct_im(i:i+SzW-1, j:j+SzW-1) = DCT'*frgmsp_res*DCT;
    end
end

waitbar(0.67, h);



imshow(im, [ 0 255], 'parent', axes_1);
DisplayAxesTitle( axes_1, [ 'Test image'], 'TM',10);  
Error_DCT=im-dct_im;
Error_DCT_std=sqrt(mean(Error_DCT(:).^2)-(mean(Error_DCT(:))).^2);
imshow(dct_im, [ 0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, {[ 'Block-DCT restored image, P=' num2str(P_dct)], ...
    ['bits per pixel = ' num2str(relative_size*log2(Q), '%0.2f')]},'TM',10);  
imshow(Error_DCT, [ ], 'parent', axes_3);
DisplayAxesTitle( axes_3, {[ 'Block-DCT coded restored image Error'], [ 'Error\_DCT\_std=',num2str(Error_DCT_std,3)]},'TM',10); 

imshow(walsh_im, [ 0 255], 'parent', axes_5);
Error_Walsh=im-walsh_im;
Error_Walsh_std=sqrt(mean(Error_Walsh(:).^2)-(mean(Error_Walsh(:))).^2);
DisplayAxesTitle( axes_5, {[ 'Block-Walsh coded restored image, P=' num2str(P_walsh) ], ['bits per pixel = ' num2str(relative_size*log2(Q), '%0.2f')]},'BM',10);  
imshow(Error_Walsh, [ ], 'parent', axes_6);
DisplayAxesTitle( axes_6, {[ 'Block-Walsh coded restored image Error'], ['Error\_Walsh\_std=',num2str(Error_Walsh_std,3)]},'BM',10);  

imshow(mask, 'parent', axes_4);
DisplayAxesTitle( axes_4, [ 'Coding Mask'], 'BM',10); 
waitbar(1, h);
delete(h);
end

function find_min_rms_p(figure_handle)    
    handles = guidata(figure_handle);
    im  = handles.(handles.current_experiment_name).im;
    SzW = handles.(handles.current_experiment_name).SzW;
    SzM = handles.(handles.current_experiment_name).SzM; 
    Q   = handles.(handles.current_experiment_name).Q;
    lpf_type = handles.(handles.current_experiment_name).LpfType;
    Q = 2^Q;
    rms_dct_min = inf;
    rms_Walsh_min = inf;
    h =waitbar(0, 'please wait');

    % Generation of the coding mask
    [X, Y] = meshgrid(1:SzW, 1:SzW);
    mask=zeros(SzW);
    if( strcmpi ( lpf_type, 'Rectangular'))
        mask((X<= SzM*SzW/100)& (Y<= SzM*SzW/100) ) = 1;
    elseif ( strcmpi ( lpf_type, 'Circular'))
        mask(sqrt((X-1).^2+ (Y-1).^2) <= SzM*SzW/100 ) = 1;
    end
    

    
    n=log2(SzW);
    WALSH = walsh_mb(n)/sqrt(SzW);
    DCT   = dctmtx(SzW);
    for p = 0.01:0.01:1;
        for j = 1 : SzW:size(im,2)
            for i = 1 : SzW:size(im,1)
                fragment = im(i:i+SzW-1, j:j+SzW-1);
                % walsh
                frgmsp = WALSH*fragment*WALSH';
                frgmsp_sign = sign(frgmsp); 
                abs_frgmsp=abs(frgmsp);
                mx=max(frgmsp(:));
                abs_frgmsp_q = mx.*((round(Q*((abs_frgmsp./mx).^p))/Q).^(1/p));
                frgmsp_res = mask.*frgmsp_sign.*abs_frgmsp_q;
                walsh_im(i:i+SzW-1, j:j+SzW-1) = WALSH*frgmsp_res*WALSH';
                % dct
                frgmsp = DCT*fragment*DCT';
                frgmsp_sign = sign(frgmsp);
                abs_frgmsp=abs(frgmsp);
                mx=max(frgmsp(:));
                abs_frgmsp_q = mx.*((round(Q*((abs_frgmsp./mx).^p))/Q).^(1/p));
                frgmsp_res = mask.*frgmsp_sign.*abs_frgmsp_q;
                dct_im(i:i+SzW-1, j:j+SzW-1) = DCT'*frgmsp_res*DCT;
            end
        end
        Error_Walsh=im-walsh_im;
        Error_Walsh_std=sqrt(mean(Error_Walsh(:).^2)-(mean(Error_Walsh(:))).^2);
        if (rms_Walsh_min>=Error_Walsh_std)
            rms_Walsh_min = Error_Walsh_std;
            p_Walsh_min = p;
        end

        Error_DCT=im-dct_im;
        Error_DCT_std=sqrt(mean(Error_DCT(:).^2)-(mean(Error_DCT(:))).^2);
        if (rms_dct_min>=Error_DCT_std)
            rms_dct_min = Error_DCT_std;
            p_dct_min = p;
        end
        waitbar(p, h);
    end
%     fragment = im2col(im, [SzW, SzW], 'distinct');
%     mask_col = mask(:)*ones(1, size(fragment,2));
%     % walsh
%     n=log2(SzW);
%     WALSH=walsh_mb(n)/sqrt(SzW);
%     frgmsp_WALSH = kron(WALSH, WALSH)*fragment;
%     frgmsp_sign_walsh = sign(frgmsp_WALSH);
%     abs_frgmsp_walsh=abs(frgmsp_WALSH);
%     mx_walsh=ones(size(frgmsp_WALSH,1), 1) *max(frgmsp_WALSH);
%     
%     % dct
%     frgmsp_dct = kron(dctmtx(SzW), dctmtx(SzW))*fragment;
%     frgmsp_sign_dct = sign(frgmsp_dct);        
%     abs_frgmsp_dct=abs(frgmsp_dct);
%     mx_dct=ones(size(frgmsp_dct,1), 1) *max(frgmsp_dct);
%     for p = 0.01:0.01:1;
%     %     walsh
%         abs_frgmsp_walsh_q = mx_walsh.*((round(Q*((abs_frgmsp_walsh./mx_walsh).^p))/Q).^(1/p));
%         frgmsp_res = mask_col.*frgmsp_sign_walsh.*abs_frgmsp_walsh_q;
%         OUTIMG_walsh = kron(WALSH, WALSH)*frgmsp_res;
%         walsh_im = col2im(OUTIMG_walsh, [SzW, SzW], size(im), 'distinct');
%         Error_Walsh=im-walsh_im;
%         Error_Walsh_std=sqrt(mean(Error_Walsh(:).^2)-(mean(Error_Walsh(:))).^2);
%         if (rms_Walsh_min>=Error_Walsh_std)
%             rms_Walsh_min = Error_Walsh_std;
%             p_Walsh_min = p;
%         end
% 
%         abs_frgmsp_q = mx_dct.*((round(Q*((abs_frgmsp_dct./mx_dct).^p))/Q).^(1/p));
%         frgmsp_res = mask_col.*frgmsp_sign_dct.*abs_frgmsp_q;
%         OUTIMG_dct = kron(dctmtx(SzW)', dctmtx(SzW)')*frgmsp_res;
%         dct_im = col2im(OUTIMG_dct, [SzW, SzW], size(im), 'distinct');
%                 
%         Error_DCT=im-dct_im;
%         Error_DCT_std=sqrt(mean(Error_DCT(:).^2)-(mean(Error_DCT(:))).^2);
%         if (rms_dct_min>=Error_DCT_std)
%             rms_dct_min = Error_DCT_std;
%             p_dct_min = p;
%         end
%         waitbar(p, h);
%     end
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider6');
    set(slider_handle, 'value', p_dct_min);
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value6');
    set(slider_title_handle, 'string', num2str(p_dct_min));
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider7');
    set(slider_handle, 'value', p_Walsh_min);
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value7');
    set(slider_title_handle, 'string', num2str(p_Walsh_min));
    close(h);    
    handles.(handles.current_experiment_name).P_dct = p_dct_min;
    handles.(handles.current_experiment_name).P_walsh = p_Walsh_min;
    guidata(figure_handle, handles);

    
    BlockTransformCoding = handles.(handles.current_experiment_name);
	process_image(BlockTransformCoding.im, BlockTransformCoding.SzW, BlockTransformCoding.SzM , BlockTransformCoding.Q , ...
	BlockTransformCoding.P_dct, BlockTransformCoding.P_walsh, BlockTransformCoding.LpfType,...
	BlockTransformCoding.axes_1, BlockTransformCoding.axes_2, BlockTransformCoding.axes_3, BlockTransformCoding.axes_4, BlockTransformCoding.axes_5, BlockTransformCoding.axes_6);
end

function ChooseLpfType(a,b,handles)

handles = guidata(a);
handles.(handles.current_experiment_name).LpfType = get(get(a, 'SelectedObject'), 'string');
guidata(a, handles);

end
