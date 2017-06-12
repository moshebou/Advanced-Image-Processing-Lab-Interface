%% Filtering Additive Noise
%  Study of Additive Noise Filtering using pixel neighbourhoods    
%% Experiment Description:
% This experiment demonstrates the different filtering algorithms of
% Additive Noise with different Neighborhoods types and different smoothing
% (estimation) operations. 
%% Tasks:
% 11.2 
% 
% * Generate a test image "a rectangle on an uniform background". 
% * Test additive noise suppression and edge preserving capability of rank
% * filters on the test image (programs mean_ev.m, medn_ev.m, mean_er.m,
% medn_er.m). 
% * Apply these filters to real life images with and without noise. 
% * Apply the filtering iteratively. 
% * Observe residual error. 
%% Instruction:
% 'Set Number of Iterations' - determines number of iteration of the
% algorithm.
%
% 'Set AWGN STD' - determines the additive White Gaussian Noise STD.
%
% 'Set Positive EV offset' - Choose the positive offset from each window
% center pixel value.
%
% 'Set Negative EV offset' - Choose the negative offset from each window
% center pixel value.
%
% 'Set Positive ER Offset'- Choose the negative offset from selected pixel
% rank, which considered as same segment.
%
% 'Set Negative ER Offset'- Choose the negative offset from selected pixel
% rank, which considered as same segment.
%
% 'Set Window Width'- Choose the negative offset from selected pixel
% value, which considered as same segment.
%
% 'Set Window Height'- Choose the threshold  offset from selected pixel
% value, which considered as same segment.
%% Theoretical Background:
% _*Rank filters for smoothing additive noise*_
%
% The rank filtering is a locally adaptive processing of the signal in a
% moving window. Rank filtering additive noise can be described by equation:
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
% This experiment will focus on $MEAN$ and $MEDIAN$ smoothing operation,
% with $\epsilon V$ and $\epsilon R$ neighborhoods.
%
% For more details on the different neighborhoods types and definitions,
% please check the "Pixel Neighborhoods" experiment.
%% Algorithm:
% AWGN is first added to the Input image $I$.
%
% $$ I_{NOISE} = I + W $$
% 
% Where $W\sim \mathcal{N} \left(0, \sigma^2 \right)$. The Result image
% ($I_{NOISE}$) is the input for all filtering algorithms. 
%
% _*Mean $\epsilon V-$ neighborhood*_
%
% <html>
% <pre class="codeinput">
% <p>Code:
% mean_ev_out = I_NOISE;
% im_tmp =  mean_ev_out;
% for Iter_num =1 : iteration_num
%     for each pixel in image I at position x,y
%         sum = 0; element_num = 0;
%         for i = x-Lx : x+Lx
%             for j = y-Ly : y+Ly
%                 if ( mean_ev_out(i,j) is in EVneighborhood of {mean_ev_out(x,y)} )
%                     sum =  sum + mean_ev_out(i,j);
%                     element_num = element_num + 1;
%                 end
%             end
%         end
%         im_tmp(x,y) = sum/element_num;
%     end
%     mean_ev_out = im_tmp;
% end
% </p>
% </pre>
% </html>
%
% _*Median $\epsilon V-$ neighborhood*_
%
% <html>
% <pre class="codeinput">
% <p>Code:
% median_ev_out = I_NOISE;
% im_tmp =  median_ev_out;
% for Iter_num =1 : iteration_num
%     for each pixel in image I at position x,y
%         element_num = [];
%         for i = x-Lx : x+Lx
%             for j = y-Ly : y+Ly
%                 if ( median_ev_out(i,j) is in EVneighborhood of {median_ev_out(x,y)} )
%                     sum =  sum + median_ev_out(i,j);
%                     element_num = element_num + 1;
%                 end
%             end
%         end
%         im_tmp(x,y) = median(elements);
%     end
%     median_ev_out = im_tmp;
% end
% </p>
% </pre>
% </html>
%
% _*Mean $\epsilon R-$ neighborhood*_
%
% <html>
% <pre class="codeinput">
% <p>Code:
% mean_er_out = I_NOISE;
% im_tmp =  mean_er_out;
% for Iter_num =1 : iteration_num
%     for each pixel in image I at position x,y
%         for i = x-Lx : x+Lx
%             for j = y-Ly : y+Ly
%                 if ( mean_er_out(i,j) is in ERneighborhood of {mean_er_out(x,y)} )
%                     sum =  sum + mean_er_out(i,j);
%                     element_num = element_num + 1;
%                 end
%             end
%         end
%         im_tmp(x,y) = sum/element_num;
%     end
%     mean_er_out = im_tmp;
% end
% </p>
% </pre>
% </html>
%
% _*Median $\epsilon R-$ neighborhood*_
%
% <html>
% <pre class="codeinput">
% <p>Code:
% median_er_out = I_NOISE;
% im_tmp =  median_er_out;
% for Iter_num =1 : iteration_num
%     for each pixel in image I at position x,y
%         element_num = [];
%         for i = x-Lx : x+Lx
%             for j = y-Ly : y+Ly
%                 if ( median_er_out(i,j) is in ERneighborhood of {median_er_out} )
%                     elements = [elements, median_er_out(i,j) ];
%                 end
%             end
%         end
%         im_tmp(x,y) = median(elements);
%     end
%     median_er_out = im_tmp;
% end
% </p>
% </pre>
% </html>
%% Reference
% * [1] Yaroslavsky L.P., Kim V., “Rank Algorithms for Picture Processing, Computer Vision”, Graphics and Image Processing, v. 35, 1986, p. 234-258 
% * [2] L. Yaroslavsky, M. Eden, Fundamentals of Digital Optics, Birkhauser, Boston,1996
% * [3] <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/AdvImProc_4.pdf Lecture Notes: Image restoration and enhencement: non-linear filters>
% * [4] <http://www.eng.tau.ac.il/~yaro/RecentPublications/ps&pdf/nonlin_filters.pdf non-linear Signal Processing Filters: A Unification Approach>


