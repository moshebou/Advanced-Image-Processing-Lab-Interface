%% Edge Enhancement
%  Study of Image Segmentation as a result of rank filter smoothing.
%% Experiment Description:
% This experiment compare two Impulse Noise filtering algorithms Median
% filter and median over Qnbh-, or quantile neighborhood.
%% Tasks:
% 11.4.2 
%
% Test image enhancement, edge enhancement and feature selection by unsharp
% masking with rank filters (programs mean_ev.m, medn_ev.m, maxminev.m,
% mx_mn_er.m, size_ev.m, std_ev.m, images ango, brain1). 
%% Instruction:
% 'Set Number of Iterations' - determines number of iteration of the
% algorithm.
%
% 'Set Negative EV offset' - Defines the lower EV offset from current EV
% value
%
% 'Set Positive EV offset' - Defines the higher EV offset from current EV
% value.
%
% 'Set Window Width'- Defined the neighborhood window width.
%
% 'Set Window Height'- Defined the neighborhood window height.
%% Theoretical Background:
% _*Rank order filters for image enhancement*_
%
% Enhancement of monochrome images is most frequently associated with
% different methods of amplification of local contrasts and edge
% extraction. Three families of rank filters can be used for such local
% contrast enhancement: *unsharp masking filters*, *histogram modification
% filters* and *range-filters*. 
%
% *Unsharp masking* filters work according to equation: 
%
% $$I(x,y)^{out} = G\cdot \left( I(x,y) - Smooth \left(Neighborhood \left(I(x,y)
% \right) \right) \right)$$ 
%
% where G is a contrast enhancement coefficient.
%
% *Histogram modification* algorithms are described by equation:
%
% $$I(x,y)_{out} = P_ Rank \left( Neighborhood \left( I(x,y) \right) \right)$$
%
% A version of this filter for histogram non-linearity index in Eq. (3.2.15)
% $P = 1$ and neighborhood formed by all pixels in the filter window is known
% as local histogram equalization. Processing with $P \ne 1$ we call p-histogram
% equalization. An example of local contrast enhancement with local
% p-histogram equalization is shown in Fig. 3.2.8. Range-filters can be
% regarded as a generalization of unsharp masking filters. They amplify
% difference between pixel values and local mean inversely proportionally
% to image local range that is evaluated by rank algorithms: 
%
% $$I(x,y)^{res} = \frac{I(x,y) - MEAN \left( Neighborhood \left( I(x,y) )\right) \right)}{SPRD\left( Neighborhood\left( I(x,y) \right)\right)}$$
%
% Where SPRD(NBH) is spread measurement of data within the neighborhood. As
% a measure of data spread, standard deviation STDEV(NBH) over the
% neighborhood can be used. However, conventional standard deviation
% operation for evaluation of data variance is nonrobust against outliers.
% In case of outliers present in the data, Interquantil Distance
%  ( $IQDIST(NBH)$ ) may be preferable: 
%
% $$IQDIST(NBH ) = R_{ROS}(NBH) -L_{ROS} (NBH ) $$
% where $1 \le L < R \le SIZE (NBH)$.
% 
% Edge extraction is a processing very akin to local contrast enhancement.
% 
% Unsharp masking carried out in sliding window of small size ( 3 ·3 to 5 ·
% 5 ) can be, for instance, used for this purpose. 
% Rank algorithms for evaluating image local range represent another and very efficient option.
% Fig. 3.2.8 c) illustrates edge extraction by  one of the most simple
% algorithms of this sort: 
%
% $$I(x,y)^{res} = \frac{I(x,y) - MEAN \left( Neighborhood \left( I(x,y) )\right) \right)}{SPRD\left( Neighborhood\left( I(x,y) \right)\right)}$$
%
% where 3 · 3SHnbh is sliding window of 3 ·3 pixels.
% This experiment will focus on $MEAN$ smoothing operation over $\epsilon V$ neighborhood.
%% Algorithm:
% Inputs:
% Number of Iterations (iteration_num), Input Image (I(x,y)).
%
% <html><pre class="codeinput"><p>Code:
%    for i =1 : iteration_num
%        for x = 1: image_width
%            for y = 1: image_height
%                I_seg(x,y) = mean(Ev_nbh(I(x,y), S(I,x,y),ev_pos, ev_neg));
%            end
%        end
%    end
% </p></pre></html>
%
% Where:
% 
% mean(S) - calculates the mean of the set of numbers S.
%
% Ev_nbh(V, S, ev_pos, ev_neg) - returns all the elements $U \in S$
% which satisfy the condition: $V-ev_{neg} \le U \le V+ev_{pos}$.
%
% S(I, x, y) - returns the pixels in the rectangle im a window surrounds the (x,y)
% position, with th size of window_widthXwindow height.
%% Reference
% * [1] Yaroslavsky L.P., Kim V., “Rank Algorithms for Picture Processing, Computer Vision”, Graphics and Image Processing, v. 35, 1986, p. 234-258 
% * [2] L. Yaroslavsky, M. Eden, Fundamentals of Digital Optics, Birkhauser, Boston,1996
% * [3] <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_4.pdf Lecture Notes: Image restoration and enhancement: non-linear filters>
% * [4] <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/nonlin_filters.pdf non-linear Signal Processing Filters: A Unification Approach>

