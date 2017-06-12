function SignalWithNoise = awgn_mb(Signal, snr, type, state)

pre_noise = randn(size(Signal));
noise_power = sum(pre_noise(:).^2);
signal_power = sum(Signal(:).^2);
noise = sqrt(signal_power/(snr*noise_power))*pre_noise;
noise = noise - mean(noise(:));
SignalWithNoise = uint8(Signal) + uint8(noise); 