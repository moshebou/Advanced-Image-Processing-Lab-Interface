function omega_n= least_squares(Y, data)
     omega_n =  Y'*data'*(data*data')^-1;
end
