function HomogenIm = ImageHomogenization_mb( inImage , SzW )

lcmean=imfilter(inImage,ones(SzW,SzW)/(SzW*SzW),'same');
lcvar= imfilter(inImage.^2,ones(SzW,SzW)/(SzW*SzW),'same')-lcmean.^2;
lcstd=lcvar.^0.5;

HomogenIm = (inImage-lcmean)./lcstd;