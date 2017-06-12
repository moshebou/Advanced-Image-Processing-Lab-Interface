%% Image Quantization
%  uniform, P-law, and Lloyd-Max quantization.
%% Experiment Description:
% Illustration of uniform quantization, Lloyd-Max quantization and
% P-law quantization of one dimensional signal.
%
% This experiment present the original signal without noise, and the same
% signal with noise, after quantization.
%
% Another plot demonstrate the mapping of each quantization method, and the
% original signal histogram.
%
%% Tasks:
% 2.1.2 
%
% * Write a program for uniform image quantization. 
% * Test uniform quantization of images to 2-64 levels. 
% * Observe false contours. 
% * Find number of quantization levels that do not produce visible false contours. 
% * Compare the obtained result with the threshold visibility contrast found in the task 2.1.1. 
% * Test quantization with additive noise. 
% *  Find a relationship between the number of quantization levels, intensity of noise and visibility of false contours.
%
% 2.1.3
%
% * Write a program for image quantization which uses the Lloyd-Max quantization algorithm.
%
% 2.2.1
%
% * Generate, for x=1:512, a signal sgn=1-abs(sin(pi*x/128)); Apply to this signal uniform (program quantize.m) and non-uniform (program nlquantz.m with P<1)
% quantization and observe quantization effects (to display graphs, use program stairs.m).
% * Suggest another example of a signal that requires non-uniform quantization.
%
% 2.2.2 
% 
% * Compare uniform and non-uniform P-th law quantization of a test-signal (signals ecg1.mat, ecg256.mat may be used). 
% * Find, for a given number of quantization levels, optimal non-linearity index that minimizes RMS error of signal reconstruction.
%
%% Instruction:
% Use the 'Set AWGN STD' slider to set the standard deviation of the additive
% white Gaussian noise added to the signal.
%
% Use the 'Set p for the Pth-law quantization' to set the p parameter of
% the p-law quantization (see Theoretical Background).
%
%% Theoretical Background:
% In order for a continuous signal to be represented and processed digitally, it needs to be digitized. 
%
% Specifically, the digitization includes the quantization of the
%  intensity function values and the sampling of the continues function.  
%
% Correspondingly, the digital processing of the image can be classified
% into intensity (gray level) operations applied to the pixel values and
% geometric  operations in the two spatial dimensions. 
% 
% *Quantization Methods*
%  There are different methods for quantization of a signal, each of them
%  designed to solve a different problem.
% Some of these methods are introduced in this document.
% For all of the following quantization methods, the input analog signal
% $f$ is considered to be with the continues range of $0 \le f \le G$ (as is
% the case for captured images, electrical signal etc).
%
% *Uniform Quantization*
% 
% Define $L+1$ boundaries
%
% $$ t_k=kG/L=k\Delta,\;\;\;(k=0,1,\cdots,L)$$
%
% where $\Delta\stackrel{\triangle}{=}G/L$. And define the $L$ discrete gray 
% levels to represent the L intervals:
%
% $$ r_k=t_k+ \frac {\Delta}{2}=  k \Delta +\frac {\Delta}{2} = \left(\frac
% {k \Delta + k \Delta + \Delta }{2}\right) = \frac {t_k+t_{k+1}}{2}$$ 
% 
% Then the quantization can be defined as a function:
%
% $$x'=f(x)=r_k,\;\;\;\;\mbox{iff}\;\;t_k \le x \le t_{k+1}$$
% 
% <<linear_quantize.png>>
% 
% *Mean square error optimization*
% 
% Define mean square error of the quantization process as
%
% $$ {\cal E} = E[ (x-x')^2]=\int_{-\infty}^\infty (x-x')^2 p(x)dx=
% \sum_{i=0}^{L-1} \int_{t_i}^{t_{i+1}} (x-r_i)^2 p(x)dx $$
%
% where $p(x)$ is distribution of input intensify $x$. The optimal quantization 
% in terms of $t_k$ and $r_k$ can be found by minimizing $\epsilon$, by solving
%
% $$ \frac{\partial {\cal E}}{\partial t_k}=\frac{\partial {\cal
% E}}{\partial r_k}=0 $$
%
% This method requires $p(x)$ to be known. The Uniform Quantization is optimal when
% $p(x)$ is a uniform distribution. When $p(x)$ is not uniform, more gray levels
% will be assigned to the gray scale regions corresponding to higher $p(x)$.
% 
% 
% *Mean square error (MSE) optimization using k-means (aka Iterative Lloyd-Max quantizer)*
%
% one method of achieving a near optimized MSE is the use of K-Means
% algorithm, where $K=L=2^N$.
%
% _Description_
%
% Given a set of observations ${ x_1, x_2, ... , x_n }$, where each observation
% is a $d$-dimensional real vector, $k$-means clustering aims to partition
% the $n$ observations into $k$ sets, $k \le n$: $S = {S_1, S_2, ... , S_k}$
% so as to minimize the within-cluster sum of squares (WCSS):  
% 
% $$ arg\,min_{S} \sum_{i=1}^{k} \sum_{x_j \in S_i} \left\| x_j - \mu_i
% \right\|^2 $$
% 
% where $\mu_i$ is the mean of points in $S_i$.
% The main idea of the algorithm is to separate
% the problem into 2 phases:
%
% 1. Assignment step: Assign each observation to the cluster whose mean
% yields the least within-cluster sum of squares: 
% 
% $$ \mathcal{S}_{i}^{t} = \left\{ x_p : \left\| x_p - \mu_{i}^{t}
% \right\|  \le \left\| x_p -
% \mu_{j}^{t} \right\| \right\}$$
%
% 2. Update step: Calculate the new means to be the centroids of the observations in the new clusters.
%
% $$ \mu_{i}^{t+1} = \frac{1}{\left|S_i^t\right|} \sum_{x_j\in S_i^t} x_j
% $$
%
% <html>
% <pre class="codeinput">
% <p>Code:
%    function [OUTIMG, unique_quant]= LloydMaxQunt( InImage,Q, im_unique )
%    InImage = double(InImage);
%    im = (InImage - min(InImage(:)))/(max(InImage(:)) - min(InImage(:)));
%    x = unique(im(:)');
%    y = cumsum([0 1/Q*ones(1,Q-1)]);
%    y_interp = interp1(linspace(min(y(:)), max(y(:)), length(y)), y, linspace(0,1, length(x)), 'nearest','extrap');
%    curr_y = inf;
%    k=0;
%    for i=1:length(x)
%        p_x(i) = sum(im(:) == x(i))/length(im(:));
%        if ( y_interp(i) == curr_y)
%          y_x_indexs{k} = [y_x_indexs{k}, i];
%        else
%           if ( k > 0 ) 
%                rms_per_y(k) = sum(((curr_y - x(y_x_indexs{k})).^2).*p_x(y_x_indexs{k}));
%            end
%            k=k+1;
%            y_x_indexs{k} = i;
%            curr_y = y_interp(i); 
%        end
%    end
%    rms_per_y(k) = sum(((curr_y - x(y_x_indexs{k})).^2).*p_x(y_x_indexs{k}));
%    rms = sum(p_x.*((x-y_interp).^2));
%    rms_new = 0;
%    while (rms ~= rms_new )
%        rms = rms_new;
%      %    redistribute the x to the y groups
%      for i=1:length(y_x_indexs)-1
%          while (((y(i) - x(y_x_indexs{i}(end)))^2) > ((y(i+1) - x(y_x_indexs{i}(end)))^2))
%              if ( ~isempty(y_x_indexs{i}(1:end-1)))
%                  y_x_indexs{i+1} = [y_x_indexs{i}(end), y_x_indexs{i+1}]; 
%                  y_x_indexs{i} = y_x_indexs{i}(1:end-1);
%              else
%                  y(i)= x(y_x_indexs{i}(end));
%              end
%          end
%          while (((y(i) - x(y_x_indexs{i+1}(1)))^2) <((y(i+1) - x(y_x_indexs{i+1}(1)))^2))
%              if ( ~isempty(y_x_indexs{i+1}(2:end)))          
%                  y_x_indexs{i} = [y_x_indexs{i}, y_x_indexs{i+1}(1)];
%                  y_x_indexs{i+1} = y_x_indexs{i+1}(2:end); 
%              else
%                  y(i+1)= x(y_x_indexs{i+1}(1));
%              end
%          end
%      end
%      %    recalculate y for minimal rms
%      for i=1:length(y_x_indexs)
%              y(i) = sum(x(y_x_indexs{i}).*p_x(y_x_indexs{i}))/sum(p_x(y_x_indexs{i}));
%              rms_per_y(i) = sum(((y(i) - x(y_x_indexs{i})).^2).*p_x(y_x_indexs{i}));
%      end
%      rms_new = sum(rms_per_y);
%    end
%    for i=1:length(y_x_indexs)
%        im(logical( (im >= x(y_x_indexs{i}(1))).* (im <=x(y_x_indexs{i}(end)))))= y(i);    
%    end
%    im_unique = (im_unique  - min(InImage(:)))/(max(InImage(:)) - min(InImage(:)));
%    unique_quant = zeros(size(im_unique));
%    for i=1:length(im_unique)
%        k=1;
%         while((k<length(y_x_indexs) )&& (im_unique(i)>x(y_x_indexs{k}(end))))
%             k=k+1;
%         end
%         unique_quant(i) = y(k);
%    end 
%    OUTIMG = im .*(max(InImage(:)) - min(InImage(:))) +  min(InImage(:));
%    unique_quant = unique_quant.*(max(InImage(:)) - min(InImage(:))) +  min(InImage(:));
% </p>
% </pre>
% </html>
%
% *Contrast equalization*
% 
% The perceived contrast is a function of the intensity. Specifically, we 
% perceive the same contrast between the object and its surrounding if:
%
% $$ \frac{\Delta f}{f} \approx \frac{df}{f}=d(ln\,f)=constant $$
%
% where $f$ is the intensity and $\Delta f \approx df$ is the intensity 
% difference, the Absolute contrast <http://en.wikipedia.org/wiki/Weber-Fechner_law Weber-Fechner_law>). 
%
% For example, 
%
% $$\frac{20-10}{10}=\frac{200-100}{100}$$
%
% i.e., a high contrast of $\Delta f=200-100=100$ at a high Absolute intensity 
% $f=100$ is perceived the same as a much lower contrast of $\Delta f=20-10=10$ 
% at a low Absolute intensity $f=10$. 
%
% In other words,, we are less sensitive to contrast when the intensity $f$
% is high. As another example, consider the perceived brightness of a 3-way
% light bulb with 50, 100 and 150 Watts (with the assumption that the
% brightness is proportional to the power consumption). 
%
% The perceived contrast between 50 and 100 is higher than that between 100 and 
% 150 as $(100-50)/50 > (150-100)/100$. Consequently, the perceived contrast can
% be defined as a logarithmic function of the intensity:
%
% $$ y = f(x) = a log_e(1+x) $$
%
% As shown in the figure, to perceive the same contrast, larger intensity 
% difference is needed for higher intensity regions than lower ones.
% To most efficiently use the limited number of gray levels available, we can
% allocate more gray levels in the low intensity region where our eye is more
% sensitive to contrast) than in high intensity region.
% 
% <<contrast.gif>>
% 
% Weber's law describes a general phenomenon in human perception. 
% 
% *Gamma correction*
% 
% In the image acquisition process, non-linear mapping may occur in various
% stages. For example, in the camera system, the in-coming light intensity
% may be non-linearly mapped to the film or digital recording sensors, in the
% cathode ray tube (CRT), the applied voltage may be non-linearly mapped to 
% the brightness of the CRT display, and in the biological visual system, the 
% in-coming light intensity is non-linearly perceived by retina and the visual
% cortex of the brain. To compensate for all such non-linear mappings, the 
% following power function that relates the input $x$ to the output $y$ can
% be considered:
%
% $$ y=A x^{\gamma} $$
%
% where the ranges of both the input and output are normalized so that 
% $0\le x,y,\le 1$. Here $A$ is a constant scaling factor, and $\gamma$ is
% a parameter that characterizes the non-linearity. Obviously when $\gamma=1$, 
% $y$ is linearly related to $x$. Otherwise, we have a non-linear mapping. 
%
% As an example, the non-linear CRT mapping modelled by
% $y=x^\gamma=2^{2.2}$ can be corrected by another non-linear mapping
% $z=y^{1/\gamma}=y^{1/2.2}=(x^{2.2})^{1/2.2}=x$, as shown below:
% 
% <<CRTgamma.gif>>
%% Reference:
% * [1]
% <http://books.google.co.il/books?id=qemYYMOZQIcC&pg=PA107&lpg=PA107&source=bl&ots=3WyNNQnj4O&sig=fmmV6a2EPxBlszNcVmuJLaHw6pY&hl=iw&sa=X&ei=7X3pUr2bFaqP5ASGiIHYCA&ved=0CCkQ6AEwAA#v=onepage&q&f=false
% Leonid P. Yaroslavsky, Theoretical Foundations of Digital Imaging Using
% MATLAB, page 107>
% * [2]
% <<http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/L5ImageQuantization.pdf,
% L. Yaroslavsky, Lec. 5 Optimal scalar quantization of images in signal and transform
% domains>>
% * [3] MacQueen, J. B. (1967). "Some Methods for classification and Analysis of Multivariate Observations". Proceedings of 5th Berkeley Symposium on Mathematical Statistics and Probability 1. University of California Press. pp. 281–297. MR 0214227. Zbl 0214.46201. Retrieved 2009-04-07.
% * [4] E.W. Forgy (1965). "Cluster analysis of multivariate data: efficiency versus interpretability of classifications". Biometrics 21: 768–769.
% * [5] <<http://fourier.eng.hmc.edu/e161/lectures/digital_image/node2.html Ruye Wang, Computer Image Processing and Analysis (E161)>>

function ImageQuantization = ImageQuantization_mb( handles )
    %non-uniform_QUANTIZATION Summary of this function goes here
    %   Detailed explanation goes here
    axes_hor = 3;
    axes_ver = 2;
    is_outerposition = zeros(1, axes_hor*axes_ver);
    is_outerposition(3) = 1;
    is_outerposition(6) = 1;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    ImageQuantization = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9, ...
    is_outerposition);


    %%
    ImageQuantization.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    ImageQuantization.p = 0.5;
    ImageQuantization.q  = 5;
    ImageQuantization.noise_std= 0;

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    
	k=k+1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Find min RMS P';
	interface_params(k).callback = @(a,b)find_min_rms_p(a);    
    
	k=k+1;
    interface_params = SetSliderParams('Set the number of bits per pixel', 8, 1, ImageQuantization.q, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'q',@update_sliders), interface_params, k);

    k=k+1;
    interface_params = SetSliderParams('Set P for Pth-law  quantization', 1, 0, ImageQuantization.p, 1/100, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'p',@update_sliders), interface_params, k);

    k=k+1;
	interface_params = SetSliderParams( 'Set additive noise STD', 50, 0, ImageQuantization.noise_std, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'noise_std',@update_sliders), interface_params, k);


    
    
    
    
    
    
    
    
    


    ImageQuantization.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
                 



    guidata(handles.figure1, handles);
    process_image( ImageQuantization.im, ...
    ImageQuantization.q, ...
    ImageQuantization.noise_std, ...
    ImageQuantization.p, ...
    ImageQuantization.axes_1, ...
    ImageQuantization.axes_2, ...
    ImageQuantization.axes_3, ...
    ImageQuantization.axes_4, ...
    ImageQuantization.axes_5, ...
    ImageQuantization.axes_6   );
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
    process_image( handles.(handles.current_experiment_name).im, ...
    handles.(handles.current_experiment_name).q, ...
    handles.(handles.current_experiment_name).noise_std, ...
    handles.(handles.current_experiment_name).p, ...
    handles.(handles.current_experiment_name).axes_1, ...
    handles.(handles.current_experiment_name).axes_2, ...
    handles.(handles.current_experiment_name).axes_3, ...
    handles.(handles.current_experiment_name).axes_4, ...
    handles.(handles.current_experiment_name).axes_5, ...
    handles.(handles.current_experiment_name).axes_6   );
