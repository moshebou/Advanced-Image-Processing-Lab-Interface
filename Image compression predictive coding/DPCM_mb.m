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
% 3.2 
%
% Using program dpcm1d.m, investigate 1-D DPCM coding efficiency for
% different test signals and images and different coding parameters (max
% for quantization dynamic range and P for P-th low quantization).
%
% Observe image degradations and investigate the sensitivity of the coding
% to the channel noise added to the quantized prediction error.  
%
% Investigate 2-D DPCM coding efficiency for different images and different
% coding parameters (use program dpcm2d.m). 
%
% Observe image degradations and investigate the sensitivity of the coding
% to the  channel noise. 
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
% Differential encoding methods calculate the differences 
% $d_i = a_i ? a_{i?1}$
% between consecutive data items $a_i$, and encode the $d_i$’s. 
% The first data item, $a_0$, is either encoded separately or is written on the compressed
% stream in raw format. In either case the decoder can decode and generate
% $a_0$ in exact form. In principle, any suitable method, lossy or lossless,
% can be used to encode the differences. 
%
% In practice, quantization is often used, resulting in lossy compression.
% The quantity encoded is not the difference $d_i$ but a similar, quantized
% number that we denote by $\hat{d}_i$. The difference between $d_i$ and
% $\hat{d}_i$ is the quantization error $q_i$. Thus, $\hat{d}_i = d_i + q_i$.
%
% It turns out that the lossy compression of differences introduces a new problem,
% namely, the accumulation of errors. This is easy to see when we consider the operation
% of the decoder. The decoder inputs encoded values of ˆ di, decodes them, and uses them
% to generate “reconstructed” values ˆai (where ˆai = ˆai?1 + ˆ di) instead of the original data
% values ai. The decoder starts by reading and decoding a0. It then inputs ˆ d1 = d1 + q1
% and calculates ˆa1 = a0+ ˆ d1 = a0+d1+q1 = a1+q1. The next step is to input ˆ d2 = d2+q2
% and to calculate ˆa2 = ˆa1 + ˆ d2 = a1 + q1 + d2 + q2 = a2 + q1 + q2. The decoded value ˆa2
% contains the sum of two quantization errors. In general, the decoded value ˆan equals
% $\hat{a}_n = a_n + \sum_{i=1}^n q_i $
%
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
% *Absolute Mean Error  ( $\left| \mu_{\mathcal{E}} \right|$ ):*
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
% is equivalent to the test objective function, but does not contains
% the Absolute value operator.
%
%% Reference:
% [1] <http://www2.ukdw.ac.id/kuliah/info/TP4113/DataCompressionTheCompleteReference.pdf David Salomon,Data Compression. The Complete Reference.3rdEdition, Springer-Verlag, 2004>
%
% [2] <http://www.ims.cuhk.edu.hk/~cis/2007.3/cis_7_3_05.pdf YUNMIN ZHU, X.
% RONG LI, RECURSIVE LEAST SQUARES WITH LINEAR CONSTRAINTS, COMMUNICATIONS
% IN INFORMATION AND SYSTEMS, Vol. 7, No. 3, pp. 287-312, 2007>
%%
function DPCM = DPCM_mb( handles )
   handles = guidata(handles.figure1);

   axes_hor = 3;
   axes_ver = 2;
   button_pos = get(handles.pushbutton12, 'position');
   bottom =button_pos(2);
   left = button_pos(1)+button_pos(3);
        DPCM = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);
      
    % initial params

    DPCM.mxm = 100;
    DPCM.QQ = log2(128);    
    DPCM.P = 0.5;    
    DPCM.NoiseType = 'Additive noise';
    DPCM.NoiseStd = 0;
    DPCM.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    %%

	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    
    k=k+1;           
    interface_params =  SetSliderParams( 'Set quantization level (bpp)', 8, 0, DPCM.QQ, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'QQ',@update_sliders), interface_params, k);             
    
    k=k+1;           
    interface_params =  SetSliderParams( 'Set max threshold', 255, 1, DPCM.mxm, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'mxm',@update_sliders), interface_params, k);             
    
    k=k+1;            
    interface_params =  SetSliderParams(  'Set P for P-law quantization', 1, 0, DPCM.P, 1/25, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'P',@update_sliders), interface_params, k);             
	
    k=k+1;
    interface_params =  SetSliderParams('Set additive noise StDevev', 25, 0, DPCM.NoiseStd, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'NoiseStd',@update_sliders), interface_params, k);
    
    k=k+1;  	
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose noise type';
    interface_params(k).selection ={ 'Additive noise', 'Impulse noise'};   
    interface_params(k).callback = @(a,b)ChooseNoiseType(a,b,handles);    
 
          

         


    DPCM.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
         

    imshow(DPCM.im, [ 0 255], 'parent', DPCM.axes_1);
    DisplayAxesTitle( DPCM.axes_1, ['Test image'], 'TM',10);
    
