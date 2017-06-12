function [out, mse] = lloydmax_quant ( in, q )
in = double(in(:));
quant_eps = 0.0001;
MAX_ITERATION = 1000;
iteration_num = 0;

x_unique = unique(in(:));
if ( length ( x_unique ) < q )
    out = in;
    mse = 0;
    return;
end

min_in = min(in(:));
max_in = max(in(:));
length_in = length(in(:));
x = linspace(min_in, max_in, q);
% calc partitions
partition = (x(2:end) + x(1:end-1))/2;
% quantize
% idx = zeros(size(in));
idx1 = zeros(size(in));
% tic
for i = 1 : length(x)-1
    idx1 = idx1 + (in>partition(i));
end
% toc
% tic
% idx2 = sum(in(:)*ones(1, q-1) > ones(length_in, 1)*partition,2);
% toc
% if( sum(idx1(:)~=idx2(:)))
%     s = 0;
% else
%     idx = idx1;
% end
out = x(idx1+1)';
% calc mean square error
mse = mean((out-in).^2);

mse_old = inf;
while ((MAX_ITERATION > iteration_num) & ((mse+quant_eps) < mse_old))
    mse_old = mse;
    % calc code book
    for i = 1 : length(x)
        x(i) = mean(in((idx1+1)==i));
    end
    % calc partitions
    partition = (x(2:end) + x(1:end-1))/2;
    % quantize
    idx1 = zeros(size(in));

%     tic
    for i = 1 : length(x)-1
        idx1 = idx1 + (in>partition(i));
    end
%     end
%     toc
%     tic
%     idx2 = reshape(sum(in(:)*ones(1, q-1) > ones(length_in, 1)*partition,2), size(in));
%     toc
%     if( sum(idx1(:)~=idx2(:)))
%         s = 0;
%     else
%         idx = idx1;
%     end
    out = x(idx1+1)';
    % calc mean square error
    mse = mean((out-in).^2);
    iteration_num = iteration_num +1;
end


end