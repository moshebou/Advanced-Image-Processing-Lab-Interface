function OUT=monotone_mb(curve,thr)



% Curve smoothing by monotone approximation

% Applicable to 1-D spectra smoothing

% Call OUT=monotone(curve,thr);



SzX=max(size(curve));

OUT=curve;

for x=1:SzX-1;

	if 	OUT(x+1)>(1+thr)*OUT(x), 

		OUT(x+1)=OUT(x);

	end

end