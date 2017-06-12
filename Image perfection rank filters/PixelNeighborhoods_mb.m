%% Pixel Neighborhoods
%  Study of pixel neighbourhoods   
%% Experiment Description:
% Introduction to image Neighborhood operation using intensity value, rank
% value, and derivative range.
%
% Four different Neighborhoods are introduced:
%
% * " $\epsilon$ V neighbourhood" - Neighborhoods in terms of pixel values.
% * "KNV neighbourhood" - K order neighborhoods in terms of pixel values.
% * " $\epsilon$ R neighbourhood" - Neighborhoods in terms of pixel values.
% * "Flat neighbourhood" - Neighborhoods in terms of pixel values.
%
%% Tasks:
% 11.1
%
% Observe segmentation capability and compare $\epsilon$ V-, KNV-,
% $\epsilon$ R-, KNR-, Flat neighbourhoods for different images, different
% spatial windows and different neighbourhood parameters. 
%
% Compare corresponding neighbourhoods for noiseless images and images with
% additive Gaussian noise.
%
%% Instruction:
% Select a point in the 'Main Image' to determine the window processed. 
%
% 'Set Window Width' - determines the width of the processed window around
% the selected point in the image.
%
% 'Set Window Height' - determines the height of the processed window around
% the selected point in the image.
%
% 'Set Positive EV offset' - Choose the positive offset from selected pixel
% value, which considered as same segment.
%
% 'Set Negative EV offset'- Choose the negative offset from selected pixel
% value, which considered as same segment.
%
% 'Set Positive ER Offset'- Choose the negative offset from selected pixel
% value, which considered as same segment.
%
% 'Set Negative ER Offset'- Choose the negative offset from selected pixel
% value, which considered as same segment.
%
% 'Set K Neighborhood Level'- Choose the negative offset from selected pixel
% value, which considered as same segment.
%
% 'Set Gradient Threshold'- Choose the threshold  offset from selected pixel
% value, which considered as same segment.
%
%% Theoretical Background:
% _Neighborhoods used in rank filters_
%
% Neighborhood is a set of elements and attributes that are inputs to the
% estimation operation. Neighborhood attributes may be associated both with
% elements of the neighborhood and with the neighborhood as a whole. The
% following attributes may be used as attributes of neighborhood elements:
% 
% * Co-ordinate in the window
% * Value.
% * Rank, or position of the element in the variational row formed from all
% elements of the neighborhood by sorting them from minimum to maximum.
% Rank of an element shows number of elements of the neighborhood that have
% lower value than that of the given element. 
% * Cardinality, or number of neighborhood elements with the same
% (quantized) value. 
% *Geometrical features, such as gradient, curvature etc.
%
% Attributes Rank and Cardinality are interrelated and can actually be
% regarded as two implementations of the same quality. While Rank is
% associated with variational row, Cardinality is associated with histogram
% over the neighborhood. Choice between them is governed, in particular, by
% their computational complexity. The computational complexity of operating
% with histogram is O(Q), where Q is the number of quantization levels used
% for representing signal values. Computational complexity of operating
% with variational row is O(N), where N is the number of neighborhood
% elements. Histogram of the window elements in each window position can be
% easily computed recursively from the histogram in the window previous
% position with only O(1) operations. Recursive formation of the
% variational row is also possible with the complexity of O(N) operations.
% According to these attributes one can distinguish the following type of
% neighborhoods used in the design of rank filters. 
%
% * Co-ordinate based neighborhoods (C-neighborhoods)
% SHnbh-, or Shape-neighborhoods that are formed from window samples by
% selecting them according to their co-ordinates. In 2-D and
% multi-dimensional case this corresponds to forming spatial neighborhoods
% of a certain shape. 
% * Pixel values based neighborhoods(V-neighborhoods):
% $\epsilon$ V-neighborhood, K-nearest values (KNV-) neighborhood.
% * Pixel rank (position in the variational row) based neighborhoods ($R$ -
% neighborhoods):   $\epsilon$ R-neighborhood, K-nearest rank (KNR-)
% neighborhood, quantile neighborhood.
% * Histogram based neighborhood (H-neighborhood):
% Cluster, (CL-neighborhood): subset of pixels that belong to the same
% cluster, or mode, of the histogram as that of the central pixel. 
% * Image geometrical feature based neighborhoods:
% *Flat-neighborhood:
% 
% As it was mentioned, rank algorithms are built on the base of local
% histograms over pixel neighborhoods (Eq. 3.2.6). Since histograms completely ignore
% spatial relationships between pixels it may seem that rank algorithms may fail to use
% spatial information which is one of the most important attributes of images. But no
% matter how strange it may appear, this property of rank algorithms is more often an
% advantage then disadvantage; it is one more aspect of their adaptivity. As a matter of
% fact, spatial relations between pixels (defined, for example, by their membership in
% one image detail or object) manifest themselves indirectly in local histograms. It is
% illustrated in Fig.3.2.3 which shows how closely one can imitate and image by
% building its copy from random numbers using only local histograms over an
% appropriately selected neighborhood.
%
% This experiment will focus on $\epsilon V-$, KNV-, $\epsilon R-$ , KNR-
% and FLAT-neighborhoods.
% 
%% Algorithm:
% For all neighborhood operations, the processed window is supplied, and
% main element ($a_k$).
%
% $$  $$  
%
% $$  $$    
%
% $\epsilon V-$ _*neighborhood*_
%
% A subset of elements with values $\{ a_n \}$ that satisfy inequality: 
%
% $$a_k - \epsilon V_{mn} \le a_n \le a_k +\epsilon V_pl$$
%
% <html>
% <pre class="codeinput">
% <p>Code:
%    ev_mask=(eye_wnd<>&lt<>=(centervalue+evpos)).*(eye_wnd<>&gt<>=(centervalue-evneg));
% </p>
% </pre>
% </html>
%
% $$  $$  
%
% $$  $$    
%
% _*KNV ("K nearest by value") neighborhood*_
%
% A subset of K elements with values $\{ a_n \}$ closest to that of element $a_k$.
%
% <html>
% <pre class="codeinput">
% <p>Code:
%    diff=abs(eye_wnd-centervalue);
%    [Y,I]=sort(diff(:));
%    knv_mask = zeros(size(eye_wnd));
%    knv_mask(I(1:knv_neighbor))=1;
% </p>
% </pre>
% </html>
%
% $$  $$  
%
% $$  $$    
%
% $\epsilon R-$ _*neighborhood*_
%
% A subset of elements with ranks $\{ R_n \}$ that satisfy inequality:
%
% $$R(a_k) - \epsilon R_{mn} \le Ra_n \le R(a_k) +\epsilon V_pl$$
%
% <html>
% <pre class="codeinput">
% <p>Code:
%    [Y,I]=sort(eye_wnd(:));
%    er_mask=zeros(size(eye_wnd));
%    indx = 1:length(Y);
%    value = unique(eye_wnd(:));
%    for i = 1: length(value)
%           Rank(i) = max(indx(Y == value(i)));
%    end
%    R = Rank(value == centervalue);
%    for i = 1: length(value)
%       if ( Rank(i) <>&gt<>= R - erneg) && ( Rank(i) <>&lt<>= R + erpos) 
%           er_mask( I(Y== value(i) ) ) = 1;
%       end
%    end
% </p>
% </pre>
% </html>
%
% $$  $$  
%
% $$  $$    
%
% _*KNR ("K-nearest by rank”) neighborhood*_
%
% A subset of K elements with ranks closest to that of element $a_k$.
%
% <html>
% <pre class="codeinput">
% <p>Code:
%    diff = abs(Rank - R);
%    [rank_diff_sort,I] = sort(diff(:));
%    knr_mask = zeros(size(eye_wnd));
%    for i = 1 : min(knv_neighbor,length(I))
%         knr_mask(eye_wnd == value(I(i)))=1;
%    end
% </p>
% </pre>
% </html>
%
% $$  $$  
%
% $$  $$    
%
% _*FLAT-neighborhood*_
%
% Neighborhood elements with values of Laplacian (or module of gradient)
% lower than a certain threshold
%
% <html>
% <pre class="codeinput">
% <p>Code:
%    grad = zeros(size(eye_wnd));
%    grad(2:end-1, 2:end-1) = sqrt( ...
%        (eye_wnd(1:end-2,2:end-1)-eye_wnd(2:end-1,2:end-1)).^2+...
%        (eye_wnd(3:end,2:end-1)-eye_wnd(2:end-1,2:end-1)).^2+...
%        (eye_wnd(2:end-1,1:end-2)-eye_wnd(2:end-1,2:end-1)).^2+...
%        (eye_wnd(2:end-1,3:end)-eye_wnd(2:end-1,2:end-1)).^2)/2;
%    grad(1,:) = 2*grad(2,:) - grad(3,:);
%    grad(end,:) = 2*grad(end-1,:) - grad(end-2,:);
%    grad(:, 1) = 2*grad(:,2) - grad(:,3);
%    grad(:, end) = 2*grad(:, end-1) - grad(:, end-2);
%    flat_mask=(grad<>&lt<>=flat_thr);
% </p>
% </pre>
% </html>
%
%% Reference
% * [1] Yaroslavsky L.P., Kim V., “Rank Algorithms for Picture Processing, Computer Vision”, Graphics and Image Processing, v. 35, 1986, p. 234-258 
% * [2] L. Yaroslavsky, M. Eden, Fundamentals of Digital Optics, Birkhauser, Boston,1996
% * [3] <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_4.pdf Lecture Notes: Image restoration and enhencement: non-linear filters>
% * [4] <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/nonlin_filters.pdf non-linear Signal Processing Filters: A Unification Approach>


function PixelNeighborhoods = PixelNeighborhoods_mb(handles)
	handles = guidata(handles.figure1);
	axes_hor = 4;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
    is_outerposition = zeros(1, axes_hor*axes_ver);
    is_outerposition(3) = 1;
	PixelNeighborhoods = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9, ...
    is_outerposition); 
	% init params
	PixelNeighborhoods.WdSzX = 33;
	PixelNeighborhoods.WdSzY = 33;
	PixelNeighborhoods.evpos = 20;
	PixelNeighborhoods.evneg = 20;
	PixelNeighborhoods.erpos = 40;
	PixelNeighborhoods.erneg = 40;
	PixelNeighborhoods.knv_neighbor = 270;
    PixelNeighborhoods.knr_neighbor = 20;
	PixelNeighborhoods.flat_thr = 3;
    wndSz = PixelNeighborhoods.WdSzX*PixelNeighborhoods.WdSzY;
	%
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Select, using the cursor, a center of the window';
	interface_params(k).callback = @(a,b)run_process_image(a);
	
	k=k+1;
	interface_params =  SetSliderParams('Set EVplus for EV-neighborhood', 255, 0, PixelNeighborhoods.evpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evpos',@update_sliders), interface_params, k);

	k=k+1;
	interface_params =  SetSliderParams('Set EVminus for EV-neighborhood', 255, 0, PixelNeighborhoods.evneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evneg',@update_sliders), interface_params, k);

	k=k+1;
% 	interface_params =  SetSliderParams('Set Positive ER Offset', 200, 0, PixelNeighborhoods.erpos, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erpos',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set ERplus for ER-neighborhood',.....
        fix(PixelNeighborhoods.WdSzX*PixelNeighborhoods.WdSzY/2), 0, PixelNeighborhoods.erpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erpos',@update_sliders), interface_params, k);
	k=k+1;
% 	interface_params =  SetSliderParams('Set Negative ER Offset', 200, 0, PixelNeighborhoods.erneg, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erneg',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set ERminus for ER-neighborhood',.....
        fix(PixelNeighborhoods.WdSzX*PixelNeighborhoods.WdSzY/2), 0, PixelNeighborhoods.erneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erneg',@update_sliders), interface_params, k);
	k=k+1;
% 	interface_params =  SetSliderParams('Set K Neighborhood Level', 100, 0, PixelNeighborhoods.knv_neighbor, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'knv_neighbor',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set K for KNV-neighborhood', fix(PixelNeighborhoods.WdSzX*PixelNeighborhoods.WdSzY/2), 0, PixelNeighborhoods.knv_neighbor, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'knv_neighbor',@update_sliders), interface_params, k);
	k=k+1;
    interface_params =  SetSliderParams('Set K for KNR-neighborhood', fix(PixelNeighborhoods.WdSzX*PixelNeighborhoods.WdSzY/2), 0, PixelNeighborhoods.knr_neighbor, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'knr_neighbor',@update_sliders), interface_params, k);
	k=k+1;
	interface_params =  SetSliderParams('Set Gradient threshold for "flat-neighborhood', 100, 0, PixelNeighborhoods.flat_thr, 0.5, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'flat_thr',@update_sliders), interface_params, k);

    k=k+1;
% 	interface_params =  SetSliderParams('Set Window Width', 17, 1, PixelNeighborhoods.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set window width',75, 1, PixelNeighborhoods.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);
	k=k+1;
% 	interface_params =  SetSliderParams('Set Window Height', 17, 1, PixelNeighborhoods.WdSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set window height', 75, 1, PixelNeighborhoods.WdSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);

	PixelNeighborhoods.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		             
	%
	PixelNeighborhoods.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 
	axes_im = image(PixelNeighborhoods.im,'cdata', PixelNeighborhoods.im,  'parent', PixelNeighborhoods.axes_1 , 'ButtonDownFcn',  @(x,y,z)UpdateLocalData(x,y));
	grid off; colormap(gray(256));axis image; axis(PixelNeighborhoods.axes_1, 'off');
	DisplayAxesTitle( PixelNeighborhoods.axes_1, ['Main Image'],   'TM');
	%Set Axes_1 pointer appearance
	pointerBehavior.enterFcn = @(a,b)ChangePointerAppearanceToCross(a,b, handles);
	pointerBehavior.exitFcn = @(a,b)ChangePointerAppearanceToArrow(a,b, handles);
	pointerBehavior.traverseFcn =[];%@(a,b)CalcLocalHistogram(a,b, handles);
	iptSetPointerBehavior(axes_im, pointerBehavior);      
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
    
    WdSz = fix(handles.(handles.current_experiment_name).WdSzX*handles.(handles.current_experiment_name).WdSzY/2);
    % er plus
    val = min(WdSz, handles.(handles.current_experiment_name).erpos);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider4');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', WdSz);
    set(slider_handle, 'sliderstep', [1, 1]/(WdSz));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value4');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText4');
    set(slider_title_handle, 'string',  num2str(WdSz));
    handles.(handles.current_experiment_name).erpos = val;
    % er minus
    val = min(WdSz, handles.(handles.current_experiment_name).erneg);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider5');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', WdSz);
    set(slider_handle, 'sliderstep', [1, 1]/(WdSz));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value5');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText5');
    set(slider_title_handle, 'string',  num2str(WdSz));
    handles.(handles.current_experiment_name).erneg = val;   
    % knv_neighbor
    val = min(WdSz, handles.(handles.current_experiment_name).knv_neighbor);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider6');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', WdSz);
    set(slider_handle, 'sliderstep', [1, 1]/(WdSz));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value6');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText6');
    set(slider_title_handle, 'string',  num2str(WdSz));
    handles.(handles.current_experiment_name).knv_neighbor = val;   

    % knr_neighbor
    val = min(WdSz, handles.(handles.current_experiment_name).knr_neighbor);
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider7');
    set(slider_handle, 'value', val);
    set(slider_handle, 'max', WdSz);
    set(slider_handle, 'sliderstep', [1, 1]/(WdSz));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value7');
    set(slider_title_handle, 'string',  num2str(val));
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText7');
    set(slider_title_handle, 'string',  num2str(WdSz));
    handles.(handles.current_experiment_name).knr_neighbor = val;
    
    if ( strcmpi(handles.interactive, 'on'))
        run_process_image(handles);
    end
    guidata(handles.figure1,handles );
