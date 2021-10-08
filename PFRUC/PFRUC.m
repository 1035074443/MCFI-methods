function Y_up = PFRUC(Y,U,V,factor)
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
fas = [2,4,8];
fanu = 0;
%Main
im_rows = size(Y,1);
im_cols = size(Y,2);
for kk = 1:power
    disp(['The ',num2str(kk),'-th double video...']);
    len = size(Y,3);
    inter = fas(power-fanu);
    % U_sub = U(:,:,1:inter:end);
    % V_sub = V(:,:,1:inter:end);
    U_sub = U;
    V_sub = V;
    temp = zeros(im_rows,im_cols,len-1);
    Y_up = zeros(im_rows,im_cols,2*len-1);
    MVF_blk_pre = zeros(im_rows/blk_sz,im_cols/blk_sz,2);
    for tt = 1:len-1
        disp(['The ',num2str(tt),'-th frame...']);
        imR1_Y  = Y(:,:,tt);
        imR2_Y  = Y(:,:,tt+1);
		imR1 = cat(3,Y(:,:,tt),upsamp(U_sub(:,:,tt)),upsamp(V_sub(:,:,tt)));
		imR2 = cat(3,Y(:,:,tt+1),upsamp(U_sub(:,:,tt+1)),upsamp(V_sub(:,:,tt+1)));
		MVF_blk_R1 = MVF_blk_pre;
        MVF_blk_Y =  BMA_Hie(imR2,imR1,blk_sz,enb_sz,sch_rd_top,sch_rd_nt,lev);
        MVF_blk_pre = MVF_blk_Y;
        MVF_blk_R2 = MVF_blk_Y;
		MVF_blk_Y = InterpMVF(imR1,imR2,MVF_blk_R1,MVF_blk_R2,blk_sz,enb_sz);
        temp(:,:,tt) = OBMC_B(imR1_Y,imR2_Y,MVF_blk_Y,-MVF_blk_Y,blk_sz,enb_sz_mc);
    end
    Y_up(:,:,1:2:end) = Y;
    Y_up(:,:,2:2:end) = temp; 
    Y = Y_up;
    fanu = fanu + 1;
end
end

