function [mn,v]=std2d(INP);
% Standard deviation and mean of a 2-D array
% z=[mean variance];
% Call z=std2d(INP)

[SzX SzY]=size(INP);
mn=sum(sum(INP))/(SzX*SzY);
v=sqrt(sum(sum((INP-mn).^2))/(SzX*SzY));
