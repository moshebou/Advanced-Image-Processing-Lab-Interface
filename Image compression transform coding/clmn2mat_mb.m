function matx = clmn2mat_mb(col_blk,block_col,block_row,blk_sz)

matx = [];

for i = 1:block_col
   row_ind = ((i-1)*blk_sz(1)*block_row+1):(i*blk_sz(1)*block_row);
   new_col_block = col_blk(row_ind,:);
   matx = [matx new_col_block];
   size(matx);
end;

