function gen_frame = gen_AOBMC_frame(pre_frame,post_frame)
%使用AOBMC方法生成中间帧
%   pre_frame  --前一帧，三通道
%   post_frame --后一帧，三通道

block_size = 8;
search_range = 4;
step_size = 1;
% 参数
pre_frame = double(pre_frame);
post_frame = double(post_frame);
[im_rows,im_cols,channels] = size(pre_frame);
temp = zeros(im_rows,im_cols,channels);
% 运动估计
imR1_Y  = pre_frame;
imR2_Y  = post_frame;
imR1_pad = padarray(imR1_Y,search_range*[1,1],'replicate');
imR2_pad = padarray(imR2_Y,search_range*[1,1],'replicate');
MVF = FME(imR1_pad,imR2_pad,im_rows,im_cols,block_size,search_range,step_size);
MVF = BiMErefine(imR1_pad,imR2_pad,MVF,2,im_rows,im_cols,block_size,search_range,step_size);
MVF = median_smoothMVF(MVF,im_rows,im_cols,block_size);
% 运动补偿
imR1_pad1 = padarray(pre_frame(:,:,1),search_range*[1,1],'replicate');
imR2_pad1 = padarray(post_frame(:,:,1),search_range*[1,1],'replicate');
imR1_pad2 = padarray(pre_frame(:,:,2),search_range*[1,1],'replicate');
imR2_pad2 = padarray(post_frame(:,:,2),search_range*[1,1],'replicate');
imR1_pad3 = padarray(pre_frame(:,:,3),search_range*[1,1],'replicate');
imR2_pad3 = padarray(post_frame(:,:,3),search_range*[1,1],'replicate');
temp(:,:,1) = AOBMC(imR1_pad1,imR2_pad1,MVF,im_rows,im_cols,block_size,search_range,step_size);
temp(:,:,2) = AOBMC(imR1_pad2,imR2_pad2,MVF,im_rows,im_cols,block_size,search_range,step_size);
temp(:,:,3) = AOBMC(imR1_pad3,imR2_pad3,MVF,im_rows,im_cols,block_size,search_range,step_size);
gen_frame = temp;
end

