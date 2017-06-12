function [col_blk,block_col,block_row] = mat2clmn_mb(matx,blk_sz);

mat_sz = size(matx);
block_col = mat_sz(2)/blk_sz(2); % number columns of blocks
block_row = mat_sz(1)/blk_sz(1); % number rows    of blocks

mbint_mb(block_col);
mbint_mb(block_row);

col_blk = [];

for i = 1:block_col
   col_ind = ((i-1)*blk_sz(2)+1):(i*blk_sz(2));
   new_col_blk = matx(:,col_ind);
   col_blk = [col_blk;new_col_blk];
   size(col_blk);
end;

