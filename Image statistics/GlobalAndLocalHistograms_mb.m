%% Global Histogram - Local Histogram
%  Image discrete representation in different discretization bases   
%% Experiment Description:
% This experiment introduce 2-D Fourier, Discrete Cosine, Walsh and Haar
% transforms, and the effect of zeroing coefficients have on the reconstructed (inverse transformed)image. 
%
% Four reconstructed images are presented, one for each transform, after
% the coefficients with the smallest value are zeroed, to satisfy the energy
% threshold requirement.
%% Tasks:
%
% 1.1 Image discrete representation in different discretization bases
%
% Investigate how the accuracy of image discrete representation in different
% discretization bases depends on the representation volume and on the type of the
% discretization transform.
%
% For Discrete Fourier Transform, Discrete Cosine Transform, Walsh Transform, Haar Transform bases,
% set to zero transform coefficients whose magnitude is lower than a certain threshold. 
%
% Use the threshold as a varying parameter.
% Measure total energy of the zeroed coefficients relative to the entire energy of the
% coefficients and their percentage with respect to all coefficients and observe how quality
% of the reconstructed image depends on this percentage and on the discretization basis.
%
% Compare image reconstruction RMS error for different bases given the same percentage
% of the zeroed coefficients. 
%
%% Instruction:
% Use the 'Set Energy Threshold' slider to set the energy level of the zeroed coefficients. 
%  
%% Theoretical Background:
% *_Discrete Fourier Transform:_*
%
% _DFT  Transform-_
%
% $$ X(m,n) = \sum_{y=1}^{height}\sum_{x=1}^{width}I(x,y)e^{\frac{-2i(y-1)(n-1)\pi}{height}}e^{\frac{-2i(x-1)(m-1)\pi}{width}}$$ 
%
% _Inverse DFT  Transform-_
%
% $$ I(x,y) = \frac{1}{height*width}\sum_{y=1}^{height}\sum_{x=1}^{width}X(m,n)e^{\frac{2i(y-1)(n-1)\pi}{height}}e^{\frac{2i(x-1)(m-1)\pi}{width}}$$ 
%
% *_Discrete Cosine Transform:_*
%
% _DCT Transform-_
% 
% $$X[n,m] = a[n]\cdot a[m] \sum_{x=1}^{width} \sum_{y=1}^{height} I(x,y)\cos\left(\frac{
% (2x-1)(n-1)\pi}{2\cdot width}\right)\cos\left(\frac{(2y-1)(m-1)\pi}{2 \cdot height}\right)$$
% 
% $$for \;(n=1,\cdots,width) \;\;\;\;(m=1,\cdots,height) $$
%
% _Inverse DCT-_
%
% $$x[m] = \sum_{n=0}^{N-1} a[n]
% X[n]\;\cos\left(\frac{(2m+1)n\pi}{2N}\right)\;\;\;\;\;\;\;(m=0,\cdots,N-1)$$
%
%
% Where:
%
% $$a[n]=\left\{ \begin{array}{ll} \sqrt{1/N} & \;\;n=0 \\ \sqrt{2/N}
% &\;\;n=1,2,\cdots \end{array} \right.$$
%
% _*Walsh-Hadamard Transform:*_
%
% The Hadamard transform $Hm$ is a 2mX2m matrix, the Hadamard matrix (scaled by a normalization factor), that transforms 2m real numbers xn into 2m real numbers Xk. 
%
% The Hadamard transform can be defined in two ways: recursively, or by using the binary (base-2) representation of the indices n and k.
% Recursively, we define the 1X1 Hadamard transform H0 by the identity H0 = 1, and then define Hm for m > 0 by:
%
% $$Hm = \sqrt{2} \left(\begin{array}{ccc} H_{m-1} & H_{m-1}\\ H_{m-1} & -H_{m-1}\end{array}\right)$$
%
% _The Walsh-Hadamard transform:_
%
% $$X(m,n) =H_{height} \cdot I \cdot H_{width}$$
% 
% _The Walsh-Hadamard inverse transform:_
%
% $I(x,y) =H_{height} \cdot X \cdot H_{width}$
%
% The inverse Hadamard transform is the same as the forward transform.
%
% _*Haar Transform*_
%
% The Haar transform matrix ${\bf H}$is a NxN matrix of real and orthogonal vectors. It can be defined as:
% 
% $$ h[1,1:N]= \frac {1}{ \sqrt{N} }$$
%
% $$ h[k , l]= \frac {1}{ \sqrt{N} } \cdot \left\{ \begin{array}{ll} 2^{ \frac {p}{2}}& \frac {N \cdot (q-1)}{2^p} \le l < \frac {N \cdot (q-0.5)}{2^p} \\ -2^{ \frac {p}{2}} &
% \frac {N \cdot (q-0.5)}{2^p} \le l < \frac{N \cdot q}{2^p} \\ 0 & \mbox{otherwise} \end{array} \right. $$
% 
% Where $p$, $q$  are calculated for each $k$:
%
% $$k=2^p+q-1$$
%
% For any value of $k\ge 0$, $p$ and $q$ are uniquely determined so that
% $2^p$ is the largest power of 2 contained in $k$ ($2^p<k$) and $q-1$ is
% the remainder $q-1=k-2^p$. 
%
% From the definition, it can be seen that $p$ determines the amplitude and
% width of the non-zero part of the function, while $q$ determines the 
% position of the non-zero part of the function.
% 
% $p$ specifies the magnitude and width (or scale) of the shape;
% $q$ specifies the position (or shift) of the shape. 
%
% Note that the functions $h[k,l]$ of Haar transform can represent not only 
% the details in the signal of different scales (corresponding to different 
% frequencies) but also their locations in time.
%
% Some properties of the Haar transform matrix:
%
% $$ H = H^* \;\;\;\;\;\;  H^{-1} = H^T , \;\;\;\;  \mbox{i.e.} \; \; \; \;
% {\bf H } ^T  {\bf H} = {\bf I}  $$
%
% where ${\bf I}$ is identity matrix.
% 
% The Haar transform of a given image ${\bf I}$ is:
%
% $$ {\bf X}={\bf H_{height}} \cdot {\bf I} \cdot {\bf H_{width}}^T $$
%
% The inverse transform is
% 
% $$ I= {\bf H_{height}}^{-1} \cdot  X  \cdot {\bf H_{width}}^{-T}   $$
%
%% Algorithm:
%  input: Image
%   foreach transform
%       image_transformed = transform(Image)
%       set each value at image_transformed smaller then Threshold to zero
%       image_reconstructed = inverse_transform(image_transformed_zeroed)
%   end
function GlobalAndLocalHistograms= GlobalAndLocalHistograms_mb( handles )
%GlobalAndLocalHistograms_MB Summary of this function goes here
%   Detailed explanation goes here
    handles = guidata(handles.figure1);

    k=1;
    axes_hor = 3;
    axes_ver = 2;
    is_outerposition = zeros(1, axes_hor*axes_ver);
    is_outerposition(3) = 1;
    is_outerposition(6) = 1;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    GlobalAndLocalHistograms = DeployAxes( handles.figure1, ...
        [axes_hor, ...
        axes_ver], ...
        bottom, ...
        left, ...
        0.9, ...
        0.9, ...
        is_outerposition);           
    GlobalAndLocalHistograms.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 
    axes_im = image(GlobalAndLocalHistograms.im,'cdata', GlobalAndLocalHistograms.im,  'parent', GlobalAndLocalHistograms.axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y));
    grid off; colormap(gray(256));axis image; axis(GlobalAndLocalHistograms.axes_1, 'off');
    DisplayAxesTitle( GlobalAndLocalHistograms.axes_1, [ 'Test image'], 'TM',10);
    
    pointerBehavior.enterFcn = @(a,b)ChangePointerAppearanceToCross(a,b, handles);
    pointerBehavior.exitFcn = @(a,b)ChangePointerAppearanceToArrow(a,b, handles);
    pointerBehavior.traverseFcn =[];%@(a,b)CalcLocalHistogram(a,b, handles);
    iptSetPointerBehavior(axes_im, pointerBehavior);      

 %
    GlobalAndLocalHistograms.WdSzX = 13;
    GlobalAndLocalHistograms.WdSzY = 13;
 %
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
    interface_params =  SetSliderParams('Set Window Width', 25, 1,  GlobalAndLocalHistograms.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set Window Height', 25, 1,  GlobalAndLocalHistograms.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);


    
    
    
    
    
    
    
    
    

    GlobalAndLocalHistograms.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
             
            

    im_hist  = histc(GlobalAndLocalHistograms.im(:), 0:255);        
    plot(GlobalAndLocalHistograms.axes_3, im_hist,'LineWidth', 2 );
    axis(GlobalAndLocalHistograms.axes_3, 'tight');
    set(GlobalAndLocalHistograms.axes_3, 'YAxisLocation', 'right');
    grid(GlobalAndLocalHistograms.axes_3, 'on');
    DisplayAxesTitle( GlobalAndLocalHistograms.axes_3, ['Test image histogram'], 'TM',10);
    
    h = waitbar(0, 'please wait');
    WdSzY = GlobalAndLocalHistograms.WdSzY;
    WdSzX = GlobalAndLocalHistograms.WdSzX;
%     max_wnd_sz = 25;

%     curr_wnd_indx = sub2ind( [max_wnd_sz, max_wnd_sz], ...
%     [((max_wnd_sz-1)/2 - (WdSzY-1)/2) :  (max_wnd_sz-1)/2 + (WdSzY-1)/2]'*ones(1,WdSzX) ,  ...
%     ones(WdSzY,1)*[((max_wnd_sz-1)/2 - (WdSzX-1)/2) :  (max_wnd_sz-1)/2 + (WdSzX-1)/2] );
    h = waitbar(0.25, h);
    im_ext = img_ext_mb(GlobalAndLocalHistograms.im, floor(WdSzY/2), floor(WdSzY/2));
    OUTIMG_1 = zeros(size(GlobalAndLocalHistograms.im));
    for j = 1:size(GlobalAndLocalHistograms.im,2)
        for i = 1:size(GlobalAndLocalHistograms.im,1)
            fragment = im_ext(i:i+WdSzY-1, j:j+WdSzX-1);
            OUTIMG_1(i,j) =sqrt(sum((im_hist -  histc(fragment(:), [0:255])).^2));
        end
    end
%     im_col_hist = histc(GlobalAndLocalHistograms.im.sliding(curr_wnd_indx(:), :), [0:255]);
%     OUTIMG_1 = sqrt(sum((im_hist - im_col_hist(:, 2:end)).^2));
    h = waitbar(0.50, h);
%     OUTIMG_1 = reshape([0, OUTIMG_1], [size(GlobalAndLocalHistograms.im.im, 1),size(GlobalAndLocalHistograms.im.im,2)])';
%     OUTIMG_1(:,1) = 0;
    h = waitbar(0.75, h);

    imshow(OUTIMG_1, [], 'parent', GlobalAndLocalHistograms.axes_2);
    DisplayAxesTitle( GlobalAndLocalHistograms.axes_2, ['RMS deviation of local histogram from the global one'], 'TM',10); 
    h = waitbar(1, h);
    close(h);
    helpdlg('Select a reference fragment in the test image');
end

function ChangePointerAppearanceToCross(a,b,  handles)
 handles = guidata(handles.figure1);
set(handles.figure1,'Pointer', 'crosshair');
end
function ChangePointerAppearanceToArrow(a,b,  handles)
 handles = guidata(handles.figure1);
set(handles.figure1,'Pointer', 'arrow');
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
    GlobalAndLocalHistograms = handles.(handles.current_experiment_name);
    im_hist  = histc(GlobalAndLocalHistograms.im(:), 0:255);
    h = waitbar(0,'comparing local histograms with selected fragment histogram');
    WdSzY = GlobalAndLocalHistograms.WdSzY;
    WdSzX = GlobalAndLocalHistograms.WdSzX;
    im_ext = img_ext_mb(GlobalAndLocalHistograms.im, floor(WdSzX/2), floor(WdSzY/2));
    OUTIMG_1 = zeros(size(GlobalAndLocalHistograms.im));
    for j = 1:size(GlobalAndLocalHistograms.im,2)
        for i = 1:size(GlobalAndLocalHistograms.im,1)
            fragment = im_ext(i:i+WdSzY-1, j:j+WdSzX-1);
            OUTIMG_1(i,j) =sqrt(sum((im_hist -  histc(fragment(:), [0:255])).^2));
        end
    end
%     h = waitbar(0.50, h);
%     OUTIMG_1 = reshape([0, OUTIMG_1], [size(GlobalAndLocalHistograms.im.im, 1),size(GlobalAndLocalHistograms.im.im,2)])';
%     OUTIMG_1(:,1) = 0;
    h = waitbar(0.75, h);

    imshow(OUTIMG_1, [], 'parent', GlobalAndLocalHistograms.axes_2);
    DisplayAxesTitle( GlobalAndLocalHistograms.axes_2, ['RMS deviation of local histogram from the global one'], 'TM'); 
    h = waitbar(1, h);
    close(h);



    if( isfield(handles.(handles.current_experiment_name), 'pointer_pos'))
        process_image(handles.(handles.current_experiment_name).im, ...
        handles.(handles.current_experiment_name).pointer_pos, handles.(handles.current_experiment_name).WdSzX, handles.(handles.current_experiment_name).WdSzY, ...
        handles.(handles.current_experiment_name).axes_1, ...
        handles.(handles.current_experiment_name).axes_4, handles.(handles.current_experiment_name).axes_5, ...
        handles.(handles.current_experiment_name).axes_6);
    end
end

function scd = ScriptCurrentDirectory
    scd = mfilename('fullpath');
    scd = scd(1:end - length(mfilename));
end

function UpdateLocalData(image_handles,y,z)
handles = guidata(get(image_handles, 'parent'));
handles.(handles.current_experiment_name).pointer_pos = get(handles.(handles.current_experiment_name).axes_1, 'CurrentPoint');
 guidata(get(image_handles, 'parent'), handles);
process_image(handles.(handles.current_experiment_name).im, ...
    handles.(handles.current_experiment_name).pointer_pos, handles.(handles.current_experiment_name).WdSzX, handles.(handles.current_experiment_name).WdSzY,...
    handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_4, handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6);

end

function process_image( im, point, WdSzY, WdSzX, axes_1, axes_4, axes_5, axes_6)
    x = round(point(1,1));
    y = round(point(1,2));
    
    x_grid = max(1, x-floor(WdSzX/2)):min(size(im,2),x+ceil(WdSzX/2) -1);
    y_grid = max(1, y-floor(WdSzY/2)):min(size(im,1),y+ceil(WdSzY/2) -1);
    image(im,'cdata', im,  'parent', axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y));
    grid(axes_1, 'off'); colormap(gray(256));axis(axes_1,  'image'); axis (axes_1,'off');
    DisplayAxesTitle( axes_1,'Test image','TM',10);
    rectangle('parent', axes_1, 'Position', [x_grid(1), y_grid(1), (x_grid(end)-x_grid(1)), (y_grid(end) - y_grid(1))]) ;

    rect_handle = get(axes_1, 'children');
    rect_handle = rect_handle(strcmpi(get(rect_handle, 'type'), 'rectangle'));
    delete(rect_handle);
    rectangle('Position', [max(1, x-WdSzX/2), max(1, y-WdSzY/2), WdSzX, WdSzY], 'parent', axes_1);

%     im_col_hist = histc(im.sliding(curr_wnd_indx(:), :), [0:255]);



    data = im(max(1, y-floor(WdSzY/2)):min(size(im,1),y+floor(WdSzY/2)) , max(1, x-floor(WdSzX/2)):min(size(im,2),x+floor(WdSzX/2)) );
    im_wnd_hist  = histc(data(:), 0:255);
    im_ext = img_ext_mb(im, floor(WdSzY/2), floor(WdSzY/2));
    OUTIMG_1 = zeros(size(im));
    for j = 1:size(im,2)
        for i = 1:size(im,1)
            fragment = im_ext(i:i+WdSzY-1, j:j+WdSzX-1);
            OUTIMG_1(i,j) =sqrt(sum((im_wnd_hist -  histc(fragment(:), [0:255])).^2));
        end
    end
%     OUTIMG_1 = sqrt(sum((im_col_hist - im_wnd_hist*ones(1,size(im_col_hist,2))).^2));
%     OUTIMG_1 = reshape(OUTIMG_1, [size(im, 1),size(im,2)]);   
    imshow(data, [0 255], 'parent', axes_4);
    DisplayAxesTitle( axes_4, [ 'Selected fragment'],'BM',10);  

    plot( [0: 255], im_wnd_hist,'LineWidth', 2, 'parent',  axes_6);
    axis(axes_6, 'tight');
    grid(axes_6, 'on');
    set(axes_6, 'XAxisLocation', 'top');
    set(axes_6, 'YAxisLocation', 'right');
    DisplayAxesTitle( axes_6, [ 'Selected fragment histogram'],'BM',10);  


    imshow(OUTIMG_1, [], 'parent', axes_5);
    DisplayAxesTitle( axes_5, { 'Local histogram RMS deviation','from the selected fragment histogram'}, 'BM',10); 
end