end


function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end    
    if ( isfield(handles.(handles.current_experiment_name), 'x'))
        process_image(handles.(handles.current_experiment_name).im, handles.(handles.current_experiment_name).x, handles.(handles.current_experiment_name).y, ...
            handles.(handles.current_experiment_name).WdSzX, handles.(handles.current_experiment_name).WdSzY, ...
            handles.(handles.current_experiment_name).evpos, handles.(handles.current_experiment_name).evneg, ...
            handles.(handles.current_experiment_name).erpos,handles.(handles.current_experiment_name).erneg, ...
            handles.(handles.current_experiment_name).knv_neighbor, handles.(handles.current_experiment_name).knr_neighbor, handles.(handles.current_experiment_name).flat_thr, ...
        handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_2, handles.(handles.current_experiment_name).axes_3, handles.(handles.current_experiment_name).axes_4, handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6, handles.(handles.current_experiment_name).axes_7, handles.(handles.current_experiment_name).axes_8);
    end
    guidata(handles.figure1,handles );
end


function UpdateLocalData(image_handles,y,z)
handles = guidata(get(image_handles, 'parent'));
point = get(handles.(handles.current_experiment_name).axes_1, 'CurrentPoint');
guidata(get(image_handles, 'parent'), handles);
handles.(handles.current_experiment_name).x = round(point(1,1));
handles.(handles.current_experiment_name).y = round(point(1,2));
guidata(get(image_handles, 'parent'),handles );
    process_image(handles.(handles.current_experiment_name).im, handles.(handles.current_experiment_name).x, handles.(handles.current_experiment_name).y, ...
        handles.(handles.current_experiment_name).WdSzX, handles.(handles.current_experiment_name).WdSzY, ...
        handles.(handles.current_experiment_name).evpos, handles.(handles.current_experiment_name).evneg, ...
        handles.(handles.current_experiment_name).erpos, handles.(handles.current_experiment_name).erneg, ...
        handles.(handles.current_experiment_name).knv_neighbor, handles.(handles.current_experiment_name).knr_neighbor, handles.(handles.current_experiment_name).flat_thr, ...
    handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_2, handles.(handles.current_experiment_name).axes_3, handles.(handles.current_experiment_name).axes_4, handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6, handles.(handles.current_experiment_name).axes_7, handles.(handles.current_experiment_name).axes_8);
