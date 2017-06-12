%% Predictive methods
% Study of DPCM as a predictive coding method.
%% Experiment Description:
% Illustration of 1D and 2D prediction, with purpose of minimize different
% error measurements.
%
% Three predictions types are introduced:
%
% * Horizontal prediction - 1D prediction on the horizontal axis, using 1
% coefficients.
% * Vertical prediction - 1D prediction on the Vertical axis, using 1
% coefficients.
% * 2D prediction - 2D prediction on the Vertical axis, using 4
% coefficients.
%% Tasks:
% 
% 3.1. 
%
% In 1-D one-sample prediction, prediction error is found as
% $e_k=a_k-h\cdot a_{k-1}$, where $a_k$ are image samples and k is sample
% index. 
%
% Write a program for determination of optimal weight coefficient
% $h$ for the 1-D one-sample prediction. 
%
% Using different test images, determine optimal $h$ for individual images 
% and on average for several images. 
%
% Write a program for computing horizontal, vertical and 2-D prediction errors. 
%
% Generate corresponding images (use program conv2.m).
%
% Compare horizontal, vertical and 2-D prediction error histograms and
% variances for different images (use program dpcmtest.m).
%
%% Instruction:
% Prediction mp [n] is calculated for $x[n]$ from previous samples 
%
% $e[n]$ is prediction error, with greatly reduced statistical dependencies 
% between adjacent samples, therefore, more suitable for entropy coder.
%
% Entropy coder may assume i.i.d. prediction error e[n]
%
% Receiver can reconstruct x[n] without loss for amplitude-discrete 
% signals
%
%% Theoretical Background & algorithm:
% Prediction is the operation of estimate future signal sample, and
% it is used in various image processing applications such as differential
% encoding. 
%
% One of the most common prediction method is the "Unbiased Linear prediction".
%
% Linear prediction is a mathematical operation where future values of a
% discrete-time signal are estimated as a linear function of previous
% samples. Unbiased Linear prediction is a linear prediction  with same
% expected value as the signal needs to be predicted.
%
% Differential encoding methods takes advantage of the fact that the data
% items being compressed are correlated, and uses prediction to reduce the
% number of bits used after compression. 
% This means that in general, an
% item $a_i$ depends on several of its near neighbors. 
%
% Unbiased Linear prediction is used in differential encoding methods by
% calculating the differences between the current and its prediction:
%
% $$ \mathcal{E}_{i}=a_{i}-p_i$$  
%
% where $p_i = \sum_{j=1}^N w_ja_{i-j}$, $w_j$ are the
% weights, and encode the $$ \mathcal{E}_i$ ’s. 
%
% Better prediction (and, as a result, smaller differences) can therefore
% be obtained by using N of the previously seen neighbors to encode the
% current item $a_i$ (where $N$ is a parameter).  
%
% In such a predictor the value of the
% current pixel $a_i$ is predicted by a weighted sum of $N$ of its
% previously seen neighbors (in the case of an image these are the pixels
% above it or to its left).
%
% Weights $w_j$ can be determined to minimize different error functions such
% as:
%
% * <#6 Mean Error  ( $\mu_{\mathcal{E}}$ )>
% * <#7 Mean Square Error ( $MS\mathcal{E}$)>
% * <#8 Error Variance ( $\sigma_{\mathcal{E}}^2$)>
% * <#9 Sum Absolute Error ( $SA\mathcal{E}$ )>
% 
% where:
%
% $$\mathcal{E}_{i} = y_i-\sum_{j=1}^K y_{i-j}w_j$$
%
% <html><a name="6"></a></html>
%
% *Absolutee Mean Error  ( $\left| \mu_{\mathcal{E}} \right|$ ):*
%
% $$\mu_{\mathcal{E}} = \frac{1}{N} \sum_{i=1}^{N}
% \left( y_i-\sum_{j=1}^K y_{i-j}w_j\right) = $$
%
% $$\frac{1}{N} \sum_{i=1}^{N}
% \left( y_i \right) - \frac{1}{N}  \sum_{i=1}^{N}\left(\sum_{j=1}^K
% y_{i-j}w_j\right) = \mu_Y -  \sum_{j=1}^K w_j \frac{1}{N} \left(\sum_{i=1}^{N}
% y_{i-j}\right) $$
%
% Ignoring boundary conditions:
%
% $$\mu_{\mathcal{E}} = \mu_Y -  \mu_Y \cdot \sum_{j=1}^K w_j $$
%
% Therefore, to minimize $\left| \mu_{\mathcal{E}} \right|$, the condition
% on $w_j$ is: 
%
% $$w_j = argmin_{w_j} \left( \left| \mu_{E} \right |\right)$$
%
% hence:
%
% $$ \sum_{j=1}^K w_j = 1 $$
%
% For $1D$ prediction ($K=1$), the optimal weight in least mean error case
% is $w=1$. 
%
% Unbiased Linear prediction demands that the $\left| \mu_{\mathcal{E}} \right|$ not only be
% minimized but will be identical to zero.
%
% <html><a name="7"></a></html>
%
% *_Mean Square Error (MSE):_* 
%
% $$ MSE = \frac{1}{N}  \sum_{i=1}^{N} \left( y_i-\sum_{j=1}^K y_{i-j}w_j\right) ^2$$
%
% The MSE is also equle to:
% 
% $$ MSE = Var \left( \mathcal{E} \right) + \mu_{\mathcal{E}}^2$$
%
% $$ w_j = argmin_{w_j} \left(  MSE \right)  = argmin_{w_j} \left(  N \cdot
% MSE \right)  =  argmin_{w_j} \sum_{i=1}^{N} \left( y_i-\sum_{j=1}^K
% y_{i-j}w_j\right) ^2 $$
%
% written in vectors form :
%
% $$\hat{\omega}  = argmin_{\hat{\omega}}\left( \hat{Y} - \tilde{Y} \cdot \hat{\omega}
% \right)^T \left( \hat{Y} -\tilde{Y} \cdot \hat{\omega} \right)$$ 
%
% where:
%
% $$ \hat{Y}_{NX1} = \left[ \begin{array}{l} y_1 \\ y_2 \\ \vdots \\ y_N
% \end{array} \right] $$
% $$ \hat{\omega}_{KX1} = \left[ \begin{array}{llll} w_1 \\ w_2 \\ \vdots \\ w_K
% \end{array} \right] $$
%
% $$\tilde{Y}_{NXK} = \left[ \begin{array}{llll} y_0 & y_{-1} & \cdots &
%  y_{1-k} \\ y_{1} & y_{0} & \cdots & y_{2-k} \\ \vdots &
%  \vdots & \vdots & \vdots \\ y_{N-1} & y_{N-2} & \cdots & y_{N-k} 
%  \end{array} \right] $$
%
% This can be analytically solved using least squares:
% 
% $$\omega = \left(\tilde{Y}^T \cdot \tilde{Y}  \right)^{-1} \cdot \tilde{Y} \cdot \hat{Y}$$
%
% However, due to the large data structures used, a Recursive Least Squares
% approach is used.
%
% *_Recursive Least Squares_*
% 
% The Recursive Least Squares (RLS) algorithm is designed to produce similar
% results of the Least square algorithm, while using smaller data structures
% and adjusted with each new information provided.
%
% The Recursive Least Squares algorithm follows the following procedure:
% 
% 1. Initialization:
%
% $$ \omega_0 = \left[ \begin{array}{llll} \frac{1}{K}  \\ \frac{1}{K} \\
% \vdots \\ \frac{1}{K} \end{array} \right] $$
% $$P_0 =  \left[ \begin{array}{llll} 1 & 0 & \cdots &
%  0 \\ 0 & 1 & \cdots & 0 \\ \vdots &
%  \vdots & \vdots & \vdots \\ 0 & 0 & \cdots & 1
%  \end{array} \right] $$
%
% 2. Update step:
% 
% repeat for each $n, n= 1...N$
%
% $$K_{n} = \left( P_{n-1} \cdot x_n \right) \cdot \left(1+ x_n^T \cdot P_{n-1} \cdot x_n \right)^{-1} $$
%
% $$P_{n} = (I_{KxK} - K_n \cdot x_n) \cdot P_{n-1}$$
% 
% $$ \omega_n = \omega_{n-1} + K_{n} \cdot \left( y_n - x_n \cdot
% \omega_{n-1} \right) $$
%
% end for loop
% Where:
%
% $I_{KxK}$ is a $KxK$ unitary matrix:
%
% $$I_{KxK} =  \left[ \begin{array}{llll} 1 & 0 & \cdots &
%  0 \\ 0 & 1 & \cdots & 0 \\ \vdots &
%  \vdots & \vdots & \vdots \\ 0 & 0 & \cdots & 1
%  \end{array} \right] $$
% 
% And $x_n$ is a vector of the last $k$ signal occurrences:
%
% $$x_n =  \left[ \begin{array}{llll} y_{n-1} \\ y_{n-2}\\ \vdots \\ y_{n-k-1} \end{array} \right] $$
%
% Matlab function:
%
%     function omega_n= recursive_least_squares(Y, data)
%         N = size(data,1);
%         omega_n = 0.5*ones(N,1)/N;
%         P_n = eye(N);
%         length_Y = length(Y);
%         for i = N:length_Y
%             k_n = P_n*data(:, i)/(1+data(:, i)'*P_n*data(:, i));
%             P_n = (eye(N) - k_n*data( :, i)')*P_n;
%              omega_n = omega_n + k_n* (Y(i) - data( :, i)'*omega_n);
%         end
%     end
%
%
% <html><a name="8"></a></html>
%
% *Error Variance ( $\sigma_\mathcal{E}^2$ ):*
%
% $$ \sigma_\mathcal{E}^2 = \mathit{E}\left\{ ( \mathcal{E} - \mu_\mathcal{E})^2 \right\} = \frac{1}{N} \sum_{i=1}^N e_i^2 - \left(\frac{1}{N} \sum_{i=1}^N e_i\right)^2 = MSE - \mu_{\mathcal{E}}^2$$
%
% For unbiased linear prediction, $\mu_{\mathcal{E}}^2 = 0$ therefore, the
% error variance is identical to the mean square error, and the $\omega_n$
% which minimize the error variance are identical to the $\omega_n$
% which minimize the $MSE$.
%
% <html><a name="9"></a></html>
%
% *Sum Absolute Error ( SAE ):*
%
% $$ SAE = E \left\{ \left| \mathcal{E} \right| \right\} = \frac{1}{N} \sum_{i=1}^N \left| y_n - \sum_{j=1}^K y_{i-j}w_j  \right| $$
%
% This minimization problem can be solved using Linear programming method.
%
% In order to use those methods, the linear programming problem needs to be defined:
%
% First, define $u_n$ which satisfies the conditions of:
%
% $$ u_n \ge  y_n - \sum_{j=1}^K y_{n-j}w_j$$ and $$ u_n \ge  -\left( y_n - \sum_{j=1}^K y_{n-j}w_j \right) $$
%
% And the minimization problems becomes:
%
% $$ minimize \sum_{i=1}^N u_i $$
%
% Subject to:
%
% $$ u_n \ge   y_n - \sum_{j=1}^K y_{n-j}w_j$$ 
%
% and 
% 
% $$ u_n \ge  -\left( y_n - \sum_{j=1}^K y_{n-j}w_j \right) $$
%
% These constraints have the effect of forcing each $u_i$ to equal $y_n -
% \sum_{j=1}^K y_{n-j}w_j$ upon being minimized, so the objective function
% is equivalent to the original objective function, but does not contains
% the Absolute value operator.
%
%% Reference:
% [1] <http://www2.ukdw.ac.id/kuliah/info/TP4113/DataCompressionTheCompleteReference.pdf David Salomon,Data Compression. The Complete Reference.3rdEdition, Springer-Verlag, 2004>
%
% [2] <http://www.ims.cuhk.edu.hk/~cis/2007.3/cis_7_3_05.pdf YUNMIN ZHU, X.
% RONG LI, RECURSIVE LEAST SQUARES WITH LINEAR CONSTRAINTS, COMMUNICATIONS
% IN INFORMATION AND SYSTEMS, Vol. 7, No. 3, pp. 287-312, 2007>
%%

function Prediction = Prediction_mb( handles )
    handles = guidata(handles.figure1);
    axes_hor = 2;
    axes_ver = 2;
    k = 1;
    is_outerposition = zeros(1, axes_hor*axes_ver);
    is_outerposition(4) = 1;

    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    Prediction = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9, ...
    is_outerposition);
    % initial params
    Prediction.h1 = -0.2;
    Prediction.h2 = -0.3;
    Prediction.h3 = -0.2;
    Prediction.h4 = -0.3; 
    Prediction.h5 = 1; 
 

    Prediction.h1_ver = -1;      
    Prediction.h2_ver = 1;

    Prediction.h1_hor = -1;      
    Prediction.h2_hor = 1; 
    %
    font_size = 15;
    w_font_size = 3*font_size;
    button_units = get(handles.pushbutton1, 'units');
    set(handles.pushbutton1, 'units', 'points');
    button_pos1 = get(handles.pushbutton1, 'position');
    set(handles.pushbutton1, 'units', button_units);
    title_pos = button_pos1;
    title_pos = title_pos +[ 0, (title_pos(4)-font_size), 0, font_size - title_pos(4)];
    button_pos1 = button_pos1 + [button_pos1(3)/2 - 1.5*w_font_size - 1, (button_pos1(4)-font_size-1), -button_pos1(3), -button_pos1(4) ];

    h1_pos = button_pos1 + [ 0, -font_size, w_font_size, font_size] ;
    h2_pos = button_pos1 + [ w_font_size+1,  -font_size, w_font_size, font_size] ;
    h3_pos = button_pos1 + [ 2*w_font_size+2,  -font_size, w_font_size, font_size] ;

    h4_pos = button_pos1 + [ 0, -2*font_size-1, w_font_size, font_size] ;
    h5_pos = button_pos1 + [ w_font_size+1,  -2*font_size-1, w_font_size, font_size] ;
    h6_pos = button_pos1 + [ 2*w_font_size+2,  -2*font_size-1, w_font_size, font_size] ;

    h7_pos = button_pos1 + [ 0, -3*font_size-2, w_font_size, font_size] ;
    h8_pos = button_pos1 + [ w_font_size+1,  -3*font_size-2, w_font_size, font_size] ;
    h9_pos = button_pos1 + [ 2*w_font_size+2,  -3*font_size-2, w_font_size, font_size] ;
    %           
    Prediction.uicontrol_title = uicontrol('style', 'text', 'units', 'points', 'position', title_pos, 'string', 'Set 2D Prediction Matrix');
    Prediction.uicontrol_h1_handle = uicontrol('style', 'edit', 'units', 'points', 'position', h1_pos, 'string', num2str(Prediction.h1), 'callback', @(a,b)SetH(a,b,k, 'h1'));
    Prediction.uicontrol_h2_handle = uicontrol('style', 'edit', 'units', 'points', 'position', h2_pos, 'string', num2str(Prediction.h2), 'callback', @(a,b)SetH(a,b,k, 'h2'));
    Prediction.uicontrol_h3_handle = uicontrol('style', 'edit', 'units', 'points', 'position', h3_pos, 'string', num2str(Prediction.h3), 'callback', @(a,b)SetH(a,b,k, 'h3'));
    Prediction.uicontrol_h4_handle = uicontrol('style', 'edit', 'units', 'points', 'position', h4_pos, 'string', num2str(Prediction.h4), 'callback', @(a,b)SetH(a,b,k, 'h4'));
    Prediction.uicontrol_h5_handle = uicontrol('style', 'text', 'units', 'points', 'position', h5_pos, 'string', num2str(Prediction.h5));%, 'callback', @(a,b)SetH(a,b,k, 'h5'));

    title_pos = [title_pos(1),   h9_pos(2)-font_size-2, title_pos(3), font_size];
    button_pos1(2) = title_pos(2) - 1;
    h1_pos = button_pos1 + [ 0, -font_size, w_font_size, font_size] ;
    h2_pos = button_pos1 + [ w_font_size+1,  -font_size, w_font_size, font_size] ;

    Prediction.uicontrol_title_hor = uicontrol('style', 'text', 'units', 'points', 'position', title_pos, 'string', 'Set Horizontal Prediction Matrix');%, 'callback', @(a,b)SetH(a,b,k, 'h5'));
    Prediction.uicontrol_h1_handle_hor = uicontrol('style', 'edit', 'units', 'points', 'position', h1_pos, 'string', num2str(Prediction.h1_hor), 'callback', @(a,b)SetH(a,b,k, 'h1_hor'));
    Prediction.uicontrol_h2_handle_hor = uicontrol('style', 'text', 'units', 'points', 'position', h2_pos, 'string', num2str(Prediction.h2_hor));%, 'callback', @(a,b)SetH(a,b,k, 'h2_hor'));
    %
    title_pos = [title_pos(1),   h2_pos(2)-font_size-2, title_pos(3), font_size];
    button_pos1(2) = title_pos(2) - 1;
    h2_pos = button_pos1 + [ w_font_size+1,  -font_size, w_font_size, font_size] ;
    h5_pos = button_pos1 + [ w_font_size+1,  -2*font_size-1, w_font_size, font_size] ;

    Prediction.uicontrol_title_ver = uicontrol('style', 'text', 'units', 'points', 'position', title_pos, 'string', 'Set Vertical Prediction Matrix');%, 'callback', @(a,b)SetH(a,b,k, 'h5'));
    Prediction.uicontrol_h1_handle_ver = uicontrol('style', 'edit', 'units', 'points', 'position', h2_pos, 'string', num2str(Prediction.h1_ver), 'callback', @(a,b)SetH(a,b,k, 'h1_ver'));
    Prediction.uicontrol_h2_handle_ver = uicontrol('style', 'text', 'units', 'points', 'position', h5_pos, 'string', num2str(Prediction.h2_ver));%, 'callback', @(a,b)SetH(a,b,k, 'h2_ver'));
    %            


    button_units = get(handles.pushbutton10, 'units');
    set(handles.pushbutton10, 'units', 'normalized');
    button_pos10 = get(handles.pushbutton10, 'position');
    set(handles.pushbutton10, 'units', button_units);

    Prediction.uicontrol_min_rms  = uicontrol('style', 'pushbutton', 'units', 'normalized', 'position', button_pos10, 'string', 'Calc min RMS', 'callback', @(a,b)calc_optimal_sq_error(handles.figure1));

    button_units = get(handles.pushbutton9, 'units');
    set(handles.pushbutton9, 'units', 'normalized');
    button_pos9 = get(handles.pushbutton9, 'position');
    set(handles.pushbutton9, 'units', button_units);

    Prediction.uicontrol_restore_default  = uicontrol('style', 'pushbutton', 'units', 'normalized', 'position', button_pos9, 'string', 'Restore Default', 'callback', @(a,b)restore_default_settings(handles.figure1));

    Prediction.im = HandleFileList('load' ,  HandleFileList('get' , handles.image_index));
    process_image(Prediction.im,  Prediction.h1, Prediction.h2, Prediction.h3, Prediction.h4, ...
    Prediction.h1_ver, Prediction.h1_hor,  ...
    Prediction.axes_1, Prediction.axes_2, Prediction.axes_3, Prediction.axes_4);
 end

 function SetH(a,b,k, var_name)
   handles = guidata(a);
   if ( isnan(str2double(get(a,'string'))))
       set(a,'string',num2str(handles.(handles.current_experiment_name).(var_name)));
   else
        handles.(handles.current_experiment_name).(var_name) = str2double(get(a,'string'));
        guidata(a,handles);
        run_process_image(handles);
   end

 end


