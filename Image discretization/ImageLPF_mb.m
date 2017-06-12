%% Image Low Pass Filter
%  Perfect Circular and Rectangular Low Pass Filters
%% Experiment Description:
% This experiment demonstrates the effect of applying low pass filter on an
% image, usually performed before image sampling to avoid aliasing effects.
%
% The perfect LPF set to zero all frequencies above a certain threshold,
% while passes as-is frequencies lower then that threshold.
%% Tasks:
% * Observe and explain LPF effect on the image.
% * Explain the difference between circular and rectangular LPF.
%
%% Instruction:
% Use the 'Set Cut-off Frequency' slider to change the threshold of the LPF.
%
% Toggle between 'rectangular' and 'circular' filters.
%
%% Theoretical Background:
% An ideal low pass filter can be described in the frequency domain as:
%
% <<lpf.png>>
%
% $$ {\bf H } (e^{jw}) = \left\{\begin{array}{ll}
% 1, & \left|\omega\right|\leq\omega_c \\[5pt]
% 0, & \mbox{otherwise} \\
% \end{array}\right.$$
%
% $$ \begin{array}{c} h(n)  = \mbox{DTFT}^{-1}_n \left( {\bf H } (e^{jw})
% \right) =  \frac {1}{2\pi} \displaystyle \displaystyle \int_{-\pi}^{\pi}  {\bf H } (e^{jw})
% e^{j\omega n } d \omega  =  \frac {1}{2\pi}  \displaystyle \displaystyle \int_{-\omega_c}^{\omega_c}
% e^{j\omega n } d \omega = \\ = \left. \frac {e^{j\omega n}}{2 \pi
% jn} \right|_{-\omega_c}^{\omega_c}  = \frac {e^{j\omega_c n} - e^{j\omega_c n}
% }{2 \pi j n} = \frac {2 j sin(\omega_c n)}{2 \pi j n} = \frac {
% sin(\omega_c n)}{\pi  n} =  2f_c sinc(2 f_c n) \end{array} $$
%
% _*The two dimensions rectangular version of the LPF is described as:*_
%
% <<2d_lpf_frequency_domain.png>>
%
% $$ {\bf H } (e^{j\omega_1}, e^{j\omega_2}) = \left\{\begin{array}{ll}
% 1, & \left|\omega_1\right|\leq\omega_c \wedge \left|\omega_2\right|\leq\omega_c \\[5pt]
% 0, & \mbox{otherwise}
% \end{array}\right.$$
%
% $$ \begin{array}{c} h(n,m)  = \mbox{DTFT}^{-1}_{n,m} \left( {\bf H } (e^{j\omega_1}, e^{j\omega_2})
% \right) =  \frac {1}{4\pi^2} \displaystyle \displaystyle \int_{-\pi}^{\pi} \displaystyle \displaystyle \int_{-\pi}^{\pi} {\bf H } (e^{j\omega_1}, e^{j\omega_2})
% e^{j\omega_1 n } e^{j\omega_2 m } d \omega_1  d \omega_2 = \\  = \frac {1}{4\pi^2} \displaystyle \displaystyle \int_{-\omega_c}^{\omega_c}
% e^{j\omega_1 n } d \omega_1 \displaystyle \displaystyle \int_{-\omega_c}^{\omega_c} e^{j\omega_2 m }   d \omega_2 = 4f_c^2 \cdot sinc(2 f_c n)\cdot sinc(2 f_c m) \end{array} $$
%
% <<2d_lpf_time_domain.png>>
%
% _*The two dimensions circular version of the LPF is described as:*_
%
% <<2d_lpf_frequency_domain_circular.png>>
%
% $$ {\bf H } (e^{j\omega_1}, e^{j\omega_2}) = \left\{\begin{array}{ll}
% 1, & \sqrt{\omega_1^2 + \omega_2^2}\leq\omega_c \\[5pt]
% 0, & \mbox{otherwise} \\
% \end{array}\right.$$
%
% $$ h(n,m)  = \mbox{DTFT}^{-1}_n,m \left( {\bf H } (e^{j\omega_1}, e^{j\omega_2})
% \right) =  \frac {1}{4\pi^2} \displaystyle \displaystyle \int_{-\pi}^{\pi} \displaystyle \displaystyle \int_{-\pi}^{\pi} {\bf H } (e^{j\omega_1}, e^{j\omega_2})
% e^{j\omega_1 n } e^{j\omega_2 m } d \omega_1  d \omega_2 = $$ 
%
% Variable change:
%
% $$ \omega_1 = r \cdot cos(\theta) \;\;\;\; \omega_2 =  r \cdot
% sin(\theta) \;\;\;\;  r = \omega_1^2 + \omega_2 ^2 \;\;\;\; \theta =
% atan( \frac {\omega_2}{\omega_1} ) $$
%
% $$\left| J \right| = \left|\left[ \begin{array}{ll} cos(\theta) & -r \cdot sin(\theta) \\
% sin(\theta) & r \cdot cos(\theta) \end{array} \right] \right| = r\cdot (cos(\theta)^2 + sin(\theta)^2) =r$$
%
% Since the result will be radial symmetric, we use the notion of:
%
% $$ n = r^{'} cos(\eta) \;\;\;\; n = r^{'} sin(\eta) $$
%
% And we get:
%
% $$ \frac {1}{4\pi^2} \displaystyle \displaystyle \int_{0}^{\omega_c} \displaystyle \displaystyle \int_{0}^{2\pi}
% r \cdot e^{jr \cdot (cos(\theta) r^{'}cos(\eta) + sin(\theta)
% r^{'}sin(\eta) )} d \theta dr =  \frac {1}{4\pi^2} \displaystyle \displaystyle \int_{0}^{\omega_c} \displaystyle \displaystyle \int_{0}^{2\pi}
% r \cdot e^{jrr^{'}\cdot (cos(\theta) cos(\eta) + sin(\theta)sin(\eta) )}
% d \theta dr = $$
%
% $$ \frac {1}{4\pi^2} \displaystyle \displaystyle \int_{0}^{\omega_c} \displaystyle \displaystyle \int_{0}^{2\pi}
% r \cdot e^{jrr^{'}\cdot cos(\theta - \eta)} d \theta dr = $$
%
% Another variable change:
%
% $$ \theta - \eta = \theta ^{'} \;\;\;\; \frac {d\theta ^{'}}{d\theta} = 1 \;\;\;\;  - \eta \le \theta ^{'} \le 2\pi - \eta $$
%
% $$ \frac {1}{4\pi^2} \displaystyle \displaystyle \int_{0}^{\omega_c} \displaystyle \displaystyle \int_{- \eta}^{2\pi - \eta}
% r \cdot e^{jrr^{'}\cdot cos(\theta^{'})} d \theta^{'} dr = $$
%
% But since cos is a periodic function with period of $2\pi$, we get:
%
% $$ \frac {1}{4\pi^2} \displaystyle \displaystyle \int_{0}^{\omega_c} \displaystyle \displaystyle \int_{0}^{2\pi}
% r \cdot e^{jrr^{'}\cdot cos(\theta^{'})} d \theta^{'} dr = $$
%
% Using the Bessel function property of   $\;\;\;J_{0}(r)  = \displaystyle \displaystyle \int_0^{2\pi} \frac{e^{j r cos( \theta )}}{2\pi} d \theta\;\;\;$ :
%
% $$ \frac {1}{2\pi} \displaystyle \displaystyle \int_{0}^{\omega_c} r\cdot J_{0}(r \cdot r^{'})  dr = $$
%
% Using another Bessel function property   $\;\;\;rJ_{1}(r)  = \displaystyle \displaystyle \int r \cdot
% J_{0}(r) dr\;\;\;$ and another variable change:
%
% $$ r \cdot r^{'} = R \;\;\;\; \frac {dr}{dR} = \frac {1}{r^{'}} \;\;\;\;  0 \le R \le r^{'}\cdot \omega_c $$
%
% $$ \frac {1}{2\cdot (r^{'})^2 \pi} \displaystyle \displaystyle \int_{0}^{r^{'}\cdot \omega_c} R \cdot
% J_{0}(R)  dR = \frac {1}{2\cdot (r^{'})^2 \pi} \left. RJ_{1}(R)\right|_0^{r^{'}\cdot \omega_c} = \frac {1}{2\cdot (r^{'})^2 \pi} r^{'}\cdot \omega_c J_{1}(r^{'}\cdot
% \omega_c) $$
%
% <<2d_lpf_spatial_domain_circular.png>>
%
%% Algorithm:
%     Inputs: Image, Cut-off_Frequency, filter_type
%     function process_image(im, Cut_offFreq, LpfType)
%     Cut_offFreq = round(Cut_offFreq*size(im,1));
%     im_fft = fft2(im);
%     im_dct = dct2(im);
%     im_haar = haar2_mb(im);
%     im_walsh = walsh2_mb(im);
%     if ( strcmpi(LpfType, 'circular'))
%         [x y] = meshgrid(1:size(im,1), 1:size(im,2));
%         lpf_filter=round(sqrt(x.^2 + y.^2) )<( size(im,1)/2 - Cut_offFreq );
% 
%     end
%     for i=1:4
%         if ( i ==1 )
%             CurrTransformed = fftshift(im_fft);
% 
%             if ( Cut_offFreq)
%                 if ( strcmpi(LpfType, 'circular'))
%                     %lpf_filter = ones(1:size(im,1), 1:size(im,2));
%                     lpf_filter_fft=round(sqrt((x-round(size(im,2)/2)).^2 + (y-round(size(im,1)/2)).^2) )< (size(im,1) /2- Cut_offFreq );
%                     CurrTransformed = CurrTransformed.*lpf_filter_fft;
%                 else
%                     lpf_filter_fft = ones(size(CurrTransformed));
%                     lpf_filter_fft(:,1:Cut_offFreq) = 0;
%                     lpf_filter_fft(1:Cut_offFreq,:) = 0;
%                     lpf_filter_fft(:,end:-1:end-Cut_offFreq) = 0;
%                     lpf_filter_fft(end:-1:end-Cut_offFreq,:) = 0;
%                     CurrTransformed = CurrTransformed.*lpf_filter_fft;
% 
%                 end
%             end
%         elseif ( i == 2 )
%             CurrTransformed = im_dct;
%             if ( Cut_offFreq)
%                 if ( strcmpi(LpfType, 'circular'))
%                     CurrTransformed = CurrTransformed.*lpf_filter;
%                 else
%                     CurrTransformed( end-Cut_offFreq:end, :)  = 0;
%                     CurrTransformed( :, end-Cut_offFreq:end)  = 0;
%                 end
%             end
%         elseif ( i == 3 )
%             CurrTransformed = im_haar;
%             if ( Cut_offFreq)
%                 if ( strcmpi(LpfType, 'circular'))
%                     CurrTransformed = CurrTransformed.*lpf_filter;
%                 else
%                     CurrTransformed( end-Cut_offFreq:end, :)  = 0;
%                     CurrTransformed( :, end-Cut_offFreq:end)  = 0;
%                 end
%             end
%         elseif ( i == 4 )
%             CurrTransformed = im_walsh;
%             if ( Cut_offFreq)
%                 if ( strcmpi(LpfType, 'circular'))
%                     CurrTransformed = CurrTransformed.*lpf_filter;
%                 else
%                     CurrTransformed( end-Cut_offFreq:end, :)  = 0;
%                     CurrTransformed( :, end-Cut_offFreq:end)  = 0;
%                 end
%             end
%         end
%     Display result images.
%     end 
%% Reference:
% * [1]
% <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/L4_SignalDiscreti&Sampling.pdf
% L. Yaroslavsky, Lec. 4 Principles of signal digitization. Signal sampling>

function ImageLPF = ImageLPF_mb( handles )
% Tasks: 
% Compare sampling with the ideal low-pass filtering and simple decimation without
% low pass filtering. Observe differences between optimally sampled and decimated images
% (program sampling.m). Determine the minimal bandwidth required to maintain the
% readability of the test text image (text256).
handles = guidata(handles.figure1);
k=1;
axes_hor = 4;
axes_ver = 2;
button_pos = get(handles.pushbutton12, 'position');
bottom =button_pos(2);
left = button_pos(1)+button_pos(3);
ImageLPF = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);
      
% initial params

    ImageLPF.Cut_offFreq = 1;
    ImageLPF.LpfType = 'Rectangular';
    ImageLPF.im = HandleFileList('load' , HandleFileList('get' , handles.image_index));
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
	interface_params =  SetSliderParams('Set Cut-off Frequency', 1, 0, ImageLPF.Cut_offFreq, 1/10, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'Cut_offFreq',@update_sliders), interface_params, k);
    k=k+1;  	
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Choose LPF type';
    interface_params(k).selection ={ 'Rectangular', 'Circular'};   
    interface_params(k).callback = @(a,b)ChooseLpfType(a,b,handles);    
    
            
            
            
            
            
            
            
            
 
            
            ImageLPF.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
                 

    imshow(uint8(ImageLPF.im), 'parent', ImageLPF.axes_1);
    title('Test image', 'parent', ImageLPF.axes_1, 'fontweight', 'bold');

    imshow(ImageLPF.im, [0 255], 'parent', ImageLPF.axes_2);
    DisplayAxesTitle( ImageLPF.axes_2,  {'Restored image: DFT','using all transform coefficients' }, 'TM',9);

    imshow(ImageLPF.im, [0 255], 'parent', ImageLPF.axes_3);
    DisplayAxesTitle( ImageLPF.axes_3,  {'Restored image: DCT','using all transform coefficients' }, 'TM',9);

    imshow(ImageLPF.im, [0 255], 'parent', ImageLPF.axes_6);
    DisplayAxesTitle( ImageLPF.axes_6,  {'Restored image: Haar transform','using all transform coefficients' }, 'BM',9);

    imshow(ImageLPF.im, [0 255], 'parent', ImageLPF.axes_7);
    DisplayAxesTitle( ImageLPF.axes_7,  {'Restored image: Walsh transform','using all transform coefficients' }, 'BM',9);

    imshow(ones(size(ImageLPF.im)), [0 1], 'parent', ImageLPF.axes_4);
    DisplayAxesTitle( ImageLPF.axes_4,  'DFT filter mask', 'TM',9);

    imshow(ones(size(ImageLPF.im)), [0 1], 'parent', ImageLPF.axes_8);
    DisplayAxesTitle( ImageLPF.axes_8,  'DCT, Walsh and Haar filter mask', 'BM',9);
    
    
    %----------Spectra----------------------------
    LpfType = ImageLPF.LpfType;
    [SzX,Szy]=size(ImageLPF.im);
    im = ImageLPF.im - mean(ImageLPF.im(:));
    N=SzX;
    %----------DFT--------------------------------
    sp_dft_lp=zeros(1,N/2);
    sp_dft=abs(fft2(im)).^2;
    sp_dft_norm=sp_dft/(sum(abs(sp_dft(:))));
    %-----------DCT-----------------------------
    sp_dct_lp=zeros(1,SzX);
    sp_dct=dct2(im);
    sp_dct_norm=sp_dct/(sqrt(sum(abs(sp_dct(:)).^2)));         
    %------------Walsh-------------------------  
    sp_walsh_lp=zeros(1,SzX);
    sp_walsh=abs(walsh2_mb(im)).^2;
    sp_walsh_norm=sp_walsh/(sum(sp_walsh(:)));         
    %------------Haar-----------------------------
    sp_haar_lp=zeros(1,SzX);
    sp_haar=abs(haar2_mb(im).^2);
    sp_haar_norm=sp_haar/(sum(sp_haar(:)));
    if ( strcmpi(LpfType, 'circular') )
        for L=1:N/2,
            [x, y] = meshgrid(1:size(im,1), 1:size(im,2));
            lpf_filter_fft=sqrt((x-round(size(im,2)/2)).^2 + (y-round(size(im,1)/2)).^2) < (L);         
            sp_dft_lp(L)=sum(sum(abs(lpf_filter_fft.*fftshift(sp_dft_norm))));
        end
        for L=1:N,
            [x, y] = meshgrid(1:size(im,1), 1:size(im,2));
            lpf_filter= sqrt((x).^2 + (y).^2) < (L); 
            sp_dct_lp(L)=sum(sum(abs(lpf_filter.*sp_dct_norm).^2));
            sp_walsh_lp(L)=sum(sum(abs(lpf_filter.*sp_walsh_norm)));
            sp_haar_lp(L)=sum(sum(abs(lpf_filter.*sp_haar_norm)));
        end
    elseif (strcmpi(LpfType, 'rectangular'))
        for L=1:N/2,
            sp_dft_lp(L)=2*sum(sp_dft_norm(2:L-1,1))+sp_dft_norm(L,1)+.......
                         2*sum(sp_dft_norm(1,2:L-1))+sp_dft_norm(1,L)+.......
                         2*(sum(sum(sp_dft_norm(2:L,2:L))))+......
                         2*(sum(sum(sp_dft_norm(2:L,N-L+2:N))));
        end
        for L=1:N,
            Lsum_1=1:L;
            sp_dct_lp(L)=sum(sum(abs(sp_dct_norm(Lsum_1,Lsum_1)).^2));
            sp_walsh_lp(L)=sum(sum(abs(sp_walsh_norm(Lsum_1,Lsum_1))));
            sp_haar_lp(L)=sum(sum(abs(sp_haar_norm(Lsum_1,Lsum_1))));
        end
    end

    plot(sp_dct_lp,'LineWidth',2, 'parent', ImageLPF.axes_5);  
    plot((2:2:SzX)/SzX,sp_dct_lp(2:2:SzX),'k-','LineWidth',2, 'parent', ImageLPF.axes_5);
    % 	axis([0.1 1 0.8 1]);
    hold( ImageLPF.axes_5, 'on');
    plot((1:SzX/2)/(SzX/2),sp_dft_lp,'c-','LineWidth',2, 'parent', ImageLPF.axes_5);
    plot((2:2:SzX)/SzX,sp_walsh_lp(2:2:SzX),'r-','LineWidth',2, 'parent', ImageLPF.axes_5);
    plot((2:2:SzX)/SzX,sp_haar_lp(2:2:SzX),'b-','LineWidth',2, 'parent', ImageLPF.axes_5);
    grid(ImageLPF.axes_5,  'on');
    ylabel('Fraction of signal energy','FontWeight','Bold','FontSize',12, 'parent', ImageLPF.axes_5);
    xlabel('Bandwidth (in fraction of the base band)','FontWeight','Bold','FontSize',12, 'parent', ImageLPF.axes_5);

    legend(ImageLPF.axes_5, 'DCT','DFT','Walsh','Haar',4, 'Location', 'best' );
    axis( ImageLPF.axes_5,'tight');
    hold( ImageLPF.axes_5, 'off');

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
    process_image(handles.(handles.current_experiment_name).im, handles.(handles.current_experiment_name).Cut_offFreq, handles.(handles.current_experiment_name).LpfType, ...
    handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_2, handles.(handles.current_experiment_name).axes_3, ...
    handles.(handles.current_experiment_name).axes_4, handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6, ...
    handles.(handles.current_experiment_name).axes_7, handles.(handles.current_experiment_name).axes_8);
end
function ChooseLpfType ( a,b ,c)
handles = guidata(a);
handles.(handles.current_experiment_name).LpfType = get(get(a, 'SelectedObject'), 'string');
ImageLPF = handles.(handles.current_experiment_name);
    %----------Spectra----------------------------
    LpfType = ImageLPF.LpfType;
    [SzX,Szy]=size(ImageLPF.im);
    im = ImageLPF.im - mean(ImageLPF.im(:));
    N=SzX;
    %----------DFT--------------------------------
    sp_dft_lp=zeros(1,N/2);
    sp_dft=abs(fft2(im)).^2;
    sp_dft_norm=sp_dft/(sum(abs(sp_dft(:))));
    %-----------DCT-----------------------------
    sp_dct_lp=zeros(1,SzX);
    sp_dct=dct2(im);
    sp_dct_norm=sp_dct/(sqrt(sum(abs(sp_dct(:)).^2)));         
    %------------Walsh-------------------------  
    sp_walsh_lp=zeros(1,SzX);
    sp_walsh=abs(walsh2_mb(im)).^2;
    sp_walsh_norm=sp_walsh/(sum(sp_walsh(:)));         
    %------------Haar-----------------------------
    sp_haar_lp=zeros(1,SzX);
    sp_haar=abs(haar2_mb(im).^2);
    sp_haar_norm=sp_haar/(sum(sp_haar(:)));
    if ( strcmpi(LpfType, 'circular') )
        for L=1:N/2,
            [x, y] = meshgrid(1:size(im,1), 1:size(im,2));
            lpf_filter_fft=sqrt((x-round(size(im,2)/2)).^2 + (y-round(size(im,1)/2)).^2) < (L);         
            sp_dft_lp(L)=sum(sum(abs(lpf_filter_fft.*fftshift(sp_dft_norm))));
        end
        for L=1:N,
            [x, y] = meshgrid(1:size(im,1), 1:size(im,2));
            lpf_filter= sqrt((x).^2 + (y).^2) < (L); 
            sp_dct_lp(L)=sum(sum(abs(lpf_filter.*sp_dct_norm).^2));
            sp_walsh_lp(L)=sum(sum(abs(lpf_filter.*sp_walsh_norm)));
            sp_haar_lp(L)=sum(sum(abs(lpf_filter.*sp_haar_norm)));
        end
    elseif (strcmpi(LpfType, 'rectangular'))
        for L=1:N/2,
            sp_dft_lp(L)=2*sum(sp_dft_norm(2:L-1,1))+sp_dft_norm(L,1)+.......
                         2*sum(sp_dft_norm(1,2:L-1))+sp_dft_norm(1,L)+.......
                         2*(sum(sum(sp_dft_norm(2:L,2:L))))+......
                         2*(sum(sum(sp_dft_norm(2:L,N-L+2:N))));
        end
        for L=1:N,
            Lsum_1=1:L;
            sp_dct_lp(L)=sum(sum(abs(sp_dct_norm(Lsum_1,Lsum_1)).^2));
            sp_walsh_lp(L)=sum(sum(abs(sp_walsh_norm(Lsum_1,Lsum_1))));
            sp_haar_lp(L)=sum(sum(abs(sp_haar_norm(Lsum_1,Lsum_1))));
        end
    end

    plot(sp_dct_lp,'LineWidth',2, 'parent', ImageLPF.axes_5);  
    plot((2:2:SzX)/SzX,sp_dct_lp(2:2:SzX),'k-','LineWidth',2, 'parent', ImageLPF.axes_5);
    % 	axis([0.1 1 0.8 1]);
    hold( ImageLPF.axes_5, 'on');
    plot((1:SzX/2)/(SzX/2),sp_dft_lp,'c-','LineWidth',2, 'parent', ImageLPF.axes_5);
    plot((2:2:SzX)/SzX,sp_walsh_lp(2:2:SzX),'r-','LineWidth',2, 'parent', ImageLPF.axes_5);
    plot((2:2:SzX)/SzX,sp_haar_lp(2:2:SzX),'b-','LineWidth',2, 'parent', ImageLPF.axes_5);
    grid(ImageLPF.axes_5,  'on');
    ylabel('Fraction of signal energy','FontWeight','Bold','FontSize',12, 'parent', ImageLPF.axes_5);
    xlabel('Bandwidth (in fraction of the base band)','FontWeight','Bold','FontSize',12, 'parent', ImageLPF.axes_5);

    legend(ImageLPF.axes_5, 'DCT','DFT','Walsh','Haar',4, 'Location', 'best' );
    axis( ImageLPF.axes_5,'tight');
    hold( ImageLPF.axes_5, 'off');
guidata(a, handles);
process_image(handles.(handles.current_experiment_name).im, handles.(handles.current_experiment_name).Cut_offFreq, handles.(handles.current_experiment_name).LpfType, ...
    handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_2, handles.(handles.current_experiment_name).axes_3, ...
    handles.(handles.current_experiment_name).axes_4, handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6, ...
    handles.(handles.current_experiment_name).axes_7, handles.(handles.current_experiment_name).axes_8);

end

function process_image(im, Cut_offFreq, LpfType,...
    axes_1, axes_2, axes_3, axes_4, axes_5, axes_6, axes_7, axes_8)

    Cut_offFreq = round(Cut_offFreq*size(im,1));
    im_fft = fft2(im);
    im_dct = dct2(im);
    im_haar = haar2_mb(im);
    im_walsh = walsh2_mb(im);
    Cut_offFreq = size(im,1) - Cut_offFreq;
    if ( Cut_offFreq)
        if ( strcmpi(LpfType, 'circular'))
            [x, y] = meshgrid(1:size(im,1), 1:size(im,2));
            lpf_filter= sqrt((x).^2 + (y).^2) < (size(im,1) -  Cut_offFreq);
            lpf_filter_fft=sqrt((x-round(size(im,2)/2)).^2 + (y-round(size(im,1)/2)).^2) < (size(im,1)/2 - Cut_offFreq/2 );
        elseif (strcmpi(LpfType, 'rectangular') )
            Cut_offFreq = round(Cut_offFreq/2);
            lpf_filter_fft = ones(size(im));
            lpf_filter_fft(:,1:Cut_offFreq) = 0;
            lpf_filter_fft(1:Cut_offFreq,:) = 0;
            lpf_filter_fft(:,end:-1:end-Cut_offFreq) = 0;
            lpf_filter_fft(end:-1:end-Cut_offFreq,:) = 0;
            lpf_size = sqrt(sum(sum(lpf_filter_fft)));
            lpf_filter = ones(size(im));
            lpf_filter( max(1,lpf_size):end, :) = 0;
            lpf_filter( :, max(1,lpf_size):end) = 0;
        end
    else
        lpf_filter_fft = ones(size(im));
        lpf_filter = ones(size(im));
    end
    % fft
    CurrTransformed = fftshift(im_fft).*lpf_filter_fft;
    axes_children = get(axes_2, 'children');
    axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
    rmse = sqrt(mean(mean((abs(ifft2(CurrTransformed)) - im).^2)));
    set(axes_children, 'string', {'Restored image: DFT', ['RMS error= ' num2str(rmse, '%0.2f')]} );
    hold(axes_2, 'on');
    imshow(abs(ifft2(CurrTransformed)) , [0 255], 'parent', axes_2);
    % dct
    CurrTransformed = im_dct.*lpf_filter;
    axes_children = get(axes_3, 'children');
    axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
    rmse = sqrt(mean(mean((idct2(CurrTransformed) - im).^2)));
    set(axes_children, 'string', {'Restored image:  DCT', ['RMS error= ' num2str(rmse, '%0.2f')]} );
    hold(axes_3, 'on');
    imshow(idct2(CurrTransformed) , [0 255], 'parent', axes_3);
    % haar
    CurrTransformed = im_haar.*lpf_filter;
    axes_children = get(axes_6, 'children');
    axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
    rmse = sqrt(mean(mean((ihaar2_mb(CurrTransformed) - im).^2)));
    set(axes_children, 'string', {'Restored image: Haar transform', ['RMS error= ' num2str(rmse, '%0.2f')]} );

    hold(axes_6, 'on');
    imshow(ihaar2_mb(CurrTransformed) , [0 255], 'parent', axes_6);
    % walsh
    CurrTransformed = im_walsh.*lpf_filter;
    axes_children = get(axes_7, 'children');
    axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
    rmse = sqrt(mean(mean((iwalsh2_mb(CurrTransformed) - im).^2)));
    set(axes_children, 'string', {'Restored image: Walsh transform', ['RMS error= ' num2str(rmse, '%0.2f')]} );
    hold(axes_7, 'on');
    imshow(iwalsh2_mb(CurrTransformed) , [0 255], 'parent', axes_7);

    imshow(lpf_filter , [0 1], 'parent', axes_8);
    DisplayAxesTitle( axes_8,  'DCT, Walsh and Haar filter mask', 'BM',9);
    imshow(lpf_filter_fft, [0 1], 'parent', axes_4);
    DisplayAxesTitle( axes_4,  'DFT filter mask' , 'TM',9);
 end

