function Y_up = MCMP_RGB(Y,factor)
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
    disp(['MCMP The ',num2str(kk),'-th double video...']);
    [im_rows,im_cols,channels,len] = size(Y);
    temp = zeros(im_rows,im_cols,channels,len-1);
    Y_up = zeros(im_rows,im_cols,channels,2*len-1);
    FMVF = cell(1,len);
    MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
    for ii = 1:len-1
        disp(['MCMP The ',num2str(ii),'-th frame...']);
        % imR1 = cat(3,Y(:,:,ii),upsamp(U_sub(:,:,ii)),upsamp(V_sub(:,:,ii)));
        % imR2 = cat(3,Y(:,:,ii+1),upsamp(U_sub(:,:,ii+1)),upsamp(V_sub(:,:,ii+1)));
        imR1 = rgb2ycbcr(uint8(Y(:,:,:,ii)));
        imR2 = rgb2ycbcr(uint8(Y(:,:,:,ii+1)));
        MVF_blk_R1 = round(MVF_blk_pre/2);
        MVF_blk_Y = MCPM_BMA_3DRS(imR2,imR1,MVF_blk_pre,blk_sz,enb_sz_me);
        MVF_blk_pre = MVF_blk_Y;
        MVF_blk_R2 = round(MVF_blk_Y/2); 
        MVF_blk_Y = InterMVF(imR1,imR2,MVF_blk_R1,MVF_blk_R2,blk_sz,enb_sz_me);
        MVF_blk_Y = SmoothMVF_MCMP(MVF_blk_Y,imR1,imR2,blk_sz,enb_sz_me);
        FMVF{ii} = MVF_blk_Y;
    end
    %Backward ME
    BMVF = cell(1,len);
    MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
    for ii = len-1:-1:1
        disp(sprintf('The %d-th Frame.',ii));
        % imR1 = cat(3,Y(:,:,ii),upsamp(U_sub(:,:,ii)),upsamp(V_sub(:,:,ii)));
        % imR2 = cat(3,Y(:,:,ii+1),upsamp(U_sub(:,:,ii+1)),upsamp(V_sub(:,:,ii+1)));
        imR1 = rgb2ycbcr(uint8(Y(:,:,:,ii)));
        imR2 = rgb2ycbcr(uint8(Y(:,:,:,ii+1)));
        MVF_blk_R2 = round(MVF_blk_pre/2);
        MVF_blk_Y = MCPM_BMA_3DRS(imR1,imR2,MVF_blk_pre,blk_sz,enb_sz_me);
        MVF_blk_pre = MVF_blk_Y;
        MVF_blk_R1 = round(MVF_blk_Y/2); 
        MVF_blk_Y = InterMVF(imR2,imR1,MVF_blk_R2,MVF_blk_R1,blk_sz,enb_sz_me);
        MVF_blk_Y = SmoothMVF_MCMP(MVF_blk_Y,imR2,imR1,blk_sz,enb_sz_me);
        BMVF{ii} = MVF_blk_Y;
    end
    %MCI
    for tt = 1:len-1
        disp(sprintf('The %d-th Frame.',tt));
        % imR1_Y  = Y(:,:,tt);
        % imR2_Y  = Y(:,:,tt+1);
        MVFf_blk_Y = FMVF{tt};
        MVFb_blk_Y = BMVF{tt};
        temp(:,:,1,tt) = ST_OBMC(Y(:,:,1,tt),Y(:,:,1,tt+1),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc); 
        temp(:,:,2,tt) = ST_OBMC(Y(:,:,2,tt),Y(:,:,2,tt+1),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);
        temp(:,:,3,tt) = ST_OBMC(Y(:,:,3,tt),Y(:,:,3,tt+1),MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);
    end
    Y_up(:,:,:,1:2:end) = Y;
    Y_up(:,:,:,2:2:end) = temp; 
    Y = Y_up;
end
end