function run_process_image(handles)
    if ( ~isstruct(handles))
        handles = guidata(handles);
    end


Prediction = handles.(handles.current_experiment_name);
    process_image(Prediction.im, Prediction.h1, Prediction.h2, Prediction.h3, ...
        Prediction.h4, Prediction.h1_ver, Prediction.h1_hor, ...
        Prediction.axes_1, Prediction.axes_2, Prediction.axes_3, Prediction.axes_4);
end


function process_image(im, h1,h2,h3, h4,h1_ver, h1_hor, axes_1, axes_2, axes_3, axes_4)
%     im_sliding =im.sliding;

    axes_4_children = get(axes_4, 'children');
    delete(axes_4_children);

    maskhor=[0 0 0;h1_hor 1 0;0 0 0];
    maskver=[0 h1_ver 0;0 1 0;0 0 0];
    mask2d= [h1,h2,h3; h4, 1,0; 0,0,0];



%     max_wnd_sz = 25;
%     x= [12,13,14,12,13];
%     y = [12,12,12,13,13];
%     curr_wnd_indx = sub2ind( [max_wnd_sz, max_wnd_sz], y, x);
%     im_sliding = im_sliding(curr_wnd_indx(:), :);
%     mask2d = [h1,h2,h3,h4, 1]'*ones(1, size(im_sliding,2));
%     horverdiff = reshape(sum(mask2d.* im_sliding), size(im));
    horverdiff=conv2(im,mask2d,'same');
    %  horverdiff = im_sliding(max_wnd_sz*max_wnd_sz - 1, :) + prediction_2d;
    hordiff=conv2(im,maskhor,'same');
    [mn,stdhordiff]=std2d_mb(hordiff);
    imshow(abs(hordiff), [0 255], 'parent', axes_1);
    DisplayAxesTitle( axes_1, ...
    {['Horizontal Prediction  Absolute Error'], ...
    ['\mu_E=' num2str(mean(hordiff(:)), 2) ',\sigma_E = ' num2str(sqrt(var(hordiff(:))), 2)], ...
    ['SAE=' num2str(mean(abs(hordiff(:))), 2) ', RMS= ' num2str(sqrt(mean(hordiff(:).^2)), 2)]}, 'LM', 10);
    absdif=abs(hordiff);mx=max(max(absdif));
    absdif=round(255*absdif/mx);
    hdiff2=imghisto_mb(absdif);
    %plotnorm(hdiff,4,2,4);title('Histogram of horizontal differences');drawnow
    % plot( histc(hordiff, [-255:255]), 'LineStyle', ':', 'linewidth', 2, 'Color', 'b', 'parent', axes_4);
    % hold(axes_4, 'on');


    verdiff=conv2(im,maskver,'same');
    [mn,stdverdiff]=std2d_mb(verdiff);
    % subplot(425);display1(verdiff);
    % title(['Vertical differences; std=',num2str(stdverdiff)]);drawnow
    imshow(abs(verdiff), [0 255], 'parent', axes_2);
    DisplayAxesTitle( axes_2, ...
    {['Vertical Prediction  Absolute Error'],...
    ['\mu_E=' num2str(mean(verdiff(:)), 2) ',\sigma_E = ' num2str(sqrt(var(verdiff(:))), 2)], ...
    ['SAE=' num2str(mean(abs(verdiff(:))), 2) ', RMS= ' num2str(sqrt(mean(verdiff(:).^2)), 2)]}, 'RM');

    absdif=abs(verdiff);mx=max(max(absdif));
    absdif=round(255*absdif/mx);
    hdiff1=imghisto_mb(absdif);
    % plotnorm(hdiff,4,2,6);title('Histogram of vertical differences');drawnow

    % plot( histc(verdiff, [-255:255]), 'LineStyle', '-', 'linewidth', 2, 'Color', 'g', 'parent', axes_4);
    % hold(axes_4, 'on');


    % horverdiff=conv2(im,mask2d,'same');
    [mn,stdhorverdiff]=std2d_mb(horverdiff);
    % subplot(427);display1(horverdiff);
    % title(['2D prediction error; std=',num2str(stdhorverdiff)]);drawnow
    imshow(abs(horverdiff), [0 255], 'parent', axes_3);
    DisplayAxesTitle( axes_3, ...
    {['2D Prediction  Absolute Error'],...
    ['\mu_E=' num2str(mean(horverdiff(:)), 2) ',\sigma_E = ' num2str(sqrt(var(horverdiff(:))), 2)], ...
    ['SAE=' num2str(mean(abs(horverdiff(:))), 2) ', RMS= ' num2str(sqrt(mean(horverdiff(:).^2)), 2)]}, 'LM');

    absdif=abs(horverdiff);mx=max(max(absdif));
    absdif=round(255*absdif/mx);
    hdiff=imghisto_mb(absdif);

    hdiff1 = histc(horverdiff(:), [-255:255]);
    % plot( hdiff1 , 'LineStyle', '--', 'linewidth', 2, 'Color','r', 'parent',axes_4);
    % hold(axes_4, 'on');
    hdiff2 =  histc(verdiff(:), [-255:255]);
    % plot( hdiff2, 'LineStyle', '-', 'linewidth', 2, 'Color', 'g', 'parent',axes_4);
    % 
    % hold(axes_4, 'on');
    hdiff = histc(hordiff(:), [-255:255]);
    % plot(hdiff , 'LineStyle', ':', 'linewidth', 2, 'Color', 'b', 'parent',axes_4);


    x = [-255:255];
    % plot(x, hdiff1, ':b', x, hdiff2, '-g', x, hdiff, '--r', 'linewidth', 2, 'parent', axes_4);
    % hold(axes_4, 'on');
    plot(x, hdiff1, 'LineStyle', '-', 'linewidth', 2, 'Color', 'g', 'parent', axes_4);
    hold(axes_4, 'on');
    plot(x, hdiff, 'LineStyle', ':', 'linewidth', 2, 'Color', 'b', 'parent', axes_4);
    % hold(axes_4, 'on');
    plot( x, hdiff2, 'LineStyle', '--', 'linewidth', 2, 'Color','r', 'parent', axes_4);
    axis(axes_4, 'tight');
    figure_childrens = get(get(axes_4, 'parent'), 'children');
    delete( figure_childrens(strcmpi(get(figure_childrens, 'Tag'), 'lagend_handle' )));

    h_l = legend(axes_4, 'horizontal filter error', 'vertical filter error','2D filter error');
    set(h_l, 'fontsize', 10 );
    set(h_l, 'Tag', 'lagend_handle' );
    grid(axes_4, 'on');
    title( axes_4, ['Prediction Error Histograms'], 'fontweight', 'bold');
    set(axes_4, 'fontweight','bold');
