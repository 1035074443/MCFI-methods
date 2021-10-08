function MVF_smooth = median_smoothMVF(MVF,im_rows,im_cols,block_size)

% MVF = num2cell(MVF,1);
MVF_row = padarray(squeeze(MVF(1,:,:)),[1,1],'replicate');
MVF_col = padarray(squeeze(MVF(2,:,:)),[1,1],'replicate');
[block_rows,block_cols] = size(squeeze(MVF(1,:,:)));
MVF_smooth =  zeros(2,im_rows/block_size,im_cols/block_size);
MVF_smooth_row = zeros(size(MVF_row));
MVF_smooth_col = zeros(size(MVF_col));

for ii = 2:block_rows+1
    for jj = 2:block_cols+1
        near_MV_ii = MVF_row(ii-1:ii+1,jj-1:jj+1);
        near_MV_jj = MVF_col(ii-1:ii+1,jj-1:jj+1); 
        MV_set = [near_MV_ii(:),near_MV_jj(:)];
        MV_set = MV_set';
        
        MV_median = VecMedianFilter(MV_set);
        MVF_smooth_row(ii,jj) = MV_median(1);
        MVF_smooth_col(ii,jj) = MV_median(2);
    end
end

MVF_smooth(1,:,:) = MVF_smooth_row( 2:block_rows+1, 2:block_cols+1);
MVF_smooth(2,:,:) = MVF_smooth_col( 2:block_rows+1, 2:block_cols+1);

end
        
        
        
        
        