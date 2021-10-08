function gen_frame = gen_EBME_frame(pre_frame,post_frame)
%使用EBME方法生成中间帧
%   pre_frame  --前一帧，三通道
%   post_frame --后一帧，三通道

blk_sz = 8;
sch_rd = 4;
enb_sz_mc = 4;
% 参数
pre_frame = double(pre_frame);
post_frame = double(post_frame);
[im_rows,im_cols,channels] = size(pre_frame);
temp = zeros(im_rows,im_cols,channels);
imR1_Y = pre_frame(:,:,1);
imR2_Y = post_frame(:,:,1);
MVF_blk_Y = EBME(imR1_Y,imR2_Y,blk_sz,sch_rd);
MVF_blk_Y = SmoothMVF_EBME(MVF_blk_Y);
temp(:,:,1) = SoOBMC(pre_frame(:,:,1),pre_frame(:,:,1),MVF_blk_Y,-MVF_blk_Y,blk_sz,enb_sz_mc);
temp(:,:,2) = SoOBMC(pre_frame(:,:,2),pre_frame(:,:,2),MVF_blk_Y,-MVF_blk_Y,blk_sz,enb_sz_mc);
temp(:,:,3) = SoOBMC(pre_frame(:,:,3),pre_frame(:,:,3),MVF_blk_Y,-MVF_blk_Y,blk_sz,enb_sz_mc);
gen_frame = temp;
end

