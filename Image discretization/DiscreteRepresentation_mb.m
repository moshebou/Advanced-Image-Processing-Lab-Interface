%% Discrete Representation
%  Image discrete representation in different discretization bases   
%% Experiment Description:
% This experiment introduce 2-D Fourier, Discrete Cosine, Walsh and Haar
% transforms, and the effect of zeroing coefficients have on the reconstructed (inverse transformed)image. 
%
% Four reconstructed images are presented, one for each transform, after
% the coefficients with the smallest value are zeroed, to satisfy the energy
% threshold requirement.
%% Tasks:
% 1.1 
%
% * Investigate how the accuracy of image discrete representation in different
% discretization bases depends on the representation volume and on the type of the
% discretization transform.
% * For Discrete Fourier Transform, Discrete Cosine Transform, Walsh Transform, Haar Transform bases,
% set to zero transform coefficients whose magnitude is lower than a certain threshold. 
% * Use the threshold as a varying parameter.
% * Measure total energy of the zeroed coefficients relative to the entire energy of the
% coefficients and their percentage with respect to all coefficients and observe how quality
% of the reconstructed image depends on this percentage and on the discretization basis.
% * Compare image reconstruction RMS error for different bases given the same percentage
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
% $$ I(x,y) = \frac{1}{height \cdot width}\sum_{y=1}^{height}\sum_{x=1}^{width}X(m,n)e^{\frac{2i(y-1)(n-1)\pi}{height}}e^{\frac{2i(x-1)(m-1)\pi}{width}}$$ 
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
% The Hadamard transform can be defined recursively:
%
% $H0 = 1$ and Hm is defined for m > 0 by:
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
% The Haar transform matrix ${\bf H}$ is a NxN matrix of real and orthogonal vectors. It can be defined as:
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
%% Reference:
% * [1]
% <http://www.eng.tau.ac.il/~yaro/lectnotes/pdf/L4_SignalDiscreti&Sampling.pdf
% L. Yaroslavsky, Lec. 4 Principles of signal digitization. Signal sampling>
 


function DiscreteRepresentation = DiscreteRepresentation_mb( handles )

if (nargin == 0 ) ; return; end;
    handles = guidata(handles.figure1);
    axes_hor = 3;
    axes_ver = 2;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    DiscreteRepresentation = DeployAxes( handles.figure1, ...
    [axes_hor, ...
    axes_ver], ...
    bottom, ...
    left, ...
    0.9, ...
    0.9);


    DiscreteRepresentation.energy_level = 100;
    DiscreteRepresentation.displayed_image = 'Reconstructed Image';
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
    interface_params = SetSliderParams('Set Energy Threshold(%)', ...
    100, 50, DiscreteRepresentation.energy_level, ...
    1, @(a,b)SetParam(a,b,k, handles.current_experiment_name, 'energy_level',@update_sliders), interface_params, k); 
    k=k+1;    
    interface_params(k).style = 'buttongroup';
    interface_params(k).title = 'Image or Spectrum';
    interface_params(k).selection ={ 'Reconstructed Image', 'Spectrum'};   
    interface_params(k).value = find(strcmpi(interface_params(k).selection, DiscreteRepresentation.displayed_image));
    interface_params(k).callback = @(a,b)ChooseDisplayedImage(a,b,handles);


    DiscreteRepresentation.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
         
    
    DiscreteRepresentation.im_1 = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    imshow(DiscreteRepresentation.im_1, [0 255], 'parent', DiscreteRepresentation.axes_1);
    DisplayAxesTitle( DiscreteRepresentation.axes_1,  'Test image','TM',9);

    imshow(ifft2(fft2(DiscreteRepresentation.im_1)), [0 255], 'parent', DiscreteRepresentation.axes_2);
    DisplayAxesTitle( DiscreteRepresentation.axes_2,  {'Restored image: DFT','100% energy' },'TM',9);

    imshow(idct2(dct2(DiscreteRepresentation.im_1)), [0 255], 'parent', DiscreteRepresentation.axes_3);
    DisplayAxesTitle( DiscreteRepresentation.axes_3,  {'Restored image: DCT','100% energy' },'TM',9);

    imshow(ihaar2_mb(haar2_mb(DiscreteRepresentation.im_1)), [0 255], 'parent', DiscreteRepresentation.axes_5);
    DisplayAxesTitle( DiscreteRepresentation.axes_5,  {'Restored image: Haar transform','100% energy' }, 'BM', 9);

    imshow(iwalsh2_mb(walsh2_mb(DiscreteRepresentation.im_1)), [0 255], 'parent', DiscreteRepresentation.axes_6);
    DisplayAxesTitle( DiscreteRepresentation.axes_6,  {'Restored image: Walsh transform','100% energy' }, 'BM', 9);


 end

function ChooseDisplayedImage(a,b,handles)
handles = guidata(handles.figure1);
handles.(handles.current_experiment_name).displayed_image = get(b.NewValue, 'string');
guidata(handles.figure1, handles);
process_image(handles.(handles.current_experiment_name).im_1, handles.(handles.current_experiment_name).energy_level, handles.(handles.current_experiment_name).displayed_image, ...
    handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_2, handles.(handles.current_experiment_name).axes_3, handles.(handles.current_experiment_name).axes_4, handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6)

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

