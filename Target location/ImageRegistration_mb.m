%% Image Registration
% Target Location and Object Detection in Cluttered Images
%% Experiment Description:
% Study of optimal adaptive linear filters for detection and localization of objects in
% cluttered images:
%
% # Comparison of the conventional matched filter and optimal adaptive
% correlators for target location on cluttered background.
% # Image “homogenization” for improving the correlational detection
% discrimination capability.
%
% This experiment demonstratet Signal de-noising capability of of local
% adaptive linear filters in the DCT domain, by supressing low enargy
% components.
%% Tasks:
% 8.3 Image registration
%
% Write a program for alignment, using matched filtering, images arbitrarily displaced in
% both co-ordinates. Use for experiments video frames or stereo images.
%% Instruction:
%% Theoretical Background:
% _Image Translation retrival usign matched filter in the frequancy domain_
%
% The basis of the Fourier-based motion estimation is the shift
% property[23] of the Fourier transform. Denote by:
%
% $$ 1.1 \hspace{0.5in} {\mathcal {F}}\{ f({x,y})\} = F({\omega_{x},\omega_{y}})$$
%
% The Fourier transform of $f(x,y)$ Then:
%
% $$1.2 \hspace{0.5in} {\mathcal {F}} \left\{ f\left( {x+\Delta x,y+\Delta y} \right) \right\}
% = {F}\left( {\omega_{x},\omega_{y}}\right) \cdot e^{j \left(
% {\omega_{x}\Delta x+\omega_{y}\Delta y} \right)}$$
%
% The latest equation can be used for the estimation of image translation. 
% Assume the images Formula and Formula satisfy
%
% $$1.3 \hspace{0.5in} I_{1}\left( {x+\Delta x,y+\Delta y}\right ) = I_{2}\left( {x,y}\right)$$
%
% Performing Fourier transform on both sides of the Equation, yielding:
%
% $$1.4 \hspace{0.5in} \mathcal {I}_{1}\left( {\omega_{x},\omega_{y}}\right) e^{j\left(
% {\omega _{x}\Delta x+\omega _{y}\Delta y}\right) }= \mathcal{I}_{2}\left( {\omega_{x},\omega_{y}}\right)$$
%
% and
%
% $$1.5 \hspace{0.5in} {{ \mathcal{I}{_{2}\left( {\omega_{x},\omega_{y}}\right) }}\over {
% \mathcal{I}{_{1}\left ( {\omega _{x},\omega _{y}}\right) }}}=e^{j\left(
% {\omega_{x}\Delta x+\omega_{y}\Delta y}\right)}$$
%
% Thus, the translation parameters $(\Delta x, \Delta y)$ can be estimated
% in the spatial domain by computing the inverse FFT of (1.5):
%
% $$1.6 \hspace{0.5in} {Corr}\left( {x,y}\right) = {\mathcal{F}}^{-1} \left\{e^{j\left(
% {\omega_{x}\Delta x+\omega_{y}\Delta y}\right)}\right\} = {\delta }
% \left( x+{\Delta x,y+\Delta y}\right)$$
%
% and finding the position of the maximum value of the correlation function
% $Corr(x,y)$:
%
% $$1.7 \hspace{0.5in} \left( {x,y}\right) =\arg {\max \limits_{\left( {
% \hat{x},\hat{y}}\right)}} \left\{ {Corr} \left( { {\hat{x}},
% {\hat{y}}}\right) \right\} $$
%
% Further robustness to intensity differences between the images is
% achieved using the normalized phase correlation:
%
% $$1.8 \hspace{0.5in} \widetilde{Corr}\left ( {\omega_{x},\omega_{y}}\right)
% =\frac{\widehat{I}_2 \left( {\omega_{x},\omega_{y}} \right)\left\vert
% \widehat{I}_1 \left(
% {\omega_{x},\omega_{y}}\right)\right\vert}{\left\vert
% \widehat{I}_{2}\left({\omega _{x},\omega _{y}}\right) \right\vert
% \widehat{I}_{1}\left({\omega _{x},\omega _{y}}\right)} =
% \frac{\widehat{I}_{2}\left( {\omega_{x},\omega _{y}}\right )
% \widehat{I}_{1}^* \left({\omega _{x},\omega _{y}}\right)}{\left\vert
% \widehat{I}_{2}\left( {\omega _{x},\omega _{y}}\right) \right\vert
% \left\vert \widehat{I}_{1}^{*}\left( {\omega _{x},\omega
% _{y}}\right)\right\vert} = e^{j\left ( {\omega _{x}\Delta x+\omega
% _{y}\Delta y}\right ) }$$
%
% where $*$ denotes the complex conjugate.
%
% $$ $$
%% Algorithm:
%% Reference:
% # <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_5.pdf L.
% Yaroslavsky, Image parameter estimation, Advanced Image Processing Lab: A
% Tutorial , EUSIPCO200, LECTURE 4.1>
% # <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/Adv_imProc_6.pdf
% L.Yaroslavsky, Target location in clutter, Advanced Image Processing Lab:
% A Tutorial , EUSIPCO200, LECTURE 4.2> 
% # A. Van der Lugt, Signal Detection by Complex Spatial Filtering, IEEE
% Trans., IT-10, 1964, No. 2, p. 139 
% # L.P. Yaroslavsky, The Theory of Optimal Methods for Localization of
% Objects in Pictures, In: Progress in Optics, Ed. E. Wolf, v. XXXII,
% Elsevier Science Publishers, Amsterdam, 1993
% # <http://www.cs.tau.ac.il/~amir1/PS/KELLER/fft_correlation2.pdf A.
% Averbuch, Y. Keller, “A unified approach to FFT based image registration”,
% submitted to the IEEE Trans. On Image Processing.>  
% # L. Yaroslavsky, Target Location: Accuracy, Reliability and Optimal
% Adaptive Filters, TICSP series, Tampere Int. Center for Signal
% processing, TTKK, Monistamo, 1999
function ImageRegistration = ImageRegistration_mb( handles )
% 8.3 Image registration
% Write a program for alignment; using matched filtering, images arbitrarily displaced in both co-ordinates. Use for experiments video frames or stereo images.



   handles = guidata(handles.figure1);


   axes_hor = 2;
   axes_ver = 2;
   button_pos = get(handles.pushbutton12, 'position');
   bottom =button_pos(2);
   left = button_pos(1)+button_pos(3);
        ImageRegistration = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);
      
    % initial params
    ImageRegistration.shift_x1 = 17;
    ImageRegistration.shift_y1 = 38;
    ImageRegistration.shift_x2 = 38;
    ImageRegistration.shift_y2 = 17;
    ImageRegistration.im1 = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    ImageRegistration.im2 = HandleFileList('load' , HandleFileList('get' , handles.image_index2));
    ImageRegistration.im3 = HandleFileList('load' , HandleFileList('get' , handles.image_index3));
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
    interface_params =  SetSliderParams(  'Set 2nd image X-axis shift from test image', 128, 0, ImageRegistration.shift_x1, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'shift_x1',@update_sliders), interface_params, k);             
    k=k+1;  	
    interface_params =  SetSliderParams(  'Set 2nd image Y-axis shift from test image', 128, 0, ImageRegistration.shift_y1, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'shift_y1',@update_sliders), interface_params, k);             
	k=k+1;
    interface_params =  SetSliderParams(  'Set 3rd image X-axis shift from test image', 128, 0, ImageRegistration.shift_x2, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'shift_x2',@update_sliders), interface_params, k);             
    k=k+1;  	
    interface_params =  SetSliderParams(  'Set 3rd image Y-axis shift from test image', 128, 0, ImageRegistration.shift_y2, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'shift_y2',@update_sliders), interface_params, k);             
     
    
    
    
    
    
    
    
    
    

    ImageRegistration.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
         

    process_image(ImageRegistration.im1 , ...
        ImageRegistration.im2 , ...
        ImageRegistration.im3 , ...
        ImageRegistration.shift_x1, ...
        ImageRegistration.shift_y1, ...
        ImageRegistration.shift_x2, ...
        ImageRegistration.shift_y2, ...
        ImageRegistration.axes_1, ...
        ImageRegistration.axes_2, ...
        ImageRegistration.axes_3, ...
        ImageRegistration.axes_4);
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
    ImageRegistration = handles.(handles.current_experiment_name);
    process_image(ImageRegistration.im1 , ...
        ImageRegistration.im2 , ...
        ImageRegistration.im3 , ...
        ImageRegistration.shift_x1, ...
        ImageRegistration.shift_y1, ...
        ImageRegistration.shift_x2, ...
        ImageRegistration.shift_y2, ...
        ImageRegistration.axes_1, ...
        ImageRegistration.axes_2, ...
        ImageRegistration.axes_3, ...
        ImageRegistration.axes_4);
