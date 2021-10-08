function imP = ST_OBMC(imR1,imR2,MVF_blkf,MVF_blkb,blk_sz,enb_sz_me,enb_sz_mc)

[im_rows,im_cols] = size(imR1);
blk_rows = im_rows/blk_sz;
blk_cols = im_cols/blk_sz;
ext_sz = enb_sz_mc + enb_sz_me + max(abs([MVF_blkf(:);MVF_blkb(:)])) + 3*blk_sz;
imR1_pad = imextend(imR1,ext_sz);
imR2_pad = imextend(imR2,ext_sz);
imP_pad = imextend(zeros(im_rows,im_cols),ext_sz);
num_pad = imP_pad;
PredPosDis = [-1,-1,-1, 0, 0, 1, 1, 1;
              -1, 0, 1,-1, 1,-1, 0, 1];
sty = 1:8;

for ii = 1+ext_sz:blk_sz:im_rows+ext_sz
    for jj = 1+ext_sz:blk_sz:im_cols+ext_sz

        blk_ii = fix((ii-ext_sz-1)/blk_sz) + 1;
        blk_jj = fix((jj-ext_sz-1)/blk_sz) + 1;

        %Forward
        MVf = [MVF_blkf(blk_ii,blk_jj,1);MVF_blkf(blk_ii,blk_jj,2)];
        iiR1 = ii + MVf(1);
        jjR1 = jj + MVf(2);
        iiR2 = ii - MVf(1);
        jjR2 = jj - MVf(2);
        %Compute SBAD
        blkR1 = imR1_pad(iiR1-enb_sz_me:iiR1+blk_sz+enb_sz_me-1,...
            jjR1-enb_sz_me:jjR1+blk_sz+enb_sz_me-1);
        blkR2 = imR2_pad(iiR2-enb_sz_me:iiR2+blk_sz+enb_sz_me-1,...
            jjR2-enb_sz_me:jjR2+blk_sz+enb_sz_me-1);
        costf = sum(abs(blkR1(:)-blkR2(:)));
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
              iiR2 = ii_pred - MV(1);
              jjR2 = jj_pred - MV(2);
              blk_temp = imR2_pad(iiR2:iiR2+blk_sz-1,...
                  jjR2:jjR2+blk_sz-1);
              blkR2_set = [blkR2_set,blk_temp(:)];
              blk_sty = [blk_sty,sty_temp];
            end
        end
        alphaR1 = SOAD(blkR1,blkR1_set,blk_sty,blk_sz,enb_sz_mc);
        alphaR2 = SOAD(blkR2,blkR2_set,blk_sty,blk_sz,enb_sz_mc);
        if (alphaR1+alphaR2)==0
            blkf = (blkR1+blkR2)/2;
        else
            blkf = (alphaR2*blkR1+alphaR1*blkR2)/(alphaR1+alphaR2);
        end

        %Backward
        MVb = [MVF_blkb(blk_ii,blk_jj,1);MVF_blkb(blk_ii,blk_jj,2)];
        iiR1 = ii - MVb(1);
        jjR1 = jj - MVb(2);
        iiR2 = ii + MVb(1);
        jjR2 = jj + MVb(2);
        %Compute BSAD
        blkR1 = imR1_pad(iiR1-enb_sz_me:iiR1+blk_sz+enb_sz_me-1,...
            jjR1-enb_sz_me:jjR1+blk_sz+enb_sz_me-1);
        blkR2 = imR2_pad(iiR2-enb_sz_me:iiR2+blk_sz+enb_sz_me-1,...
            jjR2-enb_sz_me:jjR2+blk_sz+enb_sz_me-1);
        costb = sum(abs(blkR1(:)-blkR2(:)));
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
                MV = [MVF_blkb(blk_ii_pred,blk_jj_pred,1);...
                    MVF_blkb(blk_ii_pred,blk_jj_pred,2)];
                iiR1 = ii_pred - MV(1);
                jjR1 = jj_pred - MV(2);
                blk_temp = imR1_pad(iiR1:iiR1+blk_sz-1,...
                    jjR1:jjR1+blk_sz-1);
                blkR1_set = [blkR1_set,blk_temp(:)];
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
        if (alphaR1+alphaR2)==0
            blkb = (blkR1+blkR2)/2;
        else
            blkb = (alphaR2*blkR1+alphaR1*blkR2)/(alphaR1+alphaR2);
        end
        
        if (costf+costb)==0
            blkP = (blkf+blkb)/2;
        else
            blkP = (costb*blkf+costf*blkb)/(costf+costb);
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

        
        