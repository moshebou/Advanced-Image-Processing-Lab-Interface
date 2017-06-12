function DIRSUM=dir_sum_mb(M1,M2)



% Direct sum of matrices M1 and M2

% Call DIRSUM=dir_sum(M1,M2);



[SzX1 SzY1]=size(M1);

[SzX2 SzY2]=size(M2);



DIRSUM=[M1 zeros(SzX1,SzY2);zeros(SzX2,SzY1) M2];