end


 function calc_optimal_sq_error(figure1_handle)
 handles = guidata(figure1_handle);
 Prediction = handles.(handles.current_experiment_name);
 WndSz = [3,3];
 im_sliding = im2col(img_ext_mb(Prediction.im,floor(WndSz(1)/2), floor(WndSz(2)/2))  , WndSz, 'sliding');
 im = Prediction.im;
 
 h = waitbar(0, 'plese wait');

 x= [1,2,3,1];
 y = [1,1,1,2];
 curr_wnd_indx = sub2ind( WndSz, y, x);
 
 
w= least_squares (im(:),im_sliding(curr_wnd_indx(:), :));
w = round(1000*w)/1000;
handles.(handles.current_experiment_name).h1 = -w(1);
handles.(handles.current_experiment_name).h2 = -w(2);
handles.(handles.current_experiment_name).h3 = -w(3);
handles.(handles.current_experiment_name).h4 = -w(4);
 waitbar(1/3, h);
 x= [2];
 y = [1];
  curr_wnd_indx = sub2ind(WndSz, y, x);
w_h = least_squares(im(:),im_sliding(curr_wnd_indx(:), :));
handles.(handles.current_experiment_name).h1_hor = -round(1000*w_h)/1000; 

waitbar(2/3, h);
 x= [1];
 y = [2];
  curr_wnd_indx = sub2ind( WndSz, y, x);
