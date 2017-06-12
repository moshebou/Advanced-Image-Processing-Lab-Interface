function [OUTIMG, LUTable ]= LloydQunt_mb( INPIMA,Q  )
% LLoydMax quantization of INPIMA to Q quantization  levels in the range
% Copyright Moshe Bouhnik and L. Yaroslavsky (www.eng.tau.ac.il/~yaro)
% Usage [OUTIMG, LUTable]= LloydMaxQuant(INPIMG,Q);

INPIMA = double(INPIMA);
%im = (INPIMA - min(INPIMA(:)))/(max(INPIMA(:)) - min(INPIMA(:)));
im = INPIMA;
im_unique = unique(INPIMA(:)');
x = im_unique;
y = cumsum([0 1/Q*ones(1,Q-1)]);
y_interp = interp1(linspace(min(y(:)), max(y(:)), length(y)), y, linspace(0,1, length(x)), 'nearest','extrap');
curr_y = inf;
k=0;

for i=1:length(x)
    p_x(i) = sum(im(:) == x(i))/length(im(:));
    if ( y_interp(i) == curr_y)
        y_x_indexs{k} = [y_x_indexs{k}, i];
    else
        if ( k > 0 ) 
            rms_per_y(k) = sum(((curr_y - x(y_x_indexs{k})).^2).*p_x(y_x_indexs{k}));
        end
        k=k+1;
        y_x_indexs{k} = i;
        curr_y = y_interp(i);
        
    end
end

rms_per_y(k) = sum(((curr_y - x(y_x_indexs{k})).^2).*p_x(y_x_indexs{k}));
rms = sum(p_x.*((x-y_interp).^2));
rms_new = 0;

while (rms ~= rms_new )
    rms = rms_new;
  % redistribute the x to the y groups
  for i=1:length(y_x_indexs)-1

      while (((y(i) - x(y_x_indexs{i}(end)))^2) > ((y(i+1) - x(y_x_indexs{i}(end)))^2))
          if ( ~isempty(y_x_indexs{i}(1:end-1)))
              y_x_indexs{i+1} = [y_x_indexs{i}(end), y_x_indexs{i+1}]; 
              y_x_indexs{i} = y_x_indexs{i}(1:end-1);
          else
              y(i)= x(y_x_indexs{i}(end));
          end
      end
      while (((y(i) - x(y_x_indexs{i+1}(1)))^2) <((y(i+1) - x(y_x_indexs{i+1}(1)))^2))
          if ( ~isempty(y_x_indexs{i+1}(2:end)))          
              y_x_indexs{i} = [y_x_indexs{i}, y_x_indexs{i+1}(1)];
              y_x_indexs{i+1} = y_x_indexs{i+1}(2:end); 
          else
              y(i+1)= x(y_x_indexs{i+1}(1));
          end
      end

  end
  % recalculate y for minimal rms
  for i=1:length(y_x_indexs)
          y(i) = sum(x(y_x_indexs{i}).*p_x(y_x_indexs{i}))/sum(p_x(y_x_indexs{i}));
          rms_per_y(i) = sum(((y(i) - x(y_x_indexs{i})).^2).*p_x(y_x_indexs{i}));
  end
  rms_new = sum(rms_per_y);
end
for i=1:length(y_x_indexs)
    im(logical( (im >= x(y_x_indexs{i}(1))).* (im <=x(y_x_indexs{i}(end)))))= y(i);
    
end

im_unique = (im_unique  - min(INPIMA(:)))/(max(INPIMA(:)) - min(INPIMA(:)));
unique_quant = zeros(size(im_unique));
for i=1:length(im_unique)
    k=1;
     while((k<length(y_x_indexs) )&& (im_unique(i)>x(y_x_indexs{k}(end))))
         k=k+1;
     end
     unique_quant(i) = y(k);
end


%OUTIMG = im .*(max(INPIMA(:)) - min(INPIMA(:))) +  min(INPIMA(:));
OUTIMG = im;
%unique_quant = unique_quant.*(max(INPIMA(:)) - min(INPIMA(:))) +  min(INPIMA(:));
LUTable = unique_quant;
