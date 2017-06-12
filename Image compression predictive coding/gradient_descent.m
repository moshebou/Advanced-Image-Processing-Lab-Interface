function [w , sq_err]= gradient_descent(y,fact,y_tilde, e_th)
h = waitbar(0, 'please wait');
max_iterations =  10000;
curr_iter = 0;
w_init = ones(size(y_tilde,2),1)/size(y_tilde,2);
E =  (y_tilde)*w_init - y;
% alpha_0 = E'*E/(E'*y_tilde)*E
w = w_init-2*fact*y_tilde'*E;
E = (y_tilde)*w-y ;
sq_err = sum(E.^2);
strick = 0;
min_sq_err = inf;
while sq_err>e_th && max_iterations > curr_iter
    waitbar(curr_iter/max_iterations,h);
    curr_iter = curr_iter +1;
    w = w-2*fact*y_tilde'*E;
    E =  (y_tilde)*w-y;
    sq_err_old = sq_err;
    sq_err = sum(E.^2);
    if ( sq_err_old < sq_err)
        fact = fact/2;
        sq_err_older = sq_err_old;
        w_older = w;
        strick=strick+1;
%     elseif (sq_err_old/length(E)  < sq_err/length(E)+ 0.001 )
%         break;
    else
        strick = 0;
    end
    if ( strick ==2)
        w = w_opt;
        if ( min_sq_err~=sq_err_older)
            s=0;
        end
        sq_err = min_sq_err;
        break;
    end
    if ( min_sq_err > sq_err )
        min_sq_err = sq_err;
        w_opt = w;
    end
end
waitbar(1,h);
close(h);
end