w_w = least_squares(im(:),im_sliding(curr_wnd_indx(:), :));
    waitbar(1, h);
    close(h);
handles.(handles.current_experiment_name).h1_ver = -round(1000*w_w)/1000;     
set(handles.(handles.current_experiment_name).uicontrol_h1_handle,'string',num2str(handles.(handles.current_experiment_name).h1));
set(handles.(handles.current_experiment_name).uicontrol_h2_handle,'string',num2str(handles.(handles.current_experiment_name).h2));
set(handles.(handles.current_experiment_name).uicontrol_h3_handle,'string',num2str(handles.(handles.current_experiment_name).h3));
set(handles.(handles.current_experiment_name).uicontrol_h4_handle,'string',num2str(handles.(handles.current_experiment_name).h4));
set(handles.(handles.current_experiment_name).uicontrol_h1_handle_hor,'string',num2str(handles.(handles.current_experiment_name).h1_hor));
set(handles.(handles.current_experiment_name).uicontrol_h1_handle_ver,'string',num2str(handles.(handles.current_experiment_name).h1_ver));

Prediction = handles.(handles.current_experiment_name);
 guidata(figure1_handle, handles);
    process_image(Prediction.im, Prediction.h1, Prediction.h2, Prediction.h3, ...
        Prediction.h4, Prediction.h1_ver, Prediction.h1_hor, ...
        Prediction.axes_1, Prediction.axes_2, Prediction.axes_3, Prediction.axes_4);
 end
 
 
 function restore_default_settings (figure1_handle)
 handles = guidata(figure1_handle);
 handles.(handles.current_experiment_name).h1 = -0.2;