function FilteringAdditiveNoise = FilteringAdditiveNoise_mb(handles)
	handles = guidata(handles.figure1);
	axes_hor = 2;
	axes_ver = 2;
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	FilteringAdditiveNoise = DeployAxes( handles.figure1, ...
	[axes_hor, ...
	axes_ver], ...
	bottom, ...
	left, ...
	0.9, ...
	0.9); 
	% init params
	FilteringAdditiveNoise.WdSzX = 9;%3;
	FilteringAdditiveNoise.WdSzY = 9;%3;
	FilteringAdditiveNoise.evpos = 20; %5;
	FilteringAdditiveNoise.evneg = 20;%5;
	FilteringAdditiveNoise.std   = 20;%2;
	FilteringAdditiveNoise.iteration_num = 3;
	FilteringAdditiveNoise.im = HandleFileList('load' , HandleFileList('get' , handles.image_index)); 

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	
	k=k+1;
% 	interface_params =  SetSliderParams('Set positive EV offset', 200, 1, FilteringAdditiveNoise.evpos, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evpos',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set EVplus for EV-neighborhood', 100, 1, FilteringAdditiveNoise.evpos, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evpos',@update_sliders), interface_params, k);
	k=k+1;
% 	interface_params =  SetSliderParams('Set Negative EV offset', 200, 1, FilteringAdditiveNoise.evneg, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evneg',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set EVminus for EV-neighborhood', 100, 0, FilteringAdditiveNoise.evneg, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'evneg',@update_sliders), interface_params, k);
	k=k+1;
% 	interface_params =  SetSliderParams('Set Number Of Iterations', 10, 0, FilteringAdditiveNoise.iteration_num, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'iteration_num',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set number of filtering iterations', 5, 1, FilteringAdditiveNoise.iteration_num, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'iteration_num',@update_sliders), interface_params, k);
    k=k+1;
% 	interface_params =  SetSliderParams('Set Window Width', 17, 1, FilteringAdditiveNoise.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set filter window width', 75, 1, FilteringAdditiveNoise.WdSzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzX',@update_sliders), interface_params, k);

	k=k+1;
% 	interface_params =  SetSliderParams('Set Window Height', 17, 1, FilteringAdditiveNoise.WdSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set filter window height', 75, 1, FilteringAdditiveNoise.WdSzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WdSzY',@update_sliders), interface_params, k);
	
    k=k+1;
% 	interface_params =  SetSliderParams('Set AWGN STD', 128, 0, FilteringAdditiveNoise.std, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'std',@update_sliders), interface_params, k);
    interface_params =  SetSliderParams('Set range of additive noise', 50, 0, FilteringAdditiveNoise.std, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'std',@update_sliders), interface_params, k);
	
	

	FilteringAdditiveNoise.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
	 
    imshow(FilteringAdditiveNoise.im, [0 255], 'parent', FilteringAdditiveNoise.axes_1);
    DisplayAxesTitle( FilteringAdditiveNoise.axes_1, ['Test image'], 'TM',10); 