function LocalContrastEnhancement = LocalContrastEnhancement_mb(handles)
	handles = guidata(handles.figure1);
	axes_hor = 3;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	LocalContrastEnhancement = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9); 

		
	LocalContrastEnhancement.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 

	%init params
	LocalContrastEnhancement.WdSzX = 5;%3;
	LocalContrastEnhancement.WdSzY = 5;%3;
    WindowSize=LocalContrastEnhancement.WdSzX*LocalContrastEnhancement.WdSzY;
	LocalContrastEnhancement.evpos = 10;%5;
	LocalContrastEnhancement.evneg = 10;%5;
	LocalContrastEnhancement.erpos = fix(WindowSize/2);%5;
	LocalContrastEnhancement.erneg = fix(WindowSize/2);%5;
    LocalContrastEnhancement.EdgeEnType = 'Rank filters';

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    
	k=k+1;
	interface_params =  SetSliderParams('Set EVplus for Mean/Medn-EV filters', 64, 0, ....
        LocalContrastEnhancement.evpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evpos',@update_sliders), interface_params, k);

	k=k+1;
	interface_params =  SetSliderParams('Set EVminus for Mean/Medn-EV filters', 64, 0, ....
        LocalContrastEnhancement.evneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evneg',@update_sliders), interface_params, k);

	k=k+1;
	interface_params =  SetSliderParams('Set ERplus', fix(WindowSize/2), 0,.....
        LocalContrastEnhancement.erpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erpos',@update_sliders), interface_params, k);
    
	k=k+1;
	interface_params =  SetSliderParams('Set ERminus', fix(WindowSize/2),0,.....
        LocalContrastEnhancement.erneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erneg',@update_sliders), interface_params, k);

	k=k+1;
	interface_params =  SetSliderParams('Set filter window width', 51, 1,....
        LocalContrastEnhancement.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);

	k=k+1;
	interface_params =  SetSliderParams('Set filter window height', 51, 1,.....
        LocalContrastEnhancement.WdSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);
    
    k=k+1;
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose Evolutionary Model';
    interface_params(k).selection ={ 'Unsharp masking', 'Rank filters'};   
    interface_params(k).callback = @(a,b)ChooseEdgeEnhancementType(a,b,handles);  
    interface_params(k).value = find(strcmpi(interface_params(k).selection, .....
        LocalContrastEnhancement.EdgeEnType));
    


	LocalContrastEnhancement.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		             

    imshow(LocalContrastEnhancement.im, [0 255], 'parent', LocalContrastEnhancement.axes_1);
    DisplayAxesTitle( LocalContrastEnhancement.axes_1, 'Test image','TM',10);
% 	process_image (LocalContrastEnhancement.im, LocalContrastEnhancement.evpos, LocalContrastEnhancement.evneg, LocalContrastEnhancement.erpos, LocalContrastEnhancement.erneg, ...
% 	LocalContrastEnhancement.WdSzX, LocalContrastEnhancement.WdSzY, ...
% 	LocalContrastEnhancement.axes_1, LocalContrastEnhancement.axes_2, LocalContrastEnhancement.axes_3, LocalContrastEnhancement.axes_4, ...
% 	LocalContrastEnhancement.axes_5, LocalContrastEnhancement.axes_6);

end


function update_sliders(handles)
    if ( ~isstruct(handles))
		handles = guidata(handles);
    end
    if ( strcmpi(handles.(handles.current_experiment_name).EdgeEnType, 'Rank filters') )
        WindowSize=handles.(handles.current_experiment_name).WdSzX*handles.(handles.current_experiment_name).WdSzY;
        % er pos
        val = min(handles.(handles.current_experiment_name).erpos, fix(WindowSize/2));
        slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider4');
        set(slider_handle, 'value', val);
        set(slider_handle, 'max', max(1.00001, fix(WindowSize/2)));
        set(slider_handle, 'sliderstep', [1, 1]/(fix(WindowSize/2) ));
        slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value4');
        set(slider_title_handle, 'string',  num2str(val));
        slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText4');
        set(slider_title_handle, 'string',  num2str(fix(WindowSize/2)));
        handles.(handles.current_experiment_name).erpos = val;   
        
        % er neg
        val = min(handles.(handles.current_experiment_name).erneg, fix(WindowSize/2));
        slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider5');
        set(slider_handle, 'value', val);
        set(slider_handle, 'max', max(1.00001, fix(WindowSize/2)));
        set(slider_handle, 'sliderstep', [1, 1]/(fix(WindowSize/2)));
        slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value5');
        set(slider_title_handle, 'string',  num2str(val));
        slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'RightText5');
        set(slider_title_handle, 'string',  num2str(fix(WindowSize/2)));
        handles.(handles.current_experiment_name).erneg = val; 
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

    LocalContrastEnhancement = handles.(handles.current_experiment_name);
    process_image (LocalContrastEnhancement.im, LocalContrastEnhancement.EdgeEnType, LocalContrastEnhancement.evpos, LocalContrastEnhancement.evneg, LocalContrastEnhancement.erpos, LocalContrastEnhancement.erneg, ...
        LocalContrastEnhancement.WdSzX, LocalContrastEnhancement.WdSzY, ...
        LocalContrastEnhancement.axes_1, LocalContrastEnhancement.axes_2, LocalContrastEnhancement.axes_3, LocalContrastEnhancement.axes_4, ...
        LocalContrastEnhancement.axes_5, LocalContrastEnhancement.axes_6);
end

function ChooseEdgeEnhancementType(a,b,handles)
    handles = guidata(handles.figure1);
    handles.(handles.current_experiment_name).EdgeEnType = get(b.NewValue, 'string');
    delete(handles.(handles.current_experiment_name).buttongroup_handle);
    handles.(handles.current_experiment_name) = rmfield(handles.(handles.current_experiment_name), 'buttongroup_handle');
 	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    
	k=k+1;
	interface_params =  SetSliderParams('Set EVplus for Mean/Medn-EV filters', 64, 0, handles.(handles.current_experiment_name).evpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evpos',@update_sliders), interface_params, k);

	k=k+1;
	interface_params =  SetSliderParams('Set EVminus for Mean/Medn-EV filters', 64, 0, handles.(handles.current_experiment_name).evneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evneg',@update_sliders), interface_params, k);
    if ( strcmpi(handles.(handles.current_experiment_name).EdgeEnType, 'Rank filters') ) 
        WindowSize=handles.(handles.current_experiment_name).WdSzX*handles.(handles.current_experiment_name).WdSzY;
        k=k+1;
        interface_params =  SetSliderParams('Set ERplus', fix(WindowSize/2), 0, handles.(handles.current_experiment_name).erpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erpos',@update_sliders), interface_params, k);

        k=k+1;
        interface_params =  SetSliderParams('Set ERminus', fix(WindowSize/2),0, handles.(handles.current_experiment_name).erneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'erneg',@update_sliders), interface_params, k);
    end
	k=k+1;
	interface_params =  SetSliderParams('Set filter window width', 51, 1, handles.(handles.current_experiment_name).WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);

	k=k+1;
	interface_params =  SetSliderParams('Set filter window height', 51, 1, handles.(handles.current_experiment_name).WdSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);
    
    k=k+1;
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose Evolutionary Model';
    interface_params(k).selection ={ 'Unsharp masking', 'Rank filters'};   
    interface_params(k).callback = @(a,b)ChooseEdgeEnhancementType(a,b,handles);  
    interface_params(k).value = find(strcmpi(interface_params(k).selection, handles.(handles.current_experiment_name).EdgeEnType));
    


	handles.(handles.current_experiment_name).buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		             
   
    
    
    LocalContrastEnhancement = handles.(handles.current_experiment_name);
    guidata(handles.figure1, handles);
    process_image (LocalContrastEnhancement.im, LocalContrastEnhancement.EdgeEnType, LocalContrastEnhancement.evpos, LocalContrastEnhancement.evneg, LocalContrastEnhancement.erpos, LocalContrastEnhancement.erneg, ...
        LocalContrastEnhancement.WdSzX, LocalContrastEnhancement.WdSzY, ...
        LocalContrastEnhancement.axes_1, LocalContrastEnhancement.axes_2, LocalContrastEnhancement.axes_3, LocalContrastEnhancement.axes_4, ...
        LocalContrastEnhancement.axes_5, LocalContrastEnhancement.axes_6);

end
function process_image (im, EdgeEnType, evpos, evneg,  ERplus, ERminus, LX, LY,  axes_1, axes_2,  axes_3, axes_4,  axes_5, axes_6)

im = double(im);
Lx=(LX-1)/2;
Ly=(LY-1)/2;
[SzX SzY]=size(im);
imgext=img_ext_mb(im,Lx,Ly);
nbhood = im2col(imgext,[LY LX],'sliding')';
% LOCAL HISTOGRAM 
SzW=LX*LY;
center = im(:)*ones(1,SzW);

iteration_num = 6;
i=0;
wait_bar_handle = waitbar(0,'please wait') ;

% EV
centerpos = (center + evpos);
centerneg = center - evneg;
evnbh=(nbhood<=centerpos).*(nbhood>=centerneg);
sizeev=sum(evnbh,2);
EVnbh=nbhood.*evnbh;

klin=ones(SzY*SzX,1)*[1:SzW];
varrow=sort(nbhood, 2);

if ( strcmpi(EdgeEnType, 'Unsharp masking'))
    % mean image
    im_mean = mean(nbhood,2);
    imshow(im-reshape(im_mean, [SzY SzX]), [], 'parent', axes_2);
    DisplayAxesTitle( axes_2, ['Unsharp masking: Test image-Mean\_Window'], 'TM',10);     

    % median image
    im_median = median(nbhood,2);
    imshow(im-reshape(im_median, [SzY SzX]), [], 'parent', axes_3);
    DisplayAxesTitle( axes_3, ['Unsharp masking: Test\_image – Median\_Window'], 'TM',10);    

    % mean_ev_mb
    mean_ev_out=sum(EVnbh,2)./sizeev;
    mean_ev_out=reshape(mean_ev_out, [SzY SzX]);
    i = i+1; waitbar(i/iteration_num,wait_bar_handle);
    imshow(im-mean_ev_out, [], 'parent', axes_5);
    DisplayAxesTitle( axes_5, ['Unsharp masking: Test image-Mean\_of\_EV'], 'BM',10); 

    % medn_ev_mb
    mask=sizeev*ones(1, LX*LY);
    EVnbh= sort(EVnbh, 2,'descend');
    medn_ev_out=sum(EVnbh.*(fix((mask+1)/2)==klin),2);
    medn_ev_out=reshape(medn_ev_out, [SzY SzX]);
    i = i+1; waitbar(i/iteration_num,wait_bar_handle);
    % imshow(medn_ev_out, [0 255], 'parent', axes_2);
    imshow(im-medn_ev_out, [], 'parent', axes_6);
    DisplayAxesTitle( axes_6, ['Unsharp masking: Test image-Median\_of\_EV'],'BM',10); 
    delete(wait_bar_handle);

else
    % maxminev_mb
    EVnbhmax=max(nbhood.*evnbh, [], 2);
    EVnbhmax=reshape(EVnbhmax, [SzY SzX]);
    EVnbhmin=min(nbhood./(evnbh+eps), [], 2);
    EVnbhmin=reshape(EVnbhmin, [SzY SzX]);
    maxminev = EVnbhmax - EVnbhmin;
    i = i+1; waitbar(i/iteration_num,wait_bar_handle);
    imshow(maxminev, [], 'parent', axes_3);
    DisplayAxesTitle( axes_3, ['Rank filters: Max-Min Over EV-Neighborhood'],   'TM'); 

    % mx_mn_er_mb
    % ER

    R=sum(nbhood<=center,2);
    Rleft=R-ERminus;
    Rleft=Rleft.*(Rleft>=1)+(Rleft<1); 
    Rleft=Rleft*ones(1, SzW);
    Rright=R+ERplus;
    Rright=Rright.*(Rright<=SzW)+SzW*(Rright>SzW); 
    Rright=Rright*ones(1, SzW);
    maskL=(klin>=Rleft); 
    maskR=klin<=Rright;
    ERnbhmax = max(varrow.*maskR, [], 2);
    ERnbhmax=reshape(ERnbhmax, [SzY SzX]);
    ERnbhmin = max(varrow.*maskL, [], 2);
    ERnbhmin=reshape(ERnbhmin, [SzY SzX]);
    mx_mn_er = ERnbhmax-ERnbhmin;
    i = i+1; waitbar(i/iteration_num,wait_bar_handle);
    imshow(mx_mn_er, [], 'parent', axes_5);
    DisplayAxesTitle( axes_5, ['Rank filters: Quasi-spread Window'],   'BM'); 

    % size_ev_mb
    size_ev_out=sum(evnbh, 2);
    size_ev_out=reshape(size_ev_out, [SzY SzX]);
    i = i+1; waitbar(i/iteration_num,wait_bar_handle);
    imshow(size_ev_out, [], 'parent', axes_6);
    DisplayAxesTitle( axes_6, ['Rank filters: Size Of EV Neighborhood'],   'BM'); 

    std_ev_out=reshape( std(nbhood,1, 2), [SzY SzX]);
    imshow(std_ev_out, [], 'parent', axes_2);
    DisplayAxesTitle( axes_2, ['Rank filters: StDevWindow'],   'TM');
    delete(wait_bar_handle);
end
end