function h = entrpy_calc_mb(x)
% function h = entrpy_calc(x)
% x must be a vector with integer components!
% according to definition in
% Image Transform Coding Laboratory by Claudio Weidmann
% and Course in Coding by dr Kieffer (www.ece.umn.edu./users/kieffer )

x = x(:);                     % to make sure it's a vector
x = x-min(x);
bins = [0:max(x)];
p = hist(x,bins);             % histogram
p = p((p>0))/length(x);   % eliminate empty bin
h = -sum(p.*log2(p));         % Entropy


