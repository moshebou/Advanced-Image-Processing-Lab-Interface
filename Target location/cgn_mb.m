function im_noise = cgn_mb(im, snr, RE, RI)
    im = double(im);
    [Height, Width] = size(im);
    Noise=corrgauss_mb(max(Height, Width),RE,RI);
    Noise = Noise(1:Height, 1: Width);
    Noise = Noise - mean(Noise(:));
    Noise = sqrt(1/(var(Noise(:))*snr))*Noise;
%     Noise = (sqrt(Power).*Noise)./(sqrt(snr*sum(Noise(:).^2)));
    
    im_noise = im+Noise;
end