% 	process_image (FilteringAdditiveNoise.im, FilteringAdditiveNoise.evpos, FilteringAdditiveNoise.evneg, FilteringAdditiveNoise.erpos, ...
% 	FilteringAdditiveNoise.erneg, FilteringAdditiveNoise.WdSzX, FilteringAdditiveNoise.WdSzY, FilteringAdditiveNoise.std, ...
% 	FilteringAdditiveNoise.iteration_num, FilteringAdditiveNoise.axes_1, FilteringAdditiveNoise.axes_2, FilteringAdditiveNoise.axes_3, FilteringAdditiveNoise.axes_4);
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



process_image (handles.(handles.current_experiment_name).im, handles.(handles.current_experiment_name).evpos, handles.(handles.current_experiment_name).evneg, ...
    handles.(handles.current_experiment_name).WdSzX, handles.(handles.current_experiment_name).WdSzY, handles.(handles.current_experiment_name).std, ...
    handles.(handles.current_experiment_name).iteration_num, handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_2, handles.(handles.current_experiment_name).axes_3, handles.(handles.current_experiment_name).axes_4);
end

function process_image (im, evpos, evneg, WdSzX, WdSzY, std, iteration_num,...
    axes_1, axes_2, axes_3, axes_4)
% im = im + std*randn(size(im));
% im_n = im + std*(rand(size(im))-0.5)*sqrt(12);
im_n = im + 2*std*(rand(size(im))-0.5);
mean_ev_out = im_n;%im
medn_ev_out = im_n;%im
% mean_er_out = im;
% medn_er_out = im;
imshow(im_n, [0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, ['Test image with noise'],'TM',10); 

wait_bar_handle = waitbar(0,'please wait') ;
for i =1 : iteration_num,

    imshow(mean_ev_out, [0 255], 'parent', axes_3);
    imshow(medn_ev_out, [0 255], 'parent', axes_4);

%     imshow(mean_ev_out, [0 255], 'parent', axes_1);
%     imshow(medn_ev_out, [0 255], 'parent', axes_2);
%     imshow(mean_er_out, [0 255], 'parent', axes_3);
%     imshow(medn_er_out, [0 255], 'parent', axes_4);
    drawnow;
    mean_ev_out=mean_ev_mb(mean_ev_out,WdSzX,WdSzY,evpos,evneg);
    waitbar(0.25/iteration_num+(i-1)/iteration_num,wait_bar_handle);
    medn_ev_out=medn_ev_mb(medn_ev_out,WdSzX,WdSzY,evpos,evneg);
    waitbar(0.5/iteration_num+(i-1)/iteration_num,wait_bar_handle);
%     mean_er_out=mean_er_mb(mean_er_out,WdSzX,WdSzY,erpos,erneg);
%     waitbar(0.75/iteration_num+(i-1)/iteration_num,wait_bar_handle);
%     
%     medn_er_out=medn_er_mb(medn_er_out,WdSzX,WdSzY,erpos,erneg);
%     waitbar(i/iteration_num,wait_bar_handle);
end
delete(wait_bar_handle);

imshow(mean_ev_out, [0 255], 'parent', axes_3);
imshow(medn_ev_out, [0 255], 'parent', axes_4);


DisplayAxesTitle( axes_3, ['Filtering result: Mean-EV Filter'],'BM',10); 
DisplayAxesTitle( axes_4, ['Filtering result: Median-EV Filter'],'BM',10);

% imshow(mean_ev_out, [0 255], 'parent', axes_1);
% imshow(medn_ev_out, [0 255], 'parent', axes_2);
% imshow(mean_er_out, [0 255], 'parent', axes_3);
% imshow(medn_er_out, [0 255], 'parent', axes_4);
% DisplayAxesTitle( axes_1, ['Filtering result: Mean-EV Filter'], 'TM',10); 
% DisplayAxesTitle( axes_2, ['Filtering result: Median-EV Filter'],'TM',10); 
% DisplayAxesTitle( axes_3, ['Filtering result: Mean-ER Filter'],'BM',10); 
% DisplayAxesTitle( axes_4, ['Filtering result: Median-ER Filter'],'BM',10); 
end