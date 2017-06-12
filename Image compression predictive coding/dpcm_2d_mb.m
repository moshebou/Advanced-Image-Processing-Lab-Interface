function [ output_args ] = dpcm_2d_mb( handles )
%DPCM_2D_MB Summary of this function goes here
%   Detailed explanation goes here
%% center of figure
butt_units =  get(handles.button1, 'units');
set(handles.button1, 'units', 'normalized');
butt_pos = get(handles.button1, 'position');
set(handles.button1, 'units', butt_units);

mid_point = [(1 + butt_pos(1) + butt_pos(3))/2 1/2];
max_height = 0.8;
max_width = 0.8;
handles.PredictiveCoding.dpcm_2d.in_image_axes = axes('parent', handles.figure1, ...
                                                                                                                                    'position', [ mid_point-0.4 mid_point(2) max_width/2 max_height/2], ...
                                                                                                                                    'ActivePositionProperty', 'position', ...
                                                                                                                                    'visible', 'off');
handles.PredictiveCoding.dpcm_2d.res_image_axes = axes('parent', handles.figure1, ...
                                                                                                                                    'position', [ mid_point-0.4 mid_point(2) max_width/2 max_height/2], ...
                                                                                                                                    'ActivePositionProperty', 'position', ...
                                                                                                                                    'visible', 'off');
handles.PredictiveCoding.dpcm_2d.error_exes = axes('parent', handles.figure1, ...
                                                                                                                                    'position', [ mid_point-0.4 mid_point(2) max_width/2 max_height/2], ...
                                                                                                                                    'ActivePositionProperty', 'position', ...
                                                                                                                                    'visible', 'off');
handles.PredictiveCoding.dpcm_2d.res_image_axes = axes('parent', handles.figure1, ...
                                                                                                                                    'position', [ mid_point-0.4 mid_point(2) max_width/2 max_height/2], ...
                                                                                                                                    'ActivePositionProperty', 'position', ...
                                                                                                                                    'visible', 'off');                                                                                                                                
 [res_im, restor_error, qunatized_prediction_error_hist]  = dpcm_2d(INPIMG,mxm,QQ,P);
imshow( handles.PredictiveCoding.dpcm_2d.in_image_axes, im);
imshow( handles.PredictiveCoding.dpcm_2d.res_image_axes, res_im);
imshow( handles.PredictiveCoding.dpcm_2d.error_exes, restor_error);
plot( handles.PredictiveCoding.dpcm_2d.error_hist_axes, qunatized_prediction_error_hist);

end

function  OUTIMG=dpcm_2d(INPIMG,mxm,BPP,P)

% Simulation of DPCM with 2D prediction
% Difference signal quantization on 2^(BBP-1) levels in the range [-mxm,mxm]
% with non-linear (P)-law pre-distortion
% Additive or impulse noise in the prediction error transmission channel 
% Copyright L. Yaroslavsky (yaro@eng.tau.ac.il) 
% Call OUTIMG=dpcm1D(INPIMG,mxm,BPP,P);

Q=2^(BPP-1);
[SzX SzY]=size(INPIMG);
OUTIMG=zeros(SzX,SzY);OUTIMG(:,1)=INPIMG(:,1);
% First row
for y=2:SzY,
	diff=INPIMG(1,y)-OUTIMG(1,y-1);
	signdiff=sign(diff);
	absdiff=abs(diff); if absdiff>mxm, absdiff=mxm;end
	absdiff_quant=round(Q*((absdiff/mxm).^P));
	diff_quant=signdiff.*absdiff_quant;
   switch m
   case 1,
      diff_quant_noise=diff_quant+sigma*randn(1,1);
   case 2
      err=rand<Perr;
      noise=2*Q*(rand-0.5);
      diff_quant_noise=(1-err)*diff_quant+err*noise;
   end
   diff_quant_noise=mxm*sign(diff_quant_noise).*(abs(diff_quant_noise)/Q).^(1/P);
	OUTIMG(1,y)=round(OUTIMG(1,y-1)+diff_quant_noise);
end

% Remaining rows

for x=2:SzX,
	for y=2:SzY-1,
	
	diff=INPIMG(x,y)-0.3*(OUTIMG(x,y-1)+OUTIMG(x-1,y))-0.2*(OUTIMG(x-1,y-1)+OUTIMG(x-1,y+1));
	signdiff=sign(diff);
	absdiff=abs(diff); if absdiff>mxm, absdiff=mxm;end
	absdiff_quant=round(Q*((absdiff/mxm).^P));
	diff_quant=signdiff.*absdiff_quant;
   switch m
   case 1,
      diff_quant_noise=diff_quant+sigma*randn(1,1);
   case 2
      err=rand<Perr;
      noise=2*Q*(rand-0.5);
      diff_quant_noise=(1-err)*diff_quant+err*noise;
   end
   diff_quant_noise=mxm*sign(diff_quant_noise).*(abs(diff_quant_noise)/Q).^(1/P);
	OUTIMG(x,y)=round(0.3*(OUTIMG(x,y-1)+OUTIMG(x-1,y))+0.2*(OUTIMG(x-1,y-1)+OUTIMG(x-1,y+1))+diff_quant_noise);
	end

	% Last pixel in row

	diff=INPIMG(x,SzY)-0.35*(OUTIMG(x,SzY-1)+OUTIMG(x-1,SzY))-0.3*OUTIMG(x-1,SzY-1);
	
	signdiff=sign(diff);
	absdiff=abs(diff); if absdiff>mxm, absdiff=mxm;end
	absdiff_quant=round(Q*((absdiff/mxm).^P));
	diff_quant=signdiff.*absdiff_quant;

   diff_quant_noise=mxm*sign(diff_quant_noise).*(abs(diff_quant_noise)/Q).^(1/P);
   OUTIMG(x,SzY)=round(0.35*(OUTIMG(x,SzY-1)+OUTIMG(x-1,SzY))+0.3*OUTIMG(x-1,SzY-1)+diff_quant_noise);
   %keyboard

end

stderr=std2(INPIMG-OUTIMG);
   
end