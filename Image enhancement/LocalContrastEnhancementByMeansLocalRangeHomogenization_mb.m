%% Image Homogenization
%  Image Local Min-Max and Variance-Mean Calibration
%% Experiment Description:
% This experiment illustrates local histogram calibration. 
%
% Two calibrations are introduced:
%
% *Min-Max calibration* - change the appearance of the image by
% modify the image local min and max values.
%
% *Local variance calibration* - change the appearance of the image by
% modify the image local variance.
%
%% Tasks:
% 12.3.4 
% 
% Test image local calibration by local mean and variance (program
% lcstanda.m) and local maximum and minimum (program lcmxmnst.m).
%% Instruction:
% Use the 'Set Local Variance' slider to set the variance of each local window.
% 
% Use the  'Set Window Width', 'Set Window Height' sliders to set the local
% window width and height respectively.
%% Theoretical Background & algorithm:
% *Local Variance calibration -*
%
% A local contrast enhancement method which enhance local contrast by
% calibrating the image local variance values to a desired value [1].
%
% $$ n = \frac{window_{height}-1}{2} $$
%
% $$ m = \frac{window_{width}-1}{2} $$
%
% $$ \mu_{i,j} =\frac{1}{(2n+1)\cdot(2m+1)}\sum_{y=i-n}^{n+i}\sum_{x=j-m}^{m+j}{Image(x,y)} $$
% 
% $$\sigma_{i,j}^2 =\frac{1}{(2n+1)\cdot(2m+1)}\sum_{y=i-n}^{n+i}\sum_{x=j-m}^{m+j}(Image(x,y) - \mu_{i,j})^2$$
%
% $$ Image_{res}(i,j)= \mu_{i,j} + \sqrt{\frac{\sigma_{desired}^2}{\sigma_{i,j}^2}}(Image(x,y) -  \mu_{i,j})  $$
%
% *Local Min-Max calibration -*
% A local contrast enhancement method which enhance local contrast by
% stretching local histogram [2].
%
% $$ n = \frac{window_{height}-1}{2} $$
%
% $$ m = \frac{window_{width}-1}{2} $$
%
% $$ MinVal_{i,j} = min_{y=i-n}^{n+i}min_{y=i-n}^{n+i}Image(x,y) $$
%
% $$ MaxVal_{i,j} = max_{y=i-n}^{n+i}max_{y=i-n}^{n+i}Image(x,y) $$
%
% $$ Image_{res}(i,j)= (2^l-1) \cdot \frac {Image(i,j)  - MinVal_{i,j}} {MaxVal_{i,j} - MinVal_{i,j}}$$
%
% Where $l$ is number of bits (usually 8)
%% Reference:
% [1] J. S. Lee, “Digital image enhancement and noise filtering by using local statistics”, IEEE Trans. Pattern Anal. Machine Intell., vol. PAMI-2, pp.165–168, Feb. 1980.
%
% [2] S. S. Al-amri, "Contrast Stretching Enhancement in Remote Sensing Image", BIOINFO Sensor Networks, Volume 1, Issue 1, 2011, pp-06-09
%%
function LocalContrastEnhancementByMeansLocalRangeHomogenization = LocalContrastEnhancementByMeansLocalRangeHomogenization_mb( handles )
    %LocalContrastEnhancementByMeansLocalRangeHomogenization_mb Summary of this function goes here
    %   Detailed explanation goes here
    axes_hor = 3;
    axes_ver = 2;
    is_outerposition = zeros(1, axes_hor*axes_ver);
    is_outerposition(4:end) = 1;
    button_pos = get(handles.pushbutton12, 'position');
    bottom =button_pos(2);
    left = button_pos(1)+button_pos(3);
    LocalContrastEnhancementByMeansLocalRangeHomogenization = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9, ...
            is_outerposition);
            
            
%
            
    LocalContrastEnhancementByMeansLocalRangeHomogenization.im_1 = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    LocalContrastEnhancementByMeansLocalRangeHomogenization.SzX = 5;
    LocalContrastEnhancementByMeansLocalRangeHomogenization.SzY = 5;
    LocalContrastEnhancementByMeansLocalRangeHomogenization.STD = 100;

    %
	k=1;
	interface_params(k).style = 'pushbutton';
	interface_params(k).title = 'Run Experiment';
	interface_params(k).callback = @(a,b)run_process_image(a);
    k=k+1;
    interface_params =  SetSliderParams('Set Local StDeviation', 255, 1, LocalContrastEnhancementByMeansLocalRangeHomogenization.STD, 1, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'STD',@update_sliders), interface_params, k);

    k=k+1;
    interface_params =  SetSliderParams('Set Window Width', 25, 1, LocalContrastEnhancementByMeansLocalRangeHomogenization.SzX, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzX',@update_sliders), interface_params, k);

    k=k+1;
    interface_params =  SetSliderParams('Set Window Height', 25, 1, LocalContrastEnhancementByMeansLocalRangeHomogenization.SzY, 2, @(a,b)SetParam(a,b,k,handles.current_experiment_name, 'SzY',@update_sliders), interface_params, k);  
    %



    
    
    
    
    
    
    
    
    

    LocalContrastEnhancementByMeansLocalRangeHomogenization.buttongroup_handle = SetInteractiveInterface(handles, interface_params); 
                 


    imshow(LocalContrastEnhancementByMeansLocalRangeHomogenization.im_1, [0 255], 'parent', LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_1);
    DisplayAxesTitle( LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_1, 'Test image','TM',10);
    h1 = histc(LocalContrastEnhancementByMeansLocalRangeHomogenization.im_1(:), [0:255]);
    plot( h1, 'parent', LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_4, 'linewidth', 2);
    title( LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_4, ['Test image histogram'], 'fontweight', 'bold'); 
    grid(LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_4, 'on');
    axis(LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_4, 'tight');
%     process_image( LocalContrastEnhancementByMeansLocalRangeHomogenization.im_1, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.SzX, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.SzY, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.STD, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_1, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_2, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_3, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_4, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_5, ...
%     LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_6);



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


        LocalContrastEnhancementByMeansLocalRangeHomogenization = handles.(handles.current_experiment_name);
        process_image( LocalContrastEnhancementByMeansLocalRangeHomogenization.im_1, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.SzX, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.SzY, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.STD, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_1, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_2, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_3, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_4, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_5, ...
            LocalContrastEnhancementByMeansLocalRangeHomogenization.axes_6);

end








function process_image( im_1, SzX, SzY, STD, axes_1, axes_2, axes_3, axes_4, axes_5, axes_6)
im_1 = double(im_1);
OUTIMG1=lcmxmnst_mb(im_1,SzY,SzX);
OUTIMG2=lcstanda_mb(im_1,SzY,SzX, STD);


h2 = histc(OUTIMG1(:), [0:255]);
h3 = histc(OUTIMG2(:), [0:255]);


imshow( OUTIMG1, [0 255], 'parent', axes_2);
DisplayAxesTitle( axes_2, ['Image standardization by Local max & min'],   'TM'); 
imshow( OUTIMG2, [0 255], 'parent', axes_3);
DisplayAxesTitle( axes_3, ['Image standardization by local StDeviation'],   'TM'); 




plot( h2, 'parent', axes_5, 'linewidth', 2);
title( axes_5, ['Histogram image standardization'], 'fontweight', 'bold'); 
grid(axes_5, 'on');
axis(axes_5, 'tight');

plot( h3, 'parent', axes_6, 'linewidth', 2);
title( axes_6, ['Histogram filtered image'], 'fontweight', 'bold'); 
grid(axes_6, 'on');
axis(axes_6, 'tight');

end
