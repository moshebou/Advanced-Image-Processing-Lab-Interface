function plotnorm(INP,A,B,C);
%The programs plots INP in axis normalized by INPmin and INPmax

Sz=max(size(INP));
INPmin=min(INP); INPmax=max(INP);
subplot(A,B,C);plot(INP,'r'); axis([1 Sz INPmin INPmax]);grid