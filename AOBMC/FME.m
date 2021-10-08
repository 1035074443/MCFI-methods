function MVF = FME(im_prev_pad,im_next_pad,im_rows, im_cols, block_size, search_range, step_size)

params.block_size = block_size;
params.search_range = search_range;
params.step_size = step_size;
params.im_rows = im_rows;
params.im_cols = im_cols;

MVF_prev = GeneratePreviousMVF(im_prev_pad,im_next_pad,params);
MVF_prev_row = squeeze(MVF_prev(1,:,:));
MVF_prev_col = squeeze(MVF_prev(2,:,:));
% block_size = params.block_size;
% im_rows = params.im_rows;
% im_cols = params.im_cols;
% search_range = params.search_range;

MVF = zeros(2,im_rows/block_size,im_cols/block_size);
MVF_row = zeros(im_rows/block_size,im_cols/block_size);
MVF_col = MVF_row; 
block_rows = size(MVF_row,1);

[C,R] = meshgrid(1+search_range:block_size:...
    im_cols+search_range,1+search_range:block_size:im_rows+search_range);

interp_position_row = squeeze(MVF_prev(1,:,:)) + R;
interp_position_col = squeeze(MVF_prev(2,:,:)) + C;
all_position = [interp_position_row(:)';interp_position_col(:)'];

for ii = (1+search_range):block_size:(im_rows+search_range)
    for jj = (1+search_range):block_size:(im_cols+search_range)
        block_ii = fix((ii-search_range)/block_size) + 1;
        block_jj = fix((jj-search_range)/block_size) + 1;
        current_position = repmat([ii;jj],1,size(all_position,2));
        dist = sum((current_position - all_position).^2);
        [min_dist,min_index] = min(dist);
        min_ii = rem(min_index-1,block_rows)+1;
        min_jj = fix((min_index-1)/block_rows)+1;
        MVF_row(block_ii,block_jj) = -MVF_prev_row(min_ii,min_jj);
        MVF_col(block_ii,block_jj) = -MVF_prev_col(min_ii,min_jj);
    end
end

MVF(1,:,:) = MVF_row;
MVF(2,:,:) = MVF_col;

end
        