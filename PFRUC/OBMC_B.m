function imP = OBMC_B(imR1,imR2,MVF_blkf,MVF_blkb,blk_sz,enb_sz)
[im_rows,im_cols] = size(imR1);
ext_sz = max(abs([MVF_blkf(:);MVF_blkb(:)]))+blk_sz+enb_sz;
imP_pad = imextend(zeros(im_rows,im_cols),ext_sz);
num_pad = imP_pad;
imR1_pad = imextend(imR1,ext_sz);
imR2_pad = imextend(imR2,ext_sz);

for ii = 1+ext_sz:blk_sz:im_rows+ext_sz
    for jj = 1+ext_sz:blk_sz:im_cols+ext_sz
        
        blk_ii = (ii-ext_sz-1)/blk_sz + 1;
        blk_jj = (jj-ext_sz-1)/blk_sz + 1;
        
        MV_ii = MVF_blkf(blk_ii,blk_jj,1);
        MV_jj = MVF_blkf(blk_ii,blk_jj,2);
        iiR = ii + MV_ii;
        jjR = jj + MV_jj;
        blkR1 = imR1_pad(iiR-enb_sz:iiR+enb_sz+blk_sz-1,...
            jjR-enb_sz:jjR+enb_sz+blk_sz-1);
        
        MV_ii = MVF_blkb(blk_ii,blk_jj,1);
        MV_jj = MVF_blkb(blk_ii,blk_jj,2);
        iiR = ii + MV_ii;
        jjR = jj + MV_jj;
        blkR2 = imR2_pad(iiR-enb_sz:iiR+enb_sz+blk_sz-1,...
            jjR-enb_sz:jjR+enb_sz+blk_sz-1);
        
        temp = imP_pad(ii-enb_sz:ii+enb_sz+blk_sz-1,...
            jj-enb_sz:jj+enb_sz+blk_sz-1);
        imP_pad(ii-enb_sz:ii+enb_sz+blk_sz-1,...
            jj-enb_sz:jj+enb_sz+blk_sz-1) = temp + (blkR1+blkR2)/2;
        
        temp = num_pad(ii-enb_sz:ii+enb_sz+blk_sz-1,...
            jj-enb_sz:jj+enb_sz+blk_sz-1);
        num_pad(ii-enb_sz:ii+enb_sz+blk_sz-1,...
            jj-enb_sz:jj+enb_sz+blk_sz-1) = temp + 1;
        
    end
end

imP = imP_pad(1+ext_sz:im_rows+ext_sz,1+ext_sz:im_cols+ext_sz);
num = num_pad(1+ext_sz:im_rows+ext_sz,1+ext_sz:im_cols+ext_sz);
imP = imP./num;

end