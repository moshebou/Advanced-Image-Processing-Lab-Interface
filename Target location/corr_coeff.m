function [Y,X] = corr_coeff( im, target)
   im = double(im);
   target = double(target);
   im_lcl_mean = filter2(ones(size(target))/length(target(:)), im);
   target_mean = mean(target(:));
   corr = filter2(target, im)- size(target,1)*size(target,2)*target_mean.*im_lcl_mean;
   var_A = (filter2(ones(size(target)), im.^2) - size(target,1)*size(target,2)*im_lcl_mean.^2).^0.5;
   var_B = sqrt(sum(sum(target.^2 - target_mean.^2)));
   corr = corr./(var_A*var_B);
    X = locatmax_mb(corr);
   Y = X(2); X = X(1);
end