process_image(handles.(handles.current_experiment_name).im_1, handles.(handles.current_experiment_name).energy_level, handles.(handles.current_experiment_name).displayed_image, ...
    handles.(handles.current_experiment_name).axes_1, handles.(handles.current_experiment_name).axes_2, handles.(handles.current_experiment_name).axes_3, handles.(handles.current_experiment_name).axes_4, handles.(handles.current_experiment_name).axes_5, handles.(handles.current_experiment_name).axes_6)
end


function process_image(im, energy_level, image_or_spectrum,...
    axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
    im_fft = fft2(im);
    im_dct = dct2(im);
    im_haar = haar2_mb(im);
    im_walsh = walsh2_mb(im);
    title_string = {'Fraction of spectrum energy vs fraction',
    'of spectral coefficients'};  
    line_styles = {'k-', 'c-', 'r-', 'b-'};
    for i=1:4
        if ( i ==1 )
            CurrTransformed = im_fft;
        elseif ( i == 2 )
            CurrTransformed = im_dct;
        elseif ( i == 3 )
            CurrTransformed = im_haar;
        elseif ( i == 4 )
            CurrTransformed = im_walsh;
        end
        DC=CurrTransformed(1,1);
        CurrTransformed(1,1) = 0;
        samples_energy = abs(CurrTransformed(:)).^2;
        spdft_sort     = sort(samples_energy);
        Energy = sum(spdft_sort);

        cumsum_spdft_sort = spdft_sort(end:-1:1)/Energy;
        cumsum_spdft_sort = cumsum(cumsum_spdft_sort);
        EnergyPercentage = min(1, max(0, cumsum_spdft_sort));
        S = spdft_sort(end:-1:1);
        CurrTransformed(samples_energy < min(S(EnergyPercentage<=(energy_level/100)))) = 0;
        C=sum(EnergyPercentage<=(energy_level/100));
        Cn=100*C/(length(im(:))-1);
        CurrTransformed(1,1)=DC;
        if ( i ==1 )
            axes_children = get(axes_2, 'children');
            axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
            set(axes_children, 'string', {'Restored image: DFT',[num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            hold(axes_2, 'on');
            if ( strcmpi(image_or_spectrum, 'Reconstructed Image'))
                imshow(real(ifft2(CurrTransformed) ), [0 255], 'parent', axes_2);
                set(axes_children, 'string', {'Restored image: DFT',[num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            else
                imshow(fftshift(abs(CurrTransformed).^0.3), [], 'parent', axes_2);
                set(axes_children, 'string', {'DFT',[num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            end
        elseif ( i == 2 )
            axes_children = get(axes_3, 'children');
            axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
            hold(axes_3, 'on');
            if ( strcmpi(image_or_spectrum, 'Reconstructed Image'))
                imshow(real(idct2(CurrTransformed)) , [0 255], 'parent', axes_3);
                set(axes_children, 'string', {'Restored image: DCT',[num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            else
                imshow(abs(CurrTransformed).^0.3, [], 'parent', axes_3);
                set(axes_children, 'string', {'DCT',[num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            end
        elseif ( i == 3 )
            axes_children = get(axes_5, 'children');
            axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
            hold(axes_5, 'on');
            if ( strcmpi(image_or_spectrum, 'Reconstructed Image'))
                imshow(real(ihaar2_mb(CurrTransformed)) , [0 255], 'parent', axes_5);            
                set(axes_children, 'string', {'Restored image: Haar transform',[num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            else
                imshow(abs(CurrTransformed).^0.3, [], 'parent', axes_5);
                set(axes_children, 'string', {'Haar transform',[num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            end
        elseif ( i == 4 )
            axes_children = get(axes_6, 'children');
            axes_children = axes_children(strcmpi(get(axes_children, 'type'), 'text'));
            hold(axes_6, 'on');
            if ( strcmpi(image_or_spectrum, 'Reconstructed Image'))
                imshow(real(iwalsh2_mb(CurrTransformed)), [0 255], 'parent', axes_6);            
                set(axes_children, 'string', {'Restored image: Walsh transform',[ num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            else
                imshow(abs(CurrTransformed).^0.3, [], 'parent', axes_6);
                set(axes_children, 'string', {'Walsh transform',[ num2str(100*(sum(abs(CurrTransformed(:).^2))-DC^2)/Energy, '%0.f') '% energy; ',num2str(Cn,'%0.2f') '% of coeffitients']});
            end

        end

        
        X=linspace(1/length(EnergyPercentage), 1, length(EnergyPercentage));
        Level=energy_level*ones(size(X));
        loglog(X,EnergyPercentage,line_styles{i},'LineWidth',2, 'parent', axes_4);
        set(axes_4, 'ylim', [ 0.1 1]);
        set(axes_4, 'xlim', [ 0.00001 1]);
        hold(axes_4, 'on');

    end
    loglog(X,   Level/100,'r--','LineWidth',1, 'parent', axes_4);
    grid(axes_4, 'on');
%     DisplayAxesTitle(axes_4, title_string,'BM',9)
    xlabel(axes_4, {'', 'Fraction of ordered spectral coefficients'},'FontWeight','Bold','FontSize',9);
    ylabel(axes_4, 'Fraction of spectrum energy','FontWeight','Bold','FontSize',9);
    set(axes_4,'FontSize',10,'FontWeight','Bold')
    legend(axes_4, 'DFT','DCT','Haar','Walsh','Energy threshold','location', 'best' );
    hold(axes_4, 'off');
 end