handles.(handles.current_experiment_name).h2 = -0.3;
handles.(handles.current_experiment_name).h3 = -0.2;
handles.(handles.current_experiment_name).h4 = -0.3;
handles.(handles.current_experiment_name).h1_hor = -1;
handles.(handles.current_experiment_name).h1_ver = -1;

set(handles.(handles.current_experiment_name).uicontrol_h1_handle,'string',num2str(handles.(handles.current_experiment_name).h1));
set(handles.(handles.current_experiment_name).uicontrol_h2_handle,'string',num2str(handles.(handles.current_experiment_name).h2));
set(handles.(handles.current_experiment_name).uicontrol_h3_handle,'string',num2str(handles.(handles.current_experiment_name).h3));
set(handles.(handles.current_experiment_name).uicontrol_h4_handle,'string',num2str(handles.(handles.current_experiment_name).h4));
set(handles.(handles.current_experiment_name).uicontrol_h1_handle_hor,'string',num2str(handles.(handles.current_experiment_name).h1_hor));
set(handles.(handles.current_experiment_name).uicontrol_h1_handle_ver,'string',num2str(handles.(handles.current_experiment_name).h1_ver));
Prediction = handles.(handles.current_experiment_name);
 guidata(figure1_handle, handles);
    process_image(Prediction.im, Prediction.h1, Prediction.h2, Prediction.h3, ...
        Prediction.h4, Prediction.h1_ver, Prediction.h1_hor, ...
        Prediction.axes_1, Prediction.axes_2, Prediction.axes_3, Prediction.axes_4);
 

 end