end

function process_image (im, x, y, WdSzX, WdSzY, evpos, evneg, erpos, erneg, knv_neighbor, knr_neighbor, flat_thr, ...
    axes_5, axes_6, axes_7, axes_8, axes_1, axes_2, axes_3, axes_4)


    rect_handle = get(axes_5, 'children');
    rect_handle = rect_handle(strcmpi(get(rect_handle, 'type'), 'rectangle'));
    delete(rect_handle);
    rectangle('Position', [max(1, x-WdSzX/2), max(1, y-WdSzY/2), 1+WdSzX, 1+WdSzY], 'parent', axes_5);  

    eye_wnd = im(max(1, floor(y-WdSzY/2)):min(size(im,1),floor(y+WdSzY/2)-1) , max(1, floor(x-WdSzX/2)):min(size(im,2),floor(x+WdSzX/2)-1) );
    imshow(eye_wnd, [0 255], 'parent', axes_6);
    DisplayAxesTitle( axes_6, ['Window'],   'TM');
    plot(histc(eye_wnd(:), [0:255]), 'parent', axes_7, 'linewidth', 2);
    grid(axes_7, 'on');
    DisplayAxesTitle( axes_7, ['Window histogram'],   'TM',10);
    xlabel(axes_7, 'Gray level'); 
    axis(axes_7, 'tight');
    centervalue = eye_wnd(ceil(end/2), ceil(end/2));
