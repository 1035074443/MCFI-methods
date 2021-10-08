function gen_frame = gen_DSME_frame(pre_frame,post_frame)
%使用DSME方法生成中间帧
%   pre_frame  --前一帧，三通道
%   post_frame --后一帧，三通道

blk_sz = 8;
sch_rd = 4;
enb_sz_me = 0;
enb_sz_mc = 4;
rf_rd  = 2;
% 参数
pre_frame = double(pre_frame);
post_frame = double(post_frame);
[im_rows,im_cols,channels] = size(pre_frame);
temp = zeros(im_rows,im_cols,channels);
imF = pre_frame;
imP = post_frame;
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
%hecheng
temp(:,:,1) = DS_OBMC(pre_frame(:,:,1),post_frame(:,:,1),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);
temp(:,:,2) = DS_OBMC(pre_frame(:,:,2),post_frame(:,:,2),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);
temp(:,:,3) = DS_OBMC(pre_frame(:,:,3),post_frame(:,:,3),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);
gen_frame = temp;
end