%     process_image(DPCM.im, DPCM.mxm, DPCM.QQ, DPCM.P, DPCM.NoiseType, DPCM.NoiseStd, ...
%         DPCM.axes_1, DPCM.axes_2, DPCM.axes_3, DPCM.axes_4, DPCM.axes_5, DPCM.axes_6);

 end
function ChooseNoiseType(slider_handles,y,z)
handles = guidata(slider_handles);
% if ( 1 == get(slider_handles, 'value'))
%     handles.(handles.current_experiment_name).NoiseType = 'awgn';
% else
%     handles.(handles.current_experiment_name).NoiseType = 'Impulse';
% end
handles.(handles.current_experiment_name).NoiseType = get(y.NewValue, 'string');
butt_grp_ch       = get(handles.(handles.current_experiment_name).buttongroup_handle, 'children');
noise_std_or_prob = butt_grp_ch(strcmpi(get(butt_grp_ch, 'tag'),'Title5'));
noise_max_text    = butt_grp_ch(strcmpi(get(butt_grp_ch, 'tag'),'RightText5'));
noise_min_text    = butt_grp_ch(strcmpi(get(butt_grp_ch, 'tag'),'LeftText5'));
noise_slider      = butt_grp_ch(strcmpi(get(butt_grp_ch, 'tag'),'Slider5'));
noise_Value_text  = butt_grp_ch(strcmpi(get(butt_grp_ch, 'tag'),'Value5'));
if (strcmpi(handles.(handles.current_experiment_name).NoiseType, 'Additive noise'))
    handles.(handles.current_experiment_name).NoiseStd = 0;
    set(noise_std_or_prob, 'string', 'Set additive noise StDev');
    set(noise_max_text,    'string', '25');
    set(noise_min_text,    'string', '0');
    set(noise_slider,      'value', 0);
    set(noise_slider,      'max', 25, 'min', 0);
    set(noise_Value_text,  'string', '0');
else
    handles.(handles.current_experiment_name).NoiseStd = 0;
    set(noise_std_or_prob, 'string', 'Set Impulse Noise Probability');
    set(noise_max_text,    'string', '0.5');
    set(noise_min_text,    'string', '0');
    set(noise_slider,      'value', 0);
    set(noise_slider,      'max', 0.5, 'min', 0);
    set(noise_Value_text,  'string', '0');
end
guidata(slider_handles, handles);
DPCM = handles.(handles.current_experiment_name);
    process_image(DPCM.im, DPCM.mxm, DPCM.QQ, DPCM.P, DPCM.NoiseType, DPCM.NoiseStd, ...
        DPCM.axes_1, DPCM.axes_2, DPCM.axes_3, DPCM.axes_4, DPCM.axes_5, DPCM.axes_6);
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



DPCM = handles.(handles.current_experiment_name);
    process_image(DPCM.im, DPCM.mxm, DPCM.QQ, DPCM.P, DPCM.NoiseType, DPCM.NoiseStd, ...
        DPCM.axes_1, DPCM.axes_2, DPCM.axes_3, DPCM.axes_4, DPCM.axes_5, DPCM.axes_6);
end



function process_image(im, mxm,QQ,P, NoiseType, NoiseStd, ...
    axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)



im_dpcm_1d = dpcm1d_mb(im,mxm,QQ,P, NoiseType, NoiseStd);
imshow(im_dpcm_1d, [ ], 'parent', axes_2);
DisplayAxesTitle( axes_2, ['1D DPCM restored image'], 'TM',10);
diff_1d = im - im_dpcm_1d;
ErrSTD1d=sqrt(mean(diff_1d(:).^2)-(mean(diff_1d(:))).^2);
imshow(diff_1d, [-50 50], 'parent', axes_5);
DisplayAxesTitle( axes_5, ['1D DPCM restoration error; ErrorSTD=',num2str(ErrSTD1d,3)], 'BM',10);

im_dpcm_2d = dpcm2d_mb(im,mxm,QQ,P, NoiseType, NoiseStd);
imshow(im_dpcm_2d, [ ], 'parent', axes_3);
DisplayAxesTitle(axes_3, ['2D DPCM Result'], 'TM',10);
diff_2d = im - im_dpcm_2d;
ErrSTD2d=sqrt(mean(diff_2d(:).^2)-(mean(diff_2d(:))).^2);
imshow(diff_2d, [-50 50], 'parent', axes_6);
DisplayAxesTitle( axes_6, ['2D DPCM restoration error; ErrorSTD=',num2str(ErrSTD2d,3)], 'BM',10);

 end

