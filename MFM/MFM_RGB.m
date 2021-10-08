function Y_up = MFM_RGB(Y,factor)
%MFM_RGB 使用MFM方法针对三通道彩色视频上转帧率
power = log2(factor);
if power ~= fix(power)
    error('The second factor must be the power of 2 !');
end

%Parameters
blk_sz = 8;
enb_sz_me = 2;
enb_sz_mc = 4;

%Main

for kk = 1:power
    disp(['MFM The ',num2str(kk),'-th double video...']);
    [im_rows,im_cols,channels,len] = size(Y);
    temp = zeros(im_rows,im_cols,channels,len-1);
    Y_up = zeros(im_rows,im_cols,channels,2*len-1);
    MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
    % MVF_blk_pre1 = zeros(im_rows/blk_sz,im_cols/blk_sz,2,len-1);
    % GetFeature
    Y_fenliang = zeros(im_rows,im_cols,len);
    for tt = 1:len
        YUV = rgb2ycbcr(Y(:,:,:,tt));
        Y_fenliang(:,:,tt) = YUV(:,:,1);
    end
    G = GetFeature(Y_fenliang);
    for tt = 1:1:len-1
        disp(sprintf(' MFM The %d-th Frame.',tt));
        % imC = cat(3,Y(:,:,tt),upsamp(U(:,:,tt)),upsamp(V(:,:,tt)),G(:,:,tt));
        % imP = cat(3,Y(:,:,tt),upsamp(U(:,:,tt)),upsamp(V(:,:,tt)),G(:,:,tt));
        % imF = cat(3,Y(:,:,tt+1),upsamp(U(:,:,tt+1)),upsamp(V(:,:,tt+1)),G(:,:,tt+1));
        imP = cat(3,Y(:,:,:,tt),G(:,:,tt));
        imF = cat(3,Y(:,:,:,tt+1),G(:,:,tt+1));
        MVF_blk = BMA_3DRS(imP,imF,MVF_blk_pre,blk_sz,enb_sz_me);
        MVF_blk = SmoothMVF(MVF_blk,imP,imF,blk_sz,enb_sz_me);
        MVF_blk_pre = MVF_blk;
        % MVF_blk_pre1(:,:,:,tt) = MVF_blk_pre;
        temp(:,:,1,tt) = OBMC(Y(:,:,1,tt),Y(:,:,1,tt+1),MVF_blk,-MVF_blk,blk_sz,enb_sz_mc);
        temp(:,:,2,tt) = OBMC(Y(:,:,2,tt),Y(:,:,2,tt+1),MVF_blk,-MVF_blk,blk_sz,enb_sz_mc);
        temp(:,:,3,tt) = OBMC(Y(:,:,3,tt),Y(:,:,3,tt+1),MVF_blk,-MVF_blk,blk_sz,enb_sz_mc);
    end
    Y_up(:,:,:,1:2:end) = Y;
    Y_up(:,:,:,2:2:end) = temp; 
    Y = Y_up;
    % save("D:\video_interpolation\video_dataset\AVI_FPS\CIF\highway_cif11.mat",'MVF_blk_pre1');
end
end

