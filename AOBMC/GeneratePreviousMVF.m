function MVF_prev = GeneratePreviousMVF(im_prev_pad,im_next_pad,params)

block_size = params.block_size;
search_range = params.search_range;
step_size = params.step_size;
im_rows = params.im_rows;
im_cols = params.im_cols;

% MVF_prev = cell(2,1);
MVF_prev = zeros(2,im_rows/block_size,im_cols/block_size);
MVF_row = zeros(im_rows/block_size,im_cols/block_size);
MVF_col = MVF_row;


for ii = (1+search_range):block_size:(im_rows+search_range)
    for jj = (1+search_range):block_size:(im_cols+search_range)
        block_ii = fix((ii-search_range)/block_size) + 1;
        block_jj = fix((jj-search_range)/block_size) + 1;
        current_block = im_prev_pad(ii:ii+block_size-1,jj:jj+block_size-1);
        
        row_start = ii - search_range;
        row_last = ii + search_range;
        col_start = jj - search_range;
        col_last = jj + search_range;
        
        %Find position of the best block             
        min_SAD = -1;
        for mm = row_start:step_size:row_last
            for nn = col_start:step_size:col_last
                candidate_block = im_next_pad(mm:mm+block_size-1,nn:nn+block_size-1);
                SAD = sum(abs(current_block(:)-candidate_block(:)));
                if (SAD<min_SAD)||(min_SAD<0)
                    min_SAD = SAD;
                    best_ii = mm;
                    best_jj = nn;
                end
            end
        end

        MVF_row(block_ii,block_jj) = best_ii - ii;
        MVF_col(block_ii,block_jj) = best_jj - jj;
        
    end
end

MVF_row = round(MVF_row/2);
MVF_col = round(MVF_col/2);

MVF_prev(1,:,:) = MVF_row;
MVF_prev(2,:,:) = MVF_col;

end

       
                      
        
    
        
        
        
        
        
        

    
                
                
            
            
        