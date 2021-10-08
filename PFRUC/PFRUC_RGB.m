function Y_up = PFRUC_RGB(Y,factor)
power = log2(factor);
if power ~= fix(power)
    error('The second factor must be the power of 2 !');
end
%Parameters
lev = 3;
blk_sz = 8;
enb_sz = 2;
sch_rd_top = 10;
sch_rd_nt = 1;
enb_sz_mc = 0;
fanu = 0;
%Main
for kk = 1:power
    disp(['PFRUC The ',num2str(kk),'-th double video...']);
    [im_rows,im_cols,channels,len] = size(Y);
    temp = zeros(im_rows,im_cols,channels,len-1);
    Y_up = zeros(im_rows,im_cols,channels,2*len-1);
    MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
    for tt = 1:len-1
        disp(['PFRUC The ',num2str(tt),'-th frame...']);
		% imR1 = cat(3,Y(:,:,tt),upsamp(U_sub(:,:,tt)),upsamp(V_sub(:,:,tt)));
		% imR2 = cat(3,Y(:,:,tt+1),upsamp(U_sub(:,:,tt+1)),upsamp(V_sub(:,:,tt+1)));
        imR1 = rgb2ycbcr(uint8(Y(:,:,:,tt)));
        imR2 = rgb2ycbcr(uint8(Y(:,:,:,tt+1)));
        MVF_blk_R1 = MVF_blk_pre;
        MVF_blk_Y =  BMA_Hie(imR2,imR1,blk_sz,enb_sz,sch_rd_top,sch_rd_nt,lev);
        MVF_blk_pre = MVF_blk_Y;
        MVF_blk_R2 = MVF_blk_Y;
		MVF_blk_Y = InterpMVF(imR1,imR2,MVF_blk_R1,MVF_blk_R2,blk_sz,enb_sz);
        temp(:,:,1,tt) = OBMC_B(Y(:,:,1,tt),Y(:,:,1,tt+1),MVF_blk_Y,-MVF_blk_Y,blk_sz,enb_sz_mc);
        temp(:,:,2,tt) = OBMC_B(Y(:,:,2,tt),Y(:,:,2,tt+1),MVF_blk_Y,-MVF_blk_Y,blk_sz,enb_sz_mc);
        temp(:,:,3,tt) = OBMC_B(Y(:,:,3,tt),Y(:,:,3,tt+1),MVF_blk_Y,-MVF_blk_Y,blk_sz,enb_sz_mc);
    end
    Y_up(:,:,:,1:2:end) = Y;
    Y_up(:,:,:,2:2:end) = temp; 
    Y = Y_up;
end
end

