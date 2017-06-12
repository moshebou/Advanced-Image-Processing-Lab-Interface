function OUTIMG=img_load_mb(file, SzX,SzY)

% the program reads raw data image files

% file is a path to the image

% Call OUTIMG=imgload('Path and image file name', SzX,SzY);



fid=fopen(file);

OUTIMG=fread(fid,[SzX SzY],'uint8')';

fclose(fid);