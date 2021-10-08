function [gen_frame,MVF_blk] = gen_MFM_frame(pre_frame,post_frame, MVF_blk_pre)
%使用MFM方法生成中间帧
%   pre_frame  --前一帧，三通道
%   post_frame --后一帧，三通道

%Parameters
blk_sz = 8;
enb_sz_me = 2;
enb_sz_mc = 4;
%准备
[im_rows,im_cols,channels] = size(pre_frame);
temp = zeros(im_rows,im_cols,channels);
% GetFeature
X = double(rgb2ycbcr(pre_frame));
Y = double(rgb2ycbcr(post_frame));
G1 = getfeature_single_frame(X(:,:,1));
G2 = getfeature_single_frame(Y(:,:,1));

imP = cat(3,pre_frame,G1);
imF = cat(3,post_frame,G2);
MVF_blk = BMA_3DRS(imP,imF,MVF_blk_pre,blk_sz,enb_sz_me);
MVF_blk = SmoothMVF(MVF_blk,imP,imF,blk_sz,enb_sz_me);
MVF_blk_pre = MVF_blk;
temp(:,:,1) = OBMC(double(pre_frame(:,:,1)),double(post_frame(:,:,1)),MVF_blk,-MVF_blk,blk_sz,enb_sz_mc);
temp(:,:,2) = OBMC(double(pre_frame(:,:,2)),double(post_frame(:,:,2)),MVF_blk,-MVF_blk,blk_sz,enb_sz_mc);
temp(:,:,3) = OBMC(double(pre_frame(:,:,3)),double(post_frame(:,:,3)),MVF_blk,-MVF_blk,blk_sz,enb_sz_mc);
    
gen_frame = temp;
end