% EV-neighborhoods
    ev_mask=(eye_wnd<=(centervalue+evpos)).*(eye_wnd>=(centervalue-evneg));
    imshow(ev_mask, 'parent', axes_1);
%     DisplayAxesTitle( axes_1, ['"\epsilonV" neighborhood mask'], 'BM',10);
    DisplayAxesTitle( axes_1, ['"EV" neighborhood mask'], 'BM',10);
% KNV-neighborhoods
    diff=abs(eye_wnd-centervalue);
    [Y,I]=sort(diff(:));
    knv_mask = zeros(size(eye_wnd));
    knv_mask(I(1:knv_neighbor))=1;
    imshow(knv_mask, 'parent', axes_2);
    DisplayAxesTitle( axes_2, ['"KNV" neighborhood mask'],'BM',10);
% ER- neighborhoods
    [Y,I]=sort(eye_wnd(:));
    er_mask=zeros(size(eye_wnd));
    
    indx = 1:length(Y);
    value = unique(eye_wnd(:));
    for i = 1: length(value)
        Rank(i) = max(indx(Y == value(i)));
    end
    R = Rank(value == centervalue);
    
    for i = 1: length(value)
        if ( Rank(i) >= R - erneg) && ( Rank(i) <= R + erpos) 
            er_mask( eye_wnd == value(i) ) = 1;
        end
    end
    
