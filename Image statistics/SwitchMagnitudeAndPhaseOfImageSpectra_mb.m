function SwitchMagnitudeAndPhaseOfImageSpectra= SwitchMagnitudeAndPhaseOfImageSpectra_mb( handles )
% Task:
% Compute magnitude and phase components of DFT spectra of two images;
% exchange the magnitude components between two images and then reconstruct obtained
% spectra. Compare resulting images.
    handles = guidata(handles.figure1);
            
   axes_hor = 2;
   axes_ver = 2;
   button_pos = get(handles.pushbutton12, 'position');
   bottom =button_pos(2);
   left = button_pos(1)+button_pos(3);
        SwitchMagnitudeAndPhaseOfImageSpectra = DeployAxes( handles.figure1, ...
            [axes_hor, ...
            axes_ver], ...
            bottom, ...
            left, ...
            0.9, ...
            0.9);
    


                                                
    
    SwitchMagnitudeAndPhaseOfImageSpectra.im1 = HandleFileList('load' , HandleFileList('get' , handles.image_index));
    SwitchMagnitudeAndPhaseOfImageSpectra.im2= HandleFileList('load' , HandleFileList('get' , handles.image_index2));    
    process_image(SwitchMagnitudeAndPhaseOfImageSpectra.im1, SwitchMagnitudeAndPhaseOfImageSpectra.im2, ...
        SwitchMagnitudeAndPhaseOfImageSpectra.axes_1 , SwitchMagnitudeAndPhaseOfImageSpectra.axes_2, SwitchMagnitudeAndPhaseOfImageSpectra.axes_3, SwitchMagnitudeAndPhaseOfImageSpectra.axes_4);

end

function process_image( im1, im2, axes_1, axes_2, axes_3, axes_4)
    im1_fft = fft2(im1);
    im2_fft = fft2(im2);
    im1_fft_phz = angle(im1_fft);
%     im1_fft_real = real(im1_fft);
%     im1_fft_imag = imag(im1_fft);
    im2_fft_phz = angle(im2_fft);
    im1_fft_abs = abs(im1_fft);
    im2_fft_abs = abs(im2_fft);
%     im2_fft_real = real(im2_fft);
%     im2_fft_imag = imag(im2_fft);    
    im1_res = ifft2(im2_fft_abs.*exp(1i*im1_fft_phz));
    im2_res = ifft2(im1_fft_abs.*exp(1i*im2_fft_phz));
%     im1_real_w_im2_imag = ifft2(im1_fft_real + 1i*im2_fft_imag);
%     im2_real_w_im2_imag = ifft2(im2_fft_real + 1i*im1_fft_imag);
    imshow(im1, [],'parent', axes_1);
    DisplayAxesTitle( axes_1, [ 'Image-1'], 'TM',10); 
    
     imshow(im2, [],'parent', axes_3);
     DisplayAxesTitle( axes_3, [ 'Image-2'], 'BM',10); 
     
     imshow(abs(im1_res), [],'parent', axes_2);
     DisplayAxesTitle( axes_2, { 'Image-2 spectrum magnitude', 'Image-1 spectrum phase'}, 'TM',10); 
     
     imshow(abs(im2_res), [],'parent', axes_4);   
     DisplayAxesTitle( axes_4, { 'Image-1 spectrum magnitude','Image-2 spectrum phase'}, 'BM',10); 
     

end