function output_image= load_image_mb( image )
%LOAD_IMAGE_MB Summary of this function goes here
%   Detailed explanation goes here
    [pathstr, name, ext] = fileparts(image.filename);
    ext = ext(2:end);
    if ( isempty(imformats(ext)))
        if ( strcmpi(ext, 'img') || strcmpi(ext, 'raw'))
            output_im = img_load_mb(image.filename, image.width, image.height );
        else
            error('file format not supported');
        end
    else
        output_im = imread(image.filename);

    end
    if( size(output_im,3) == 3 ) 
        output_im = rgb2gray(  output_im);
    end
    [h w] = size(output_im);
    output_im = imcrop(output_im, [floor((w-min(h,w))/2) floor((h-min(h,w))/2)  min(h,w) min(h,w)]);
    output_im = imresize(output_im, [2^round(log2(min(h,w))) 2^round(log2(min(h,w)))]);
    if ( 0~=sum(abs(size(output_im) - [256,256])))
        output_image.im = double(uint8(imresize(output_im, [256, 256])));
    else
        output_image.im =double(uint8(output_im ));
    end


%     output_image.sliding = im2col(img_ext_mb( output_image.im, 12, 12), [25,25], 'sliding');

%     if ( sum(sum(abs(double(E) - double(output_image.sliding)))))
%         display('error in sliding window');
%     end
%     output_image.distinct = im2col(output_image.im, [25,25], 'distinct');



end

