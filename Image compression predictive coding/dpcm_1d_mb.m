function [ output_args ] = dpcm_1d_mb( handles )
%DPCM_1D Summary of this function goes here
%   Detailed explanation goes here

%% center of figure
butt_units =  get(handles.button1, 'units');
set(handles.button1, 'units', 'normalized');
butt_pos = get(handles.button1, 'position');
set(handles.button1, 'units', butt_units);

mid_point = [(1 + butt_pos(1) + butt_pos(3))/2 1/2];
max_height = 0.8;
max_width = 0.8;
handles.PredictiveCoding.dpcm_1d.in_image_axes = axes('parent', handles.figure1, ...
                                                                                                                                    'position', [ mid_point-0.4 mid_point(2) 0.4 0.4], ...
                                                                                                                                    'ActivePositionProperty', 'position', ...
                                                                                                                                    'visible', 'off');
handles.PredictiveCoding.dpcm_1d.res_image_axes = axes('parent', handles.figure1, ...
                                                                                                                                    'position', [ mid_point-0.4 mid_point(2) 0.4 0.4], ...
                                                                                                                                    'ActivePositionProperty', 'position', ...
                                                                                                                                    'visible', 'off');
handles.PredictiveCoding.dpcm_1d.error_exes = axes('parent', handles.figure1, ...
                                                                                                                                    'position', [ mid_point-0.4 mid_point(2) 0.4 0.4], ...
                                                                                                                                    'ActivePositionProperty', 'position', ...
                                                                                                                                    'visible', 'off');
handles.PredictiveCoding.dpcm_1d.res_image_axes = axes('parent', handles.figure1, ...
                                                                                                                                    'position', [ mid_point-0.4 mid_point(2) 0.4 0.4], ...
                                                                                                                                    'ActivePositionProperty', 'position', ...
                                                                                                                                    'visible', 'off');                                                                                                                                
 [res_im, restor_error, qunatized_prediction_error_hist]  = dpcm_1d(INPIMG,mxm,QQ,P);
imshow( handles.PredictiveCoding.dpcm_1d.in_image_axes, im);
imshow( handles.PredictiveCoding.dpcm_1d.res_image_axes, res_im);
imshow( handles.PredictiveCoding.dpcm_1d.error_exes, restor_error);
plot( handles.PredictiveCoding.dpcm_1d.error_hist_axes, qunatized_prediction_error_hist);
end

function [res_im, Restor_error, qunatized_prediction_error_hist, mn,stderr] = dpcm_1d(INPIMG,mxm,QQ,P)
Q=round((QQ-1)/2);

OUTIMG=zeros(SzX,SzY);
OUTIMG(:,1)=INPIMG(:,1);
OUTIMG_0=zeros(SzX,SzY);
OUTIMG_0(:,1)=INPIMG(:,1);
h=zeros(1,256);


for y=2:SzY,
	diff=double(INPIMG(:,y))-0.95*OUTIMG_0(:,y-1);
	signdiff=sign(diff);
	absdiff=abs(diff);
    absdiff=absdiff.*(absdiff<=mxm)+mxm*(absdiff>mxm);
    absdiff_quant=round(Q*((absdiff/mxm).^P));
	h=h+imghisto(absdiff_quant')/(SzY-1);
    diff_quant=signdiff.*absdiff_quant;
    diff_quant_noise_r=mxm*sign(diff_quant_noise).*(abs(diff_quant_noise)/Q).^(1/P);
    diff_quant_r=mxm*sign(diff_quant).*(abs(diff_quant)/Q).^(1/P);
    OUTIMG_0(:,y)=round(0.95*OUTIMG_0(:,y-1)+diff_quant_r);
    OUTIMG(:,y)=round(0.95*OUTIMG(:,y-1)+diff_quant_noise_r);
end

h=h(1:Q+1)/SzX;hh=[h,h(2:Q+1)];
hh=hh/sum(hh);
H=-sum(hh.*log2(hh+eps));
[mn,stderr]=std2d(double(INPIMG)-double(OUTIMG));
res_im = OUTIMG;
Restor_error  =double(INPIMG)-double(OUTIMG);
qunatized_prediction_error_hist = H;
end