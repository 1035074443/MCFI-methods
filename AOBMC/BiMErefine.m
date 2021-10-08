function MVF_Bi = BiMErefine(im_prev_pad,im_next_pad,MVF,refine_range,im_rows, im_cols, block_size, search_range, step_size)


MVF_row = squeeze(MVF(1,:,:));
MVF_col = squeeze(MVF(2,:,:));
params.block_size = block_size;
params.im_rows = im_rows;
params.im_cols = im_cols;
params.search_range = search_range;
params.step_size = step_size;
[block_rows,block_cols] = size(MVF_row);
MVF_Bi = zeros(2,block_rows,block_cols);
MVF_Bi_row = zeros(block_rows,block_cols);
MVF_Bi_col = MVF_Bi_row;

for ii = 1:block_rows
    for jj = 1:block_cols
        MV_ii = MVF_row(ii,jj);
        MV_jj = MVF_col(ii,jj);
        interp_ii = (ii-1)*block_size+1+search_range;
        interp_jj = (jj-1)*block_size+1+search_range;
        prev_ii = interp_ii + MV_ii;
        prev_jj = interp_jj + MV_jj;
        next_ii = interp_ii - MV_ii;
        next_jj = interp_jj - MV_jj;
        min_SAD = -1;
        for mm = (-refine_range):refine_range
            for nn = (-refine_range):refine_range
                candidate_prev_ii = prev_ii + mm;
                candidate_prev_jj = prev_jj + nn;
                candidate_next_ii = next_ii - mm;
                candidate_next_jj = next_jj - nn;
                if (candidate_prev_ii<1)||(candidate_prev_ii>(im_rows+2*search_range-block_size+1))...
                   ||(candidate_next_ii<1)||(candidate_next_ii>(im_rows+2*search_range-block_size+1))...
                   ||(candidate_prev_jj<1)||(candidate_prev_jj>(im_cols+2*search_range-block_size+1))...
                   ||(candidate_next_jj<1)||(candidate_next_jj>(im_cols+2*search_range-block_size+1))
                      continue;
                end
                candidate_prev_block = im_prev_pad(candidate_prev_ii:...
                    candidate_prev_ii+block_size-1,candidate_prev_jj:...
                    candidate_prev_jj+block_size-1);
                candidate_next_block = im_next_pad(candidate_next_ii:...
                    candidate_next_ii+block_size-1,candidate_next_jj:...
                    candidate_next_jj+block_size-1);
                SAD = sum(abs(candidate_prev_block(:)-candidate_next_block(:)));
                if (SAD<min_SAD)||(min_SAD<0)
                    min_SAD = SAD;
                    min_mm = mm;
                    min_nn = nn;
                end
            end
        end
        MVF_Bi_row(ii,jj) = MV_ii + min_mm;
        MVF_Bi_col(ii,jj) = MV_jj + min_nn;
    end
end
  
MVF_Bi(1,:,:) = MVF_Bi_row;
MVF_Bi(2,:,:) = MVF_Bi_col;

end            
                
                
       
        
        
        
      
        
        
        
        
        

