%% Evolutionary Models
%  Illustration of different noise types in digital images.
%% Experiment Description:
% This experiment illustrates the different noises effect digital image
% capturing, and the noise effect on the 1D power spectrum and auto
% correlation function of the image.
%
% A method of detecting the noise from the power spectrum is also
% introduced, and its sensitivity is controllable.
% 
% The noises introduced are:
% * Additive Gaussian Noise
% * Periodic Noise
% * Row - Column Noise
% * Shot Noise
% * Impulse Noise
%% Tasks: 
%% Instruction:
%% Theoretical Background:
% One of the first Stochastic growth models was suggested by M. Eden . In
% Eden’s model, growth was simulated as a sequence of random “births”
% taking place on a rectangular lattice (raster) with the probability
% proportional to the number of already “live” cells in the nearest spatial
% 3x3 vicinity of the given cell (left and right neighbors at the same row,
% 3 and 3 neighbors on the rows from above and from bottom). Eden’s model
% can be mathematically represented as an iterative equation: 
%
% $$ I^t(x,y) = rand
%
% where ((k , l )) are pixel coordinates on the lattice, 1
% 8
% S t-- is the sum of pixel values in 8
% neighbor points in the 3x3 neighborhood of the given pixel, t is iteration index, randb(P) is
% a binary random variable that takes value of one with probability P and ? denotes
% modulo 2 addition of binary numbers. Fig. 3a shows how this model can be implemented in
% a system that is just a slightly modified and extended version of the system of Fig. 2. This
% system contains, as an individual unit, a pseudo-random number generator of Fig. 1
% which is now included in the same loop of a linear filter, point-wise non-linearity and a
% delay unit. Impulse response of the linear filter and transfer function of the point-wise
% non-linearity are shown in the corresponding boxes in Fig. 3. The combination of the
% pseudo-random number generator and the point-wise non-linearity with a threshold
% transfer function forms a unit that implements an operation randb(P) of generating binary
% numbers 0-s and 1-s with a given probability of 1-s. The model assumes that each cell
% (pixel) has one of two possible states, zero and one. On binary images, the linear filter
% with impulse response as shown in Fig. 3a computes the number of 1-s in the 3x3
% neighborhood (8-neighbor sum 8 S ) of each pixel thus defining the threshold level of the
% point-wise non-linearity.
% Clearly, this simple model describes unlimited growth. One can, however, easily
% modify this model to simulate drain of “sources of food” by measuring the size of the
% growing formation and introducing a corresponding saturation to the probability of
% “birth” as it is shown in schematic diagram of Fig. 3b. In this scheme, the randb(P) unit of
% Fig. 3 a is preceded by a (x y ) -- - point-wise non-linearity that implements the saturation.
% This modified model can be described by equation
% (( )) ( (( )) ) (( )) , randb 1 / 8 (( , )) 1
% 1
% 8
% -- -- ºº++ --
% ??
% ?? ??
% ??
% == ??
% - - t t cS t output k l S output k l
% t
% gl , (3)
% where ((t --1 ))
% Sgl is a “global” sum over the entire field that defines the size of the formation
% on (t-1)-th iteration (evolution) step.
%
% *Conway’s “Game of Life” and its modifications*
%
% A mathematical model known as Conway’s “Game of Life” represents a
% growth models where cells on a rectangle lattice (raster) can give a
% “births” or “die out” depending on the number of “alive” and empty cells
% in their nearest spatial neighborhood. The rules of the original “Game of
% life” are very simple: if an empty cell has exactly 3 “alive” neighbor
% cells in its 3x3 neighborhood, birth takes place on the next step of the
% evolution; if an “alive” cell has less than 2 or more than 3 “alive”
% cells in the neighborhood it will die on the next step; otherwise nothing
% happens. These rules can be formally described by the equation: 
%
% $$ I^t(x,y) = I^{t-1}(x,y) \cdot \delta\left(S_8^{t-1}(x,y) - 2\right)+ \delta\left(S_8^{t-1}(x,y) - 3\right)  $$
% 
% where $\delta(*)$ is Kronecker delta: 
%
% $$ \delta(x) =
% \left\{\begin{array}{ll}
% 0 & x=0 \\  1 & x=1 \end{array}\right. $$
% 
% And $ S_8^{t-1}(x,y) $ is the  is the sum of the values in 8-neighborhood
% of $(x,y)$-th pixel (“cell” in the growth model terminology),  and $t$ is
% iteration number.
% 
% $$ S_8^{t-1}(x,y)  =  \left(\sum_{i=-1}^{i=1}\sum_{j=-1}^{j=1}I^{t-1}(x-i, y-j)\right)- I^{t-1}(x,y)$$
%
% number and “alive” and “empty” cells are represented by “ones” and “zeros”,
% respectively. 
%
% Original model8 assumed a deterministic initial distribution of zeros and ones
% in the field. 
%
% By introducing “random” initial distribution of “alive” and empty cells the
% model can be made stochastic. 
%
% Where:
%
% $$ N_{row}(x,y) = \left\{\begin{array}{ll}
% Z & x = 1\\ 
% N_{row}(x-1,y) & x>1 \\
% \end{array}\right.$$
%
% $$ N_{column}(x,y) = \left\{\begin{array}{ll}
% Z & y = 1\\ 
% N_{column}(x,y-1) & y>1 \\
% \end{array}\right.$$
%
% and 
%
% $$  Z \sim \mathcal{N}  \left(  \mu, \sigma \right) $$ 
%
%% Reference:
% * L. Yaroslavsky, From Random Numbers to Stochastic Growth Models and
% Texture Images, In: Pattern Formation, M. Gromov and A. Carbone, Eds.,
% World Scientific Publishing Co, Singapore, 1999, pp. 42—64 

function EvolutionaryModels = EvolutionaryModels_mb( handles )
% 8.3 Image registration
% Write a program for alignment; using matched filtering, images arbitrarily displaced in both co-ordinates. Use for experiments video frames or stereo images.
    handles = guidata(handles.figure1);

    axes_hor = 2;
    axes_ver = 2;
%     is_outerposition = zeros(1, axes_hor*axes_ver);
%     is_outerposition(3:4) = 1;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    EvolutionaryModels = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9);

    
%%
    EvolutionaryModels.Size  = 64;
    EvolutionaryModels.Niter = 4;
    EvolutionaryModels.Size  = 64;
    
%     EvolutionaryModels.Live_Thr = 0.5;
%     EvolutionaryModels.sigma    = 24;
%     EvolutionaryModels.Lapl     = 0;
%     EvolutionaryModels.Quant    = 256;
    
    EvolutionaryModels.Plive    = 0.5;
    EvolutionaryModels.Pbirth   = 1;
    EvolutionaryModels.Pdeath   = 0.2;
    EvolutionaryModels.History  = 1;
    EvolutionaryModels.Thr      = 0.5;
    EvolutionaryModels.LX = 5;
    EvolutionaryModels.LY = 5;
    EvolutionaryModels.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    EvolutionaryModels.EvMod    = 'Mode over Window model';
    

    %
    k=1;
    interface_params(k).style = 'pushbutton';
    interface_params(k).title = 'Run Experiment';
    interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;

    interface_params =  SetSliderParams('Set Window Width', 25, 1, EvolutionaryModels.LX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'LX',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set Window Height', 25, 1, EvolutionaryModels.LY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'LY',@update_sliders), interface_params, k);
    k=k+1;
    interface_params =  SetSliderParams('Set Number of Iterations', 1000, 1, EvolutionaryModels.Niter, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Niter',@update_sliders), interface_params, k);
    k=k+1;

    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose Evolutionary Model';
    interface_params(k).selection ={ 'Mode over Window model', 'Stochastic Game of Life model' , 'Dendrites model'};   
    interface_params(k).callback = @(a,b)ChooseEvolutionaryModel(a,b,handles);  
    interface_params(k).value = find(strcmpi(interface_params(k).selection, EvolutionaryModels.EvMod));
    
    
    
    
    
    
    
    
    
    

    EvolutionaryModels.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
     
    imshow(uint8(EvolutionaryModels.im), 'parent', EvolutionaryModels.axes_1);
    title('Test image', 'parent', EvolutionaryModels.axes_1, 'fontweight', 'bold'); 


%     process_image(EvolutionaryModels.EvMod, EvolutionaryModels.Size, EvolutionaryModels.Niter,  EvolutionaryModels.Live_Thr, EvolutionaryModels.sigma, ...
%     EvolutionaryModels.Lapl, EvolutionaryModels.Quant, EvolutionaryModels.Plive, EvolutionaryModels.Pbirth, EvolutionaryModels.Pdeath ,...
%     EvolutionaryModels.History, EvolutionaryModels.Thr , ... 
%     EvolutionaryModels.axes_1, EvolutionaryModels.axes_2, EvolutionaryModels.axes_3, EvolutionaryModels.axes_4);

end
function ChooseEvolutionaryModel(slider_handles,y,z)
    EvMod = get(y.NewValue, 'string');
    handles = guidata(slider_handles);
    delete(handles.(handles.current_experiment_name).axes_1);
    delete(handles.(handles.current_experiment_name).axes_2);
    delete(handles.(handles.current_experiment_name).axes_3);
    delete(handles.(handles.current_experiment_name).axes_4);
    delete(handles.(handles.current_experiment_name).buttongroup_handle);
    if ( strcmpi('Dendrites model', EvMod))
    axes_hor = 2;
    axes_ver = 1;
    else
    axes_hor = 2;
    axes_ver = 2;
    end
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    handles.(handles.current_experiment_name) = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9);

    handles.(handles.current_experiment_name).Size  = 64;
    
    handles.(handles.current_experiment_name).Size  = 64;
    
    handles.(handles.current_experiment_name).Plive    = 0.5;
    handles.(handles.current_experiment_name).Pbirth   = 1;
    handles.(handles.current_experiment_name).Pdeath   = 0.2;
    handles.(handles.current_experiment_name).History  = 1;
    handles.(handles.current_experiment_name).Thr      = 0.5;
    handles.(handles.current_experiment_name).LX = 5;
    handles.(handles.current_experiment_name).LY = 5;
    handles.(handles.current_experiment_name).im = HandleFileList('load' , HandleFileList('get' , handles.image_index));

    
    handles.(handles.current_experiment_name).EvMod = EvMod;

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
    switch handles.(handles.current_experiment_name).EvMod
        case {'Dendrites model'}
        handles.(handles.current_experiment_name).Niter = 50;
        handles.(handles.current_experiment_name).axes_3 = [];
        handles.(handles.current_experiment_name).axes_4 = [];    
    %%dendrite

        interface_params =  SetSliderParams('Set Threshold', 1, 0, handles.(handles.current_experiment_name).Thr, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Thr',@update_sliders), interface_params, k);
        k=k+1; 
        interface_params =  SetSliderParams('Set Size', 256, 64, handles.(handles.current_experiment_name).Size, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Size',@update_sliders), interface_params, k);     

        val = 3;
        case {'Mode over Window model'}   
        %% con
        handles.(handles.current_experiment_name).Niter = 5;
        interface_params =  SetSliderParams('Set Window Width', 25, 1, handles.(handles.current_experiment_name).LX, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Live_Thr',@update_sliders), interface_params, k);
        k=k+1;
        interface_params =  SetSliderParams('Set Window Height', 25, 1, handles.(handles.current_experiment_name).LY, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'sigma',@update_sliders), interface_params, k);

        val = 1;
        imshow(uint8(handles.(handles.current_experiment_name).im), 'parent', handles.(handles.current_experiment_name).axes_1);
        title('Test image', 'parent', handles.(handles.current_experiment_name).axes_1, 'fontweight', 'bold'); 
        case { 'Stochastic Game of Life model' } 

    %    %% life
        handles.(handles.current_experiment_name).Niter = 50;
        interface_params =  SetSliderParams('Set Life Probability', 1, 0, handles.(handles.current_experiment_name).Plive, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Plive',@update_sliders), interface_params, k);
        k=k+1;
        interface_params =  SetSliderParams('Set Birth Probability', 1, 0, handles.(handles.current_experiment_name).Pbirth, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Pbirth',@update_sliders), interface_params, k);
        k=k+1;
        interface_params =  SetSliderParams('Set Death Probability', 1, 0, handles.(handles.current_experiment_name).Pdeath, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Pdeath',@update_sliders), interface_params, k);
        k=k+1;  	
        interface_params(k).style = 'buttongroup';
        interface_params(k).title = 'Choose what to display';
        interface_params(k).selection ={ 'currant state is displayed', 'history is displayed'};
        if (handles.(handles.current_experiment_name).History )
            interface_params(k).value = 1;
        else
            interface_params(k).value = 0;
        end
        interface_params(k).callback = @(a,b)ChangeHistory(a,b,handles);
        k=k+1; 
        interface_params =  SetSliderParams('Set Size', 256, 64, handles.(handles.current_experiment_name).Size, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Size',@update_sliders), interface_params, k);     
        val = 2;
    end
%%%common
    k=k+1;

    interface_params =  SetSliderParams('Set Number of Iterations', 1000, 1, handles.(handles.current_experiment_name).Niter, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Niter',@update_sliders), interface_params, k);
    k = k+1;
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose Evolutionary Model';
    interface_params(k).selection ={ 'Mode over Window model', 'Stochastic Game of Life model' , 'Dendrites model'};   
    interface_params(k).value = val;
    interface_params(k).callback = @(a,b)ChooseEvolutionaryModel(a,b,handles);  
    handles.(handles.current_experiment_name).buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
     
    guidata(handles.figure1, handles);
    if ( strcmpi(handles.interactive, 'on') )
        EvolutionaryModels = handles.(handles.current_experiment_name);

    process_image(EvolutionaryModels.EvMod, EvolutionaryModels.Size, EvolutionaryModels.Niter, ...
    EvolutionaryModels.LX, EvolutionaryModels.LY, EvolutionaryModels.im, EvolutionaryModels.Plive, EvolutionaryModels.Pbirth, EvolutionaryModels.Pdeath ,...
    EvolutionaryModels.History, EvolutionaryModels.Thr , ... 
    EvolutionaryModels.axes_1, EvolutionaryModels.axes_2, EvolutionaryModels.axes_3, EvolutionaryModels.axes_4);
    end
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
    EvolutionaryModels = handles.(handles.current_experiment_name);
    process_image(EvolutionaryModels.EvMod, EvolutionaryModels.Size, EvolutionaryModels.Niter, ...
    EvolutionaryModels.LX, EvolutionaryModels.LY, EvolutionaryModels.im, EvolutionaryModels.Plive, EvolutionaryModels.Pbirth, EvolutionaryModels.Pdeath ,...
    EvolutionaryModels.History, EvolutionaryModels.Thr , ... 
    EvolutionaryModels.axes_1, EvolutionaryModels.axes_2, EvolutionaryModels.axes_3, EvolutionaryModels.axes_4);

end


function ChangeHistory(a,b, handles)
    handles = guidata(handles.figure1);
    history = get(get(a, 'SelectedObject'), 'string');
    if ( strcmpi(history, 'currant state is displayed'))
        handles.(handles.current_experiment_name).History = 0;
    else
        handles.(handles.current_experiment_name).History = 1;
    end
    guidata(handles.figure1,handles);
end



function    process_image(EvMod, Size, Niter,  LX, LY,    OUTIMG, Plive, Pbirth, Pdeath ,...
    History, Thr ,axes_1, axes_2, axes_3, axes_4)

switch EvMod
    case {'Dendrites model'}
    N = Size;
    Iter = Niter;
    dendrite_mb(N,Thr,Iter, axes_1, axes_2);
    case {'Mode over Window model'}
%     SzX = Size;
%     SzY = Size;
%     conway_mb(SzX,SzY,Live_Thr,sigma,Lapl,Quant,Niter,5, axes_1, axes_2, axes_3, axes_4);
    InIm = OUTIMG;
    std_prev_curr = zeros(1, Niter);
    for i = 1 : Niter
        OUTIMG=mode_es_mb(InIm,LX,LY,axes_2, i);
        diff = OUTIMG - InIm;
        imshow(abs(diff), [], 'parent', axes_3);
        DisplayAxesTitle(axes_3, ['Absolut diff of current and previous images'], 'BM');
        std_prev_curr(i) = sqrt(var(diff(:)));
        plot([0:i-1], std_prev_curr(1:i), 'parent', axes_4, 'linewidth', 2);
        grid(axes_4, 'on'); axis(axes_4, 'tight');
        DisplayAxesTitle(axes_4, ['Standard deviation of the current- previous image'], 'BM',10); 
        InIm = OUTIMG;
    end
    case { 'Stochastic Game of Life model' } 
    Iter = Niter;
    lifebin1_mb(Size,Iter,Plive,Pbirth,Pdeath,History, axes_1, axes_2, axes_3, axes_4);
end



end


