function Y_up = MCMP(Y,U,V,factor)
power = log2(factor);
if power ~= fix(power)
    error('The second factor must be the power of 2 !');
end
%Parameters
fas = [2,4,8];
blk_sz = 8;
enb_sz_me = 2;
enb_sz_mc = 4;
%Main
im_rows = size(Y,1);
im_cols = size(Y,2);
fanu = 0;
for kk = 1:power
    disp(['The ',num2str(kk),'-th double video...']);
    len = size(Y,3);
    inter = fas(power-fanu);
    % U_sub = U(:,:,1:inter:end);
    % V_sub = V(:,:,1:inter:end);
    U_sub = U;
    V_sub = V;
    disp(size(U_sub));
    disp(size(V_sub));
    temp = zeros(im_rows,im_cols,len-1);
    Y_up = zeros(im_rows,im_cols,2*len-1);
    FMVF = cell(1,len);
    MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
    for ii = 1:len-1
        disp(['The ',num2str(ii),'-th frame...']);
        imR1 = cat(3,Y(:,:,ii),upsamp(U_sub(:,:,ii)),upsamp(V_sub(:,:,ii)));
        imR2 = cat(3,Y(:,:,ii+1),upsamp(U_sub(:,:,ii+1)),upsamp(V_sub(:,:,ii+1)));
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
        imR1 = cat(3,Y(:,:,ii),upsamp(U_sub(:,:,ii)),upsamp(V_sub(:,:,ii)));
        imR2 = cat(3,Y(:,:,ii+1),upsamp(U_sub(:,:,ii+1)),upsamp(V_sub(:,:,ii+1)));
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
        imR1_Y  = Y(:,:,tt);
        imR2_Y  = Y(:,:,tt+1);
        MVFf_blk_Y = FMVF{tt};
        MVFb_blk_Y = BMVF{tt};
        temp(:,:,tt) = ST_OBMC(imR1_Y,imR2_Y,MVFf_blk_Y,MVFb_blk_Y,blk_sz,enb_sz_me,enb_sz_mc);        
    end
    Y_up(:,:,1:2:end) = Y;
    Y_up(:,:,2:2:end) = temp; 
    Y = Y_up;
    fanu = fanu + 1;
end
end



