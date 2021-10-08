function imP = SoOBMC(imR1,imR2,MVF_blkf,MVF_blkb,blk_sz,enb_sz_mc)

[im_rows,im_cols] = size(imR1);
blk_rows = im_rows/blk_sz;
blk_cols = im_cols/blk_sz;
ext_sz = enb_sz_mc + max(abs([MVF_blkf(:);MVF_blkb(:)])) + 3*blk_sz;
% 扩展边界大小
imR1_pad = imextend(imR1,ext_sz);
imR2_pad = imextend(imR2,ext_sz);
imP_pad = imextend(zeros(im_rows,im_cols),ext_sz);
num_pad = imP_pad;
PredPosDis = [-1,-1,-1, 0, 0, 1, 1, 1;
              -1, 0, 1,-1, 1,-1, 0, 1];
sty = 1:8;
error = zeros(blk_rows,blk_cols,2);

for ii = 1+ext_sz:blk_sz:im_rows+ext_sz
    for jj = 1+ext_sz:blk_sz:im_cols+ext_sz

        blk_ii = (ii-ext_sz-1)/blk_sz + 1;
        blk_jj = (jj-ext_sz-1)/blk_sz + 1;

        MVf = [MVF_blkf(blk_ii,blk_jj,1);MVF_blkf(blk_ii,blk_jj,2)];
        MVb = [MVF_blkb(blk_ii,blk_jj,1);MVF_blkb(blk_ii,blk_jj,2)];
        iiR1 = ii + MVf(1);
        jjR1 = jj + MVf(2);
        iiR2 = ii + MVb(1);
        jjR2 = jj + MVb(2);
        %Compute SOAD 
        blkR1 = imR1_pad(iiR1-enb_sz_mc:iiR1+blk_sz+enb_sz_mc-1,...
            jjR1-enb_sz_mc:jjR1+blk_sz+enb_sz_mc-1);
        blkR2 = imR2_pad(iiR2-enb_sz_mc:iiR2+blk_sz+enb_sz_mc-1,...
            jjR2-enb_sz_mc:jjR2+blk_sz+enb_sz_mc-1);
        blkR1_set = []; blkR2_set = []; blk_sty = [];
        for kk = 1:8
            blk_ii_pred = blk_ii + PredPosDis(1,kk);
            blk_jj_pred = blk_jj + PredPosDis(2,kk);
            sty_temp = sty(kk);
            if (blk_ii_pred>0)&&(blk_ii_pred<=blk_rows)&&(blk_jj_pred>0)&&...
                    (blk_jj_pred<=blk_cols)
              ii_pred = (blk_ii_pred-1)*blk_sz + 1 + ext_sz;
              jj_pred = (blk_jj_pred-1)*blk_sz + 1 + ext_sz; 
              MV = [MVF_blkf(blk_ii_pred,blk_jj_pred,1);...
                  MVF_blkf(blk_ii_pred,blk_jj_pred,2)];
              iiR1 = ii_pred + MV(1);
              jjR1 = jj_pred + MV(2);
              blk_temp = imR1_pad(iiR1:iiR1+blk_sz-1,...
                  jjR1:jjR1+blk_sz-1);
              blkR1_set = [blkR1_set,blk_temp(:)];
              MV = [MVF_blkb(blk_ii_pred,blk_jj_pred,1);...
                  MVF_blkb(blk_ii_pred,blk_jj_pred,2)];
              iiR2 = ii_pred + MV(1);
              jjR2 = jj_pred + MV(2);
              blk_temp = imR2_pad(iiR2:iiR2+blk_sz-1,...
                  jjR2:jjR2+blk_sz-1);
              blkR2_set = [blkR2_set,blk_temp(:)];
              blk_sty = [blk_sty,sty_temp];
            end
        end
        alphaR1 = SOAD(blkR1,blkR1_set,blk_sty,blk_sz,enb_sz_mc);
        alphaR2 = SOAD(blkR2,blkR2_set,blk_sty,blk_sz,enb_sz_mc); 
        error(blk_ii,blk_jj,1) = alphaR1;
        error(blk_ii,blk_jj,2) = alphaR2;
        if (alphaR1+alphaR2)==0
            blkP = (blkR1+blkR2)/2;
        else
            blkP = (alphaR2*blkR1+alphaR1*blkR2)/(alphaR1+alphaR2);
        end
        

        temp = imP_pad(ii-enb_sz_mc:ii+enb_sz_mc+blk_sz-1,...
            jj-enb_sz_mc:jj+enb_sz_mc+blk_sz-1);
        imP_pad(ii-enb_sz_mc:ii+enb_sz_mc+blk_sz-1,...
            jj-enb_sz_mc:jj+enb_sz_mc+blk_sz-1) = temp + blkP;
        temp = num_pad(ii-enb_sz_mc:ii+enb_sz_mc+blk_sz-1,...
            jj-enb_sz_mc:jj+enb_sz_mc+blk_sz-1);
        num_pad(ii-enb_sz_mc:ii+enb_sz_mc+blk_sz-1,...
            jj-enb_sz_mc:jj+enb_sz_mc+blk_sz-1) = temp + 1;

    end
end
imP = imP_pad(1+ext_sz:im_rows+ext_sz,1+ext_sz:im_cols+ext_sz);
num = num_pad(1+ext_sz:im_rows+ext_sz,1+ext_sz:im_cols+ext_sz);
imP = imP./num;
end

        
        