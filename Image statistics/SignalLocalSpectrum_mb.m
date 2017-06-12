function SignalLocalSpectrum= SignalLocalSpectrum_mb( handles )
%GLOBALHISTOGRAMLOCALHISTOGRAM_MB Summary of this function goes here
%   Detailed explanation goes here
	handles = guidata(handles.figure1);
	axes_pos = {[5,1]};
	button_pos = get(handles.pushbutton12, 'position');
	bottom =button_pos(2);
	left = button_pos(1)+button_pos(3);
	SignalLocalSpectrum = DeployAxes( handles.figure1, ...
	axes_pos, ...
	bottom, ...
	left, ...
	0.9, ...
	0.9);
	SignalLocalSpectrum.signal = HandleFileList('load' , HandleFileList('get signal' , handles.signal_index));
	SignalLocalSpectrum.WndSz =32;
	size = 2.^[1:8];
    
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
	k=k+1;
	interface_params =  SetSliderParams('Set Window Size', size, 2, log2(SignalLocalSpectrum.WndSz), 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'WndSz',@update_sliders, size), interface_params, k);



	SignalLocalSpectrum.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
	     
	process_image (SignalLocalSpectrum.signal,   SignalLocalSpectrum.WndSz, ... 
	SignalLocalSpectrum.axes_1 , SignalLocalSpectrum.axes_2, SignalLocalSpectrum.axes_3, SignalLocalSpectrum.axes_4, SignalLocalSpectrum.axes_5);
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
    SignalLocalSpectrum = handles.(handles.current_experiment_name);
    process_image (SignalLocalSpectrum.signal,   SignalLocalSpectrum.WndSz, ... 
        SignalLocalSpectrum.axes_1 , SignalLocalSpectrum.axes_2, SignalLocalSpectrum.axes_3, SignalLocalSpectrum.axes_4, SignalLocalSpectrum.axes_5);

end

function process_image (signal,  WndSz, axes_1 , axes_2, axes_3, axes_4, axes_5)
    signal = signal(:)';
    signal = signal(1:min(1024, length(signal(:))))';
    plot(signal,'parent', axes_1);
%     DisplayAxesTitle(axes_1,{' ', 'Test signal'}, 'TM',10);
    title( axes_1, ['Test signal'], 'fontweight','bold');
    grid(axes_1, 'on');
    axis(axes_1, 'tight');
    lcl_signal = im2col(signal', [1, WndSz]);
  
    lcl_signal_dft = fft(lcl_signal);
    LOCSPEC2_dft=abs(lcl_signal_dft).^2;
    norm_dft=max(max(LOCSPEC2_dft));
    LOCSPEC2_dft_norm=LOCSPEC2_dft/norm_dft;
    LOCSPEC2_dft_norm = LOCSPEC2_dft_norm.^0.3;
    lcl_signal_dft_normed = uint8(255*(LOCSPEC2_dft_norm - min(LOCSPEC2_dft_norm(:)))/(max(LOCSPEC2_dft_norm(:)) - min(LOCSPEC2_dft_norm(:))));
    
    image(lcl_signal_dft_normed, 'parent', axes_2 );
%     DisplayAxesTitle( axes_2, ['Local DFT spectrum'], 'TM',10);
    title( axes_2, ['Local DFT spectrum'], 'fontweight','bold');
    
    lcl_signal_dct = dct(lcl_signal);
    LOCSPEC2_dct=abs(lcl_signal_dct).^2;
    norm_dct=max(max(LOCSPEC2_dct));
    LOCSPEC2_dct_norm=LOCSPEC2_dct/norm_dct;
    LOCSPEC2_dct_norm = LOCSPEC2_dct_norm.^0.3;
    lcl_signal_dct_normed = uint8(255*(LOCSPEC2_dct_norm - min(LOCSPEC2_dct_norm(:)))/(max(LOCSPEC2_dct_norm(:)) - min(LOCSPEC2_dct_norm(:))));
  
    image(lcl_signal_dct_normed, 'parent', axes_3 );
%     DisplayAxesTitle( axes_3, ['Local DCT spectrum'], 'TM',10);
    title( axes_3, ['Local DCT spectrum'], 'fontweight','bold');
    
    n=log2(WndSz);
    HAR=haar(n);
    lcl_signal_haar=HAR*lcl_signal;
    LOCSPEC2_haar=abs(lcl_signal_haar).^2;
    norm_haar=max(max(LOCSPEC2_haar));
    LOCSPEC2_haar_norm=LOCSPEC2_haar/norm_haar;
    LOCSPEC2_haar_norm = LOCSPEC2_haar_norm.^0.3;
    lcl_signal_haar_normed = uint8(255*(LOCSPEC2_haar_norm - min(LOCSPEC2_haar_norm(:)))/(max(LOCSPEC2_haar_norm(:)) - min(LOCSPEC2_haar_norm(:))));
    image(lcl_signal_haar_normed, 'parent', axes_4 );
%     DisplayAxesTitle( axes_4, ['Local Haar spectrum'], 'TM',10);
    title( axes_4, ['Local Haar spectrum'], 'fontweight','bold');

    WAL=walsh(n);
    lcl_signal_walsh =WAL*lcl_signal;
    LOCSPEC2_walsh=abs(lcl_signal_walsh).^2;
    norm_walsh=max(max(LOCSPEC2_walsh));
    LOCSPEC2_walsh_norm=LOCSPEC2_walsh/norm_walsh;
    LOCSPEC2_walsh_norm = LOCSPEC2_walsh_norm.^0.3;
    lcl_signal_walsh_normed = uint8(255*(LOCSPEC2_walsh_norm - min(LOCSPEC2_walsh_norm(:)))/(max(LOCSPEC2_walsh_norm(:)) - min(LOCSPEC2_walsh_norm(:))));
   
    image(lcl_signal_walsh_normed, 'parent', axes_5 );
%     DisplayAxesTitle( axes_5, ['Local Walsh spectrum'], 'TM',10);
    title( axes_5, ['Local Walsh spectrum'], 'fontweight','bold');        
end

%--------------------------------------------------------------------------
function OUT=haar(n)

% Generating Haar matrix of the order 2^n.
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call OUT=haar(n);

E0=[1 1];
E1=[1 -1];
har_0=kron_n_mb(E0,n-1);
OUT=kron_n_mb(E0,n);
OUT=[OUT;kron(E1,har_0)];

for i=2:n,
	har_0=kron_n_mb(E0,n-i);
	har_i=kron(eye(2^(i-1)),E1);
	har_i=kron(har_i,har_0);
	OUT=[OUT;har_i];
end

norm=inv(sqrt(OUT*OUT'));
OUT=norm*OUT;
end

%--------------------------------------------------------------------------
function OUT=walsh(n)
% Matrix of Walsh Hadamard transform of the order 2^n
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il)  
% Call WAL=walsh(n);

Sz=2^n;
OUT=hadamard(Sz);
gray=grayperm_mb(n);
bin=bininv_mb(n);
OUT=gray*bin*OUT;

norm=inv(sqrt(OUT*OUT'));
OUT=norm*OUT;
end