%     R = round(median(find(Y == centervalue )));    
%     er_mask( I(max(1,R-erneg):min(length(I),R+erpos))) = 1;
    imshow(er_mask, 'parent', axes_3);
%     DisplayAxesTitle( axes_3, ['"\epsilonR" neighborhood mask'],   'BM');
    DisplayAxesTitle( axes_3, ['"ER" neighborhood mask'],'BM',10);
% KNR- neighborhoods
    diff = abs(Rank - R);
    [rank_diff_sort,I] = sort(diff(:));
    knr_mask = zeros(size(eye_wnd));
    for i = 1 : min(knr_neighbor,length(I))
        knr_mask(eye_wnd == value(I(i)))=1;
    end
    
    imshow(knr_mask, 'parent', axes_4);
    DisplayAxesTitle( axes_4, ['"KNR" neighborhood mask'],   'BM');
% Flat neighborhoods
    grad = zeros(size(eye_wnd));
    grad(2:end-1, 2:end-1) = sqrt( ...
        (eye_wnd(1:end-2,2:end-1)-eye_wnd(2:end-1,2:end-1)).^2+...
        (eye_wnd(3:end,2:end-1)-eye_wnd(2:end-1,2:end-1)).^2+...
        (eye_wnd(2:end-1,1:end-2)-eye_wnd(2:end-1,2:end-1)).^2+...
        (eye_wnd(2:end-1,3:end)-eye_wnd(2:end-1,2:end-1)).^2)/2;
    grad(1,:) = 2*grad(2,:) - grad(3,:);
    grad(end,:) = 2*grad(end-1,:) - grad(end-2,:);
    grad(:, 1) = 2*grad(:,2) - grad(:,3);
    grad(:, end) = 2*grad(:, end-1) - grad(:, end-2);
    
	flat_mask=(grad<=flat_thr);
    imshow(flat_mask, 'parent', axes_8);
    DisplayAxesTitle( axes_8, ['"Flat" neighborhood mask'],'TM',10);                   

end