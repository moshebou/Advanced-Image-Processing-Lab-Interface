% function omega_n= recursive_least_squares(Y, data, b_waitbar)
function omega_n= recursive_least_squares(Y, data)
    N = size(data,1);
    omega_n = ones(N,1)/N;
    P_n = eye(N);
    length_Y = length(Y);
    for i = N:length_Y
        k_n = P_n*data(:, i)/(1+data(:, i)'*P_n*data(:, i));
        P_n = (eye(N) - k_n*data( :, i)')*P_n;
         omega_n = omega_n + k_n* (Y(i) - data( :, i)'*omega_n);
    end
end


