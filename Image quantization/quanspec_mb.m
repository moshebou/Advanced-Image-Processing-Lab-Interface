function OUTSP=quanspec_mb(INPSP,Q,P)
% (P)th law quantization on 2Q+1 levels and (1/P)th law reconstruction
% of orthogonal components of DFT spectrum of an image
% Call OUTSP=quanspec(INPSPECTR,Number of quantization levels,Power)

r=real(INPSP); im=imag(INPSP);
absr=abs(r); absim=abs(im);
mxr=max(max(absr)); mxim=max(max(absim));

rq=mxr*sign(r).*((round((Q-1)*(absr/mxr).^P))/(Q-1)).^(1/P);
imq=mxim*sign(im).*((round((Q-1)*(absim/mxim).^P))/(Q-1)).^(1/P);
OUTSP=rq+i*imq;


% r=real(INPSP); im=imag(INPSP);
% %absr=abs(r); absim=abs(im);
% %mxr=max(max(absr)); mxim=max(max(absim));
% %rq=mxr*sign(r).*((round((Q-1)*(absr/mxr).^P))/(Q-1)).^(1/P);
% %rq  = nlquantz_mb(r_tmp,Q,P);
% rq = qunatize_unique( r,Q,P);
% %imq=mxim*sign(im).*((round((Q-1)*(absim/mxim).^P))/(Q-1)).^(1/P);
% %imq = nlquantz_mb(im,Q,P);
% imq = qunatize_unique(im,Q,P);
% OUTSP=rq+1i*imq;
% end
% 
% function rq = qunatize_unique(r, Q, P)
% %     r_unique = unique(r(:));
% %     r_tmp = zeros(size(r));
% %     for i =1 :length(r_unique)
% %         r_tmp(r== r_unique(i) ) = i;
% %     end
%     r_t = unique(mod(r(:),1));
%     r_t = r_t(r_t~=0);
%     
%     r_int = r/max(eps, prod(r_t));
%     rq  = nlquantz_mb(r_int,Q,P, r_t); % rq == r_tmp
%     rq = rq*max(eps, prod(r_t));
%     %rq = r_unique(round(rq)); % r == rq
% end



