function Y_up = EBME_fruc(Y,factor)
power = log2(factor);
if power ~= fix(power)
    error('The second factor must be the power of 2 !');
end
%Parameters
blk_sz = 8;
sch_rd = 4;
enb_sz_mc = 4;
%Main
for kk = 1:power
    disp(['The ',num2str(kk),'-th double video...']);
    [im_rows,im_cols,len] = size(Y);
    temp = zeros(im_rows,im_cols,len-1);
    Y_up = zeros(im_rows,im_cols,2*len-1);
    for ii = 1:len-1
        disp(['The ',num2str(ii),'-th frame...']);
        imR1_Y  = Y(:,:,ii);
        imR2_Y  = Y(:,:,ii+1);
        MVF_blk_Y = EBME(imR1_Y,imR2_Y,blk_sz,sch_rd);
        MVF_blk_Y = SmoothMVF_EBME(MVF_blk_Y);
        temp(:,:,ii) = SoOBMC(imR1_Y,imR2_Y,MVF_blk_Y,-MVF_blk_Y,blk_sz,enb_sz_mc);
    end
    Y_up(:,:,1:2:end) = Y;
    Y_up(:,:,2:2:end) = temp; 
    Y = Y_up;
end
end




