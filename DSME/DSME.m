function Y_up = DSME(Y,factor)
power = log2(factor);
if power ~= fix(power)
    error('The second factor must be the power of 2 !');
end
%
blk_sz = 8;
sch_rd = 4;
enb_sz_me = 0;
enb_sz_mc = 4;
rf_rd  = 2;
im_rows = size(Y,1);
im_cols = size(Y,2);
for kk = 1:power
    disp(['The ',num2str(kk),'-th double video...']);
    len = size(Y,3);
    temp = zeros(im_rows,im_cols,len-1);
    Y_up = zeros(im_rows,im_cols,2*len-1);
    for ii = 1:len-1
        disp(['The ',num2str(ii),'-th frame...']);
        imP = Y(:,:,ii);
        imF = Y(:,:,ii+1);
        %Forward
        MVFf_blk_Y = BMA_FS(imF,imP,blk_sz,enb_sz_me,sch_rd);
        MVFf_blk_Y = SmoothMVF(MVFf_blk_Y);
        MVFf_blk_Y = round(MVFf_blk_Y/2); %Parallel Assumption
        MVFf_blk_Y = BiRefine(MVFf_blk_Y,imP,imF,blk_sz,enb_sz_me,rf_rd);
        %Backward
        MVFb_blk_Y = BMA_FS(imP,imF,blk_sz,enb_sz_me,sch_rd);
        MVFb_blk_Y = SmoothMVF(MVFb_blk_Y);
        MVFb_blk_Y = round(MVFb_blk_Y/2); %Parallel Assumption
        MVFb_blk_Y = BiRefine(MVFb_blk_Y,imF,imP,blk_sz,enb_sz_me,rf_rd);
        
        temp(:,:,ii) = DS_OBMC(imP,imF,MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);
    end
    Y_up(:,:,1:2:end) = Y;
    Y_up(:,:,2:2:end) = temp; 
    Y = Y_up;
end
end
        
        
        