%% Image Segmentation
%  Study of Image Segmentation as a result of rank filter smoothing.
%% Experiment Description:
% This experiment compare two Impulse Noise filtering algorithms Median
% filter and median over Qnbh-, or quantile neighborhood.
%% Tasks:
% 11.4.1 
%
% Test image segmentation capability of iterative application of smoothing
% rank filters (program mneviter.m, images ango, brain).
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
% _*Rank filters for image segmentation*_
%
% Image segmentation can usually be interpreted as generating from input
% image its piece wise constant model.
%
% In image segmentation, one can regard image tiny and low contrast details
% that have to be eliminated in the process of segmentation as “noise”.
%
% Noise smoothing rank filters described in the "Filtering Additive Noise"
% experiment are very well suited for such a processing: 
%
% $$ \tilde{I}(x,y)^t = Smooth \left( neighborhood \left( I \left( x,y
% \right)^{t-1} \right) \right) $$ 
%
% where $Smooth$ is one of smoothing operations such as $MEAN$, $MED$,
% $ROS$, $MODE$ or $RAND$. 
%
% $neighborhood$ is a neighborhood operation such as $\epsilon V$ neighborhood,
% $\epsilon R$ neighborhood, etc.
%
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
% S(I, x, y) - returns the pixels in the rectangle in a window surrounds the (x,y)
% position, with th size of window_widthXwindow height.
%% Reference
% * [1] Yaroslavsky L.P., Kim V., “Rank Algorithms for Picture Processing, Computer Vision”, Graphics and Image Processing, v. 35, 1986, p. 234-258 
% * [2] L. Yaroslavsky, M. Eden, Fundamentals of Digital Optics, Birkhauser, Boston,1996
% * [3] <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_4.pdf Lecture Notes: Image restoration and enhancement: non-linear filters>
% * [4] <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/nonlin_filters.pdf non-linear Signal Processing Filters: A Unification Approach>

function ImageSegmentation = ImageSegmentation_mb(handles)
	handles = guidata(handles.figure1);


	axes_hor = 2;
	axes_ver = 1;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	ImageSegmentation = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9); 
	% init params
	ImageSegmentation.WdSzX = 5;%3;
	ImageSegmentation.WdSzY = 5;%3;
	ImageSegmentation.evpos = 5;
	ImageSegmentation.evneg = 5;
% 	ImageSegmentation.erpos = 5;
% 	ImageSegmentation.erneg = 5;
	ImageSegmentation.var = 0.05;
	ImageSegmentation.iteration_num = 3;%5;
	
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);

	k=k+1;
% 	interface_params =  SetSliderParams('Set Positive EV offset', 41, 1, ImageSegmentation.evpos, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evpos',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set EVplus', 50, 0, ImageSegmentation.evpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evpos',@update_sliders), interface_params, k);
	k=k+1;
% 	interface_params =  SetSliderParams('Set Negative EV offset', 41, 1, ImageSegmentation.evneg, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evneg',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set EVminus', 50, 0, ImageSegmentation.evneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evpos',@update_sliders), interface_params, k);
	k=k+1;
% 	interface_params =  SetSliderParams('Set Number Of Iterations', 10, 0, ImageSegmentation.iteration_num, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'iteration_num',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set the number of iterations', 10, 1, ImageSegmentation.iteration_num, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'iteration_num',@update_sliders), interface_params, k);
    k=k+1;
% 	interface_params =  SetSliderParams('Set Window Width', 61, 1, ImageSegmentation.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set filter window width', 61, 1, ImageSegmentation.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);
	k=k+1;
	interface_params =  SetSliderParams('Set filter window height', 61, 1, ImageSegmentation.WdSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);



	ImageSegmentation.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
		             
	%%
	ImageSegmentation.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 
    imshow(ImageSegmentation.im, [0 255], 'parent', ImageSegmentation.axes_1);
    DisplayAxesTitle( ImageSegmentation.axes_1, ['Test image'],'TM',10); 
    
% 	process_image (ImageSegmentation.im, ImageSegmentation.evpos, ImageSegmentation.evneg, ...
% 	ImageSegmentation.WdSzX, ImageSegmentation.WdSzY,  ...
% 	ImageSegmentation.iteration_num, ImageSegmentation.axes_1, ImageSegmentation.axes_2);

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



ImageSegmentation = handles.(handles.current_experiment_name);
process_image (ImageSegmentation.im, ImageSegmentation.evpos, ImageSegmentation.evneg, ...
    ImageSegmentation.WdSzX, ImageSegmentation.WdSzY,  ...
    ImageSegmentation.iteration_num, ImageSegmentation.axes_1, ImageSegmentation.axes_2);
end


function process_image (im, evpos, evneg,  WdSzX, WdSzY, iteration_num, axes_1, axes_2)
mean_ev_out = im;
wait_bar_handle = waitbar(0,'please wait') ;
for i =1 : iteration_num
    mean_ev_out=mean_ev_mb(mean_ev_out,WdSzX,WdSzY,evpos,evneg);
    waitbar(i/iteration_num,wait_bar_handle);
end
delete(wait_bar_handle);

imshow(mean_ev_out, [0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, ['Image segmentation using Mean-EV Filter'],'TM',10); 

end