end

function find_min_rms_p(figure_handle)    
    handles = guidata(figure_handle);
    im = handles.(handles.current_experiment_name).im;
    q = 2^handles.(handles.current_experiment_name).q;
    im_unique = double(unique(im));
    rms_quan_p_min = inf;
    h =waitbar(0, 'please wait');
    for p = 0.1:0.01:1;
        im_quant_p = nlquantz_mb(im,q,p, im_unique);
        rms = sqrt(sum(sum((double(im)-double(im_quant_p)).^2))); 
        if ( rms_quan_p_min > rms ) 
            rms_quan_p_min = rms;
            p_quan_min = p;
        end
        waitbar( p, h);
    end

    
    slider_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Slider4');
    set(slider_handle, 'value', p_quan_min);
    slider_title_handle = findobj(handles.(handles.current_experiment_name).buttongroup_handle, 'tag', 'Value4');
    set(slider_title_handle, 'string', num2str(p_quan_min));
    
    close(h);    

    handles.(handles.current_experiment_name).p = p_quan_min;
    guidata(figure_handle, handles);

    process_image( handles.(handles.current_experiment_name).im, ...
        handles.(handles.current_experiment_name).q, ...
        handles.(handles.current_experiment_name).noise_std, ...
        handles.(handles.current_experiment_name).p, ...
        handles.(handles.current_experiment_name).axes_1, ...
        handles.(handles.current_experiment_name).axes_2, ...
        handles.(handles.current_experiment_name).axes_3, ...
        handles.(handles.current_experiment_name).axes_4, ...
        handles.(handles.current_experiment_name).axes_5, ...
        handles.(handles.current_experiment_name).axes_6   );
    
end

function process_image( im, q, noise_std, p, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
        q = 2^q;
        max_im_val = max(im(:));
        min_im_val = min(im(:));
        im_unique = unique(im(:));
        delete(get(axes_6, 'children'));
        delete(get(axes_3, 'children'));

        im_w_noise =  uint8(im+ noise_std*randn(size(im)));
        imshow(im_w_noise, [ 0, 255], 'parent', axes_1 );      
        
        DisplayAxesTitle( axes_1, ['Test image',9],   'TM',9);

        uniform_quant = uint8((max_im_val-min_im_val)*double(quantize_mb(im_w_noise,q))/(q-1) + min_im_val);
        uniform_quant_unique = uint8((max_im_val-min_im_val)*double(quantize_mb(im_unique,q))/(q-1) + min_im_val);
        imshow(uniform_quant, [ 0, 255], 'parent', axes_4 );
        
        rms = CalcRMS( im, uniform_quant );   
        DisplayAxesTitle( axes_4, ['Uniform quantization, RMS error= ' num2str(rms,'%1.1f\n')],   'BM',9);

        [LloydMax_quant, LloydMax_lut]= LloydMaxQunt2_mb( im_w_noise,q);
        %unique_quant = LloydMax_lut( im_unique + 1);
        imshow(uint8(LloydMax_quant) , [ 0, 255], 'parent', axes_2 );
        rms = CalcRMS( im, LloydMax_quant );  
        DisplayAxesTitle( axes_2, ['Lloyd-Max quantization, RMS error= ' num2str(rms,'%1.1f\n')],   'TM',9);

        [p_law_quant, im_unique_p_law_quant]= nlquantz_mb(im_w_noise,q,p, im_unique);
        p_law_quant = uint8(p_law_quant);
        im_unique_p_law_quant = uint8(im_unique_p_law_quant);
        imshow( p_law_quant, [ 0, 255], 'parent', axes_5 );
        rms = CalcRMS( im, p_law_quant ); 
        DisplayAxesTitle( axes_5, ['P\_th law quantization, RMS error= ' num2str(rms,'%1.1f\n')],   'BM',9);
        
        im_hist = histc(im(:), [0:255]);
        uniform_hist = histc(uniform_quant(:), 0:255);
        LloydMax_hist = histc(LloydMax_quant(:), 0:255);
        p_law_hist = histc(double(p_law_quant(:)), 0:255);
        
        bar(axes_6, im_hist,  'k'); hold(axes_6,  'on');
        stairs(axes_6, uniform_hist, 'color', 'r'); hold(axes_6,  'on');
        stairs(axes_6, LloydMax_hist, 'color', 'g'); hold(axes_6,  'on');
        stairs(axes_6, p_law_hist, 'color', 'b' ); hold(axes_6,  'on');
        leg = legend(axes_6, 'Test image', 'Uniformly quantized image', 'Lloyd-Max quantized image', 'Pth Law quantized image');
        set(leg, 'fontsize', 8);
        grid(axes_6, 'on'); xlim(axes_6, [0, 255]); ylim(axes_6, [0 , 1.1*max([uniform_hist ; LloydMax_hist; p_law_hist])] ); hold(axes_6,  'on');
%         DisplayAxesTitle( axes_6, ['Histogram'],   'BM',9);
        
        bar(axes_3, 255*im_hist/max(im_hist),  'k');
        hold(axes_3, 'on'); grid(axes_3, 'on'); xlim(axes_3, [0, 255]);
        stairs( axes_3,im_unique, uniform_quant_unique ,'color' , 'r'); hold on;
        stairs( axes_3, LloydMax_lut(:,1), LloydMax_lut(:,2), 'color', 'g'); hold on;
        stairs( axes_3, im_unique, im_unique_p_law_quant, 'color', 'b' ); hold on;
        DisplayAxesTitle( axes_3, ['Histograms'],   'TM',9);
end
