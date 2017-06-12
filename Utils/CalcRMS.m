function rms = CalcRMS( in1, in2 )
%CALCRMS Summary of this function goes here
%   Detailed explanation goes here

rms = sqrt(mean((double(in1(:)) - double(in2(:))).^2));
end

