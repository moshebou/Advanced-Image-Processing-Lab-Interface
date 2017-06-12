function decoded_matrices = de_zigzag_mb (strings)

sz = size(strings);
decoded_matrices = [];

for i = 1:sz(1)
   mtrx = de_zigzag_block_mb(strings(i,:));
   decoded_matrices = [decoded_matrices
      					mtrx];
end;