end

function process_image(im1, im2, im3, sft_x1, sft_y1, sft_x2, sft_y2, axes_1, axes_2, axes_3, axes_4)
    im_res = zeros(size(im1,1)+max(sft_y1, sft_y2), size(im1,2)+max(sft_x1,sft_x2), 3);
    im_res(1:size(im1,1), 1:size(im1,2), 1) = im1;
    %im_res(1:size(im,1), 1:size(im,2), 2) = im;
    %im_res(1:size(im,1), 1:size(im,2), 3) = im;

    %im_res(sft_y+1:(sft_y+size(im,1)), sft_x+1:(sft_x+size(im,2)), 1) = im;
    im_res(sft_y1+1:(sft_y1+size(im2,1)), sft_x1+1:(sft_x1+size(im2,2)), 2) = im2;
    im_res(sft_y2+1:(sft_y2+size(im3,1)), sft_x2+1:(sft_x2+size(im3,2)), 3) = im3;
    %im_res(sft_y+1:(sft_y+size(im,1)), sft_x+1:(sft_x+size(im,2)), 3) = im;
    im_12 = im1(1:end-sft_y1, 1:end-sft_x1);
    im_2 = im2(sft_y1+1:end, sft_x1+1:end);
    im_13 = im1(1:end-sft_y2, 1:end-sft_x2);
    im_3 = im3(sft_y2+1:end, sft_x2+1:end);
    imshow(uint8(im_res), [0 255], 'parent', axes_1);
    title(axes_1, {['Test image (red) and shifted image (green)',  ...
    [num2str(100*(size(im1,1)-sft_y1)*(size(im1,2)-sft_x1)/(size(im1,2)*size(im1,1)), '%.2f'), '% overlap']], ...
    ['Test image (red) and shifted image (blue)',  ...
    [num2str(100*(size(im1,1)-sft_y2)*(size(im1,2)-sft_x2)/(size(im1,2)*size(im1,1)), '%.2f'), '% overlap']]},...
    'fontsize', 10, 'fontweight', 'bold');
    %     imshow(im_2, [0 255], 'parent', axes_2);
    %     title(axes_2, 'Shifted Image', 'fontsize', 12, 'fontweight', 'bold');   
    %     R = fftshift((Ga.*conj_Gb)./abs(Ga.*conj_Gb));     
    %       R = fftshift((Ga.*Gb)/abs(Ga.*Gb));
    %     r = abs(r);
    Ga = fft2(im_12);
    Gb = fft2(im_2);
    conj_Gb = conj(Gb);
    R = Ga.*conj_Gb;
    r= ifft2(R);
    r = 255*(r-min(r(:)))/(max(r(:)) -min(r(:)));

    axes_children = get(axes_2,'children');     
    for i=1:length(axes_children)
        if ( strcmpi(get(axes_children(i), 'Type'),'text')||strcmpi(get(axes_children(i), 'Type'),'line'))
            delete( axes_children(i));
        end
    end
    delete(get(axes_2, 'children'));
    imshow(r, [], 'parent', axes_2); 
    DisplayAxesTitle(axes_2, 'Cross-correlation of red and green images', 'TM');
    X = locatmax_mb(r)-1;
    Y = X(1); X = X(2);
    hold(axes_2, 'on');
    plot(X,Y,'ro', 'parent', axes_2);     
    text(X,Y,[' \leftarrow \DeltaX =' num2str(X) ' \DeltaY=' num2str(Y)],'FontSize',12, 'parent', axes_2, 'HorizontalAlignment','left', 'color', 'w');
    hold(axes_2, 'off');
    im_reg = zeros(size(im1, 1), size(im1,2), 3);
    im_reg(:,:,1) = im1;
    im_reg(Y+1:size(im_2, 1)+Y, X+1:size(im_2, 2)+X, 2) = im_2;
    Ga = fft2(im_13);
    Gb = fft2(im_3);
    conj_Gb = conj(Gb);
    R = Ga.*conj_Gb;
    r= ifft2(R);
    r = 255*(r-min(r(:)))/(max(r(:)) -min(r(:)));

    axes_children = get(axes_3,'children');     
    for i=1:length(axes_children)
        if ( strcmpi(get(axes_children(i), 'Type'),'text')||strcmpi(get(axes_children(i), 'Type'),'line'))
            delete( axes_children(i));
        end
    end
    delete(get(axes_3, 'children'));
    imshow(r, [], 'parent', axes_3); 
    DisplayAxesTitle(axes_3, 'Cross-correlation of red and blue images', 'BM');
    X = locatmax_mb(r)-1;
    Y = X(1); X = X(2);
    hold(axes_3, 'on');
    plot(X,Y,'ro', 'parent', axes_3);     
    text(X,Y,[' \leftarrow \DeltaX =' num2str(X) ' \DeltaY=' num2str(Y)],'FontSize',12, 'parent', axes_3, 'HorizontalAlignment','left', 'color', 'w');
    hold(axes_2, 'off');
    im_reg(Y+1:size(im_3, 1)+Y, X+1:size(im_3, 2)+X, 3) = im_3;
    
    imshow(uint8(im_reg), 'parent', axes_4);
    DisplayAxesTitle(axes_4, '3 images registered', 'BM');
 end
