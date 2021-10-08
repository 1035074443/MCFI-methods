function MVF_blk = InterMVF(imR1,imR2,MVF_blk_R1,MVF_blk_R2,blk_sz,enb_sz)

blk_rows = size(MVF_blk_R1,1);
blk_cols = size(MVF_blk_R1,2);
MVF_blk = zeros(blk_rows,blk_cols,2);

PredPosDis = [ 0,-1, -1,-1, 0, 1, 2, 2;
              -1, 0, -1, 1, 1, 0,-2, 2];
ext_sz = enb_sz + max(abs([MVF_blk_R1(:);MVF_blk_R2(:)])) + 3*blk_sz;
imR1_pad = cat(3,imextend(imR1(:,:,1),ext_sz),imextend(imR1(:,:,2),ext_sz),...
    imextend(imR1(:,:,3),ext_sz));
imR2_pad = cat(3,imextend(imR2(:,:,1),ext_sz),imextend(imR2(:,:,2),ext_sz),...
    imextend(imR2(:,:,3),ext_sz));

blk_cnt = 0;
for blk_ii = 1:blk_rows
    for blk_jj = 1:blk_cols
        blk_cnt = blk_cnt + 1;
        CS = [0;0];
        ii = (blk_ii-1)*blk_sz + 1 + ext_sz;
        jj = (blk_jj-1)*blk_sz + 1 + ext_sz;
        for kk = 1:size(PredPosDis,2)
            blk_ii_pred = blk_ii + PredPosDis(1,kk);
            blk_jj_pred = blk_jj + PredPosDis(2,kk);
            if (blk_ii_pred>0)&&(blk_ii_pred<=blk_rows)&&(blk_jj_pred>0)&&...
                    (blk_jj_pred<=blk_cols)
                if kk<=4
                    D_pred = [MVF_blk(blk_ii_pred,blk_jj_pred,1);...
                              MVF_blk(blk_ii_pred,blk_jj_pred,2)];
                    CS = [CS,D_pred];
                elseif kk<=6
                    D_pred = [MVF_blk_R2(blk_ii_pred,blk_jj_pred,1);...
                              MVF_blk_R2(blk_ii_pred,blk_jj_pred,2)];
                    CS = [CS,D_pred];
                else
                    D_pred = [MVF_blk_R1(blk_ii_pred,blk_jj_pred,1);...
                              MVF_blk_R1(blk_ii_pred,blk_jj_pred,2)];
                    CS = [CS,D_pred];
                end
            end
        end
        CS_cnt = size(CS,2);
        min_cost = -1;
        for kk = 1:CS_cnt
            D_pred = CS(:,kk);
            iiR1 = ii + D_pred(1);
            jjR1 = jj + D_pred(2);
            blkR1 = imR1_pad(iiR1-enb_sz:iiR1+blk_sz+enb_sz-1,...
                jjR1-enb_sz:jjR1+blk_sz+enb_sz-1,:);
            iiR2 = ii - D_pred(1);
            jjR2 = jj - D_pred(2);
            blkR2 = imR2_pad(iiR2-enb_sz:iiR2+blk_sz+enb_sz-1,...
                jjR2-enb_sz:jjR2+blk_sz+enb_sz-1,:);
            cost = CostFun(blkR1,blkR2);
            if (min_cost<0)||(cost<min_cost)
                min_cost = cost;
                MV_best1 = D_pred(1);
                MV_best2 = D_pred(2);
            end
        end
        MVF_blk(blk_ii,blk_jj,1) = MV_best1;
        MVF_blk(blk_ii,blk_jj,2) = MV_best2;
    end
end


end


