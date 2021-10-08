function gen_frame = gen_MCMP_frame(pre_frame,post_frame)
%使用MCMP方法生成中间帧
%   pre_frame  --前一帧，三通道
%   post_frame --后一帧，三通道

% 参数
blk_sz = 8;
enb_sz_me = 2;
enb_sz_mc = 4;
[im_rows,im_cols,channels] = size(pre_frame);
imR1 = rgb2ycbcr(uint8(pre_frame));
imR2 = rgb2ycbcr(uint8(post_frame));
temp = zeros(im_rows,im_cols,channels);
%前向运动估计
MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
MVF_blk_R1 = round(MVF_blk_pre/2);
MVFf_blk_Y = MCPM_BMA_3DRS(imR2,imR1,MVF_blk_pre,blk_sz,enb_sz_me);
MVF_blk_pre = MVFf_blk_Y;
MVF_blk_R2 = round(MVFf_blk_Y/2); 
MVFf_blk_Y = InterMVF(imR1,imR2,MVF_blk_R1,MVF_blk_R2,blk_sz,enb_sz_me);
MVFf_blk_Y = SmoothMVF_MCMP(MVFf_blk_Y,imR1,imR2,blk_sz,enb_sz_me);
%后向运动估计
MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
MVF_blk_R2 = round(MVF_blk_pre/2);
MVFb_blk_Y = MCPM_BMA_3DRS(imR1,imR2,MVF_blk_pre,blk_sz,enb_sz_me);
MVF_blk_pre = MVFb_blk_Y;
MVF_blk_R1 = round(MVFb_blk_Y/2); 
MVFb_blk_Y = InterMVF(imR2,imR1,MVF_blk_R2,MVF_blk_R1,blk_sz,enb_sz_me);
MVFb_blk_Y = SmoothMVF_MCMP(MVFb_blk_Y,imR2,imR1,blk_sz,enb_sz_me);
%合成帧
temp(:,:,1) = ST_OBMC(double(pre_frame(:,:,1)),double(post_frame(:,:,1)),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc); 
temp(:,:,2) = ST_OBMC(double(pre_frame(:,:,2)),double(post_frame(:,:,2)),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);
temp(:,:,3) = ST_OBMC(double(pre_frame(:,:,3)),double(post_frame(:,:,3)),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);
gen_frame = temp;
end

