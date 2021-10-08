%TestYUV.m
clear;clc;
%Video Info
filename = 'D:\video_interpolation\video_dataset\YUV\CIF\akiyo_cif.yuv';
format = 'cif';
init2last = [0,100];
file_cnt = length(filename);
%Parameters
blk_sz = 8;
enb_sz_me = 2;
enb_sz_mc = 4;
%Read YUV
[Y,U,V] = ReadMultiFrames(filename,format,init2last);
G = GetFeature(Y);
[im_rows,im_cols,video_len] = size(Y);

%Main
temp = zeros(im_rows,im_cols,video_len-1);
Y_up = zeros(im_rows,im_cols,2*video_len-1);
MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
for tt = 1:1:video_len-1
    disp(sprintf('The %d-th Frame.',tt));
    % imC = cat(3,Y(:,:,tt),upsamp(U(:,:,tt)),upsamp(V(:,:,tt)),G(:,:,tt));
    imP = cat(3,Y(:,:,tt),upsamp(U(:,:,tt)),upsamp(V(:,:,tt)),G(:,:,tt));
    imF = cat(3,Y(:,:,tt+1),upsamp(U(:,:,tt+1)),upsamp(V(:,:,tt+1)),G(:,:,tt+1));
    MVF_blk = BMA_3DRS(imP,imF,MVF_blk_pre,blk_sz,enb_sz_me);
    MVF_blk = SmoothMVF(MVF_blk,imP,imF,blk_sz,enb_sz_me);
    MVF_blk_pre = MVF_blk;
    imE = OBMC(imP(:,:,1),imF(:,:,1),MVF_blk,-MVF_blk,blk_sz,enb_sz_mc);
    temp(:,:,tt) = imE;
end

Y_up(:,:,1:2:end) = Y;
Y_up(:,:,2:2:end) = temp; 
Y = Y_up;

Y_up_2 = zeros(288,352,1,201);
Y_up_2(:,:,1,:) = Y_up;
Y_up_2 = uint8(Y_up_2);
disp(size(Y_up_2));

video_out_name = 'E:\frame_interpolation_matlab\videos\football_cif_MFM.avi';
video_out = VideoWriter(video_out_name,'Uncompressed AVI');
video_out.FrameRate = 30;
open(video_out);
writeVideo(video_out,Y_up_2);

close(video_out)