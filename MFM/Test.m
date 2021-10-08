%TestYUV.m
clear;clc;
addpath('.\YUV_RW');
addpath('.\Videos');
addpath('.\MF_FRUC');
addpath('.\Utilities');
%Video Info
filename = 'foreman_cif_300f.yuv';
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
PSNR = [];
SSIM = [];
TIME = [];
%Main
MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
for tt = 2:2:video_len
    disp(sprintf('The %d-th Frame.',tt));
    imC = cat(3,Y(:,:,tt),upsamp(U(:,:,tt)),upsamp(V(:,:,tt)),G(:,:,tt));
    imP = cat(3,Y(:,:,tt-1),upsamp(U(:,:,tt-1)),upsamp(V(:,:,tt-1)),G(:,:,tt-1));
    imF = cat(3,Y(:,:,tt+1),upsamp(U(:,:,tt+1)),upsamp(V(:,:,tt+1)),G(:,:,tt+1));
    tic
    MVF_blk = BMA_3DRS(imP,imF,MVF_blk_pre,blk_sz,enb_sz_me);
    %MVF_blk = SmoothMVF(MVF_blk,imP,imF,blk_sz,enb_sz_me);
    MVF_blk_pre = MVF_blk;
    imE = OBMC(imP(:,:,1),imF(:,:,1),MVF_blk,-MVF_blk,blk_sz,enb_sz_mc);
    time = toc;
    psnr = Psnr(imC(:,:,1),imE);
    Ssim = ssim(imC(:,:,1),imE);
    PSNR = [PSNR,psnr];
    SSIM = [SSIM,Ssim];
    TIME = [TIME,time];
    %Update
    Y(:,:,tt) = imE;
end

PSNR_mean = mean(PSNR);
SSIM_mean = mean(SSIM);
TIME_mean = mean(TIME); 
disp(sprintf('The Mean PSNR = %.2f dB',PSNR_mean));
disp(sprintf('The Mean SSIM = %.4f',SSIM_mean));
disp(sprintf('The Mean Time = %.2f s',TIME_mean));


