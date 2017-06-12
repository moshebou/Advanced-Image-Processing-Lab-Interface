function simplex(R,curr_line)



while (sum(R(1,:)>0))
    curr_line = curr_line+1;
    [val, pos] =min(R(2:end, end)./R(2:end, curr_line));
%     new_base = R(2:end, [curr_line:curr_line+pos-1,curr_line+pos+1:end-1]);
    R(2+pos-1, :) = R(2+pos-1, :) /R(2+pos-1, curr_line) ;
    for k=1:size(R,1)
        if ( R(k, curr_line) ~=0 && k ~=2+pos-1)
            R(k, :) = R(k, :)  - R(k, curr_line)*R(2+pos-1, :) ;
        end
    end
    
end

%%setting up the initial basis
sB = [3, 4]
R
end