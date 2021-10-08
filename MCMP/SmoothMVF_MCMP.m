function MVF_blk_proc = SmoothMVF_MCMP(MVF_blk,imR1,imR2,blk_sz,enb_sz)

blk_rows = size(MVF_blk,1);
blk_cols = size(MVF_blk,2);

ext_sz = enb_sz + max(abs(MVF_blk(:))) + 3*blk_sz;
imR1_pad = cat(3,imextend(imR1(:,:,1),ext_sz),imextend(imR1(:,:,2),ext_sz),...
    imextend(imR1(:,:,3),ext_sz));
imR2_pad = cat(3,imextend(imR2(:,:,1),ext_sz),imextend(imR2(:,:,2),ext_sz),...
    imextend(imR2(:,:,3),ext_sz));
PredPosDis = [-1,-1,-1, 0, 0, 1, 1, 1;
              -1, 0, 1,-1, 1,-1, 0, 1];
error = zeros(blk_rows,blk_cols);
%Check Error
MVm_set = [];
for blk_ii = 1:blk_rows
    for blk_jj = 1:blk_cols
        ii = (blk_ii-1)*blk_sz+1+ext_sz;
        jj = (blk_jj-1)*blk_sz+1+ext_sz;
        MV0 = [MVF_blk(blk_ii,blk_jj,1);MVF_blk(blk_ii,blk_jj,2)];
        p = []; CS = [];
        for kk = 1:size(PredPosDis,2)
            blk_ii_pred = blk_ii + PredPosDis(1,kk);
            blk_jj_pred = blk_jj + PredPosDis(2,kk);
            if (blk_ii_pred>0)&&(blk_ii_pred<=blk_rows)&&(blk_jj_pred>0)&&...
                    (blk_jj_pred<=blk_cols)
                MV = [MVF_blk(blk_ii_pred,blk_jj_pred,1);...
                    MVF_blk(blk_ii_pred,blk_jj_pred,2)];
                CS = [CS,MV];
                iiR1 = ii + MV(1);
                jjR1 = jj + MV(2);
                blkR1 = imR1_pad(iiR1-enb_sz:iiR1+blk_sz+enb_sz-1,...
                    jjR1-enb_sz:jjR1+blk_sz+enb_sz-1,:);
                iiR2 = ii - MV(1);
                jjR2 = jj - MV(2);
                blkR2 = imR2_pad(iiR2-enb_sz:iiR2+blk_sz+enb_sz-1,...
                    jjR2-enb_sz:jjR2+blk_sz+enb_sz-1,:);
                cost = CostFun_MCMP(blkR1,blkR2);
                if cost == 0
                    cost = 1e-6;
                end
                p = [p,1/cost];
            end
        end
        p = p/sum(p);
        MVm = sum(CS.*[p;p],2);
        D0 = sum((MV0-MVm).^2);
        CS_cnt = size(CS,2);
        Dm = mean(sum((repmat(MVm,1,CS_cnt)-CS).^2));
        if D0>Dm
            error(blk_ii,blk_jj) = 1;
            MVm_set = [MVm_set,round(MVm)];
        end
    end
end
%Correct Error
cnt = 0;
for blk_ii = 1:blk_rows
    for blk_jj = 1:blk_cols
        if error(blk_ii,blk_jj)
            cnt = cnt + 1;
            ii = (blk_ii-1)*blk_sz+1+ext_sz;
            jj = (blk_jj-1)*blk_sz+1+ext_sz;
            MVm = MVm_set(:,cnt);
            CS = MVm;
            for kk = 1:size(PredPosDis,2)
                blk_ii_pred = blk_ii + PredPosDis(1,kk);
                blk_jj_pred = blk_jj + PredPosDis(2,kk);
                if (blk_ii_pred>0)&&(blk_ii_pred<=blk_rows)&&(blk_jj_pred>0)&&...
                        (blk_jj_pred<=blk_cols)
                    if ~error(blk_ii_pred,blk_jj_pred)
                        MV = [MVF_blk(blk_ii_pred,blk_jj_pred,1);...
                            MVF_blk(blk_ii_pred,blk_jj_pred,2)];
                        CS = [CS,MV];
                    end
                end
            end
            CS = unique(CS','rows');
            CS = CS';
            if ~isempty(CS)
                CS_cnt = size(CS,2);
                if CS_cnt == 1
                    MVF_blk(blk_ii,blk_jj,1) = CS(1);
                    MVF_blk(blk_ii,blk_jj,2) = CS(2);
                else
                    min_cost = -1;
                    for kk = 1:CS_cnt
                        MV = CS(:,kk);
                        iiR1 = ii + MV(1);
                        jjR1 = jj + MV(2);
                        blkR1 = imR1_pad(iiR1-enb_sz:iiR1+blk_sz+enb_sz-1,...
                            jjR1-enb_sz:jjR1+blk_sz+enb_sz-1,:);
                        iiR2 = ii - MV(1);
                        jjR2 = jj - MV(2);
                        blkR2 = imR2_pad(iiR2-enb_sz:iiR2+blk_sz+enb_sz-1,...
                            jjR2-enb_sz:jjR2+blk_sz+enb_sz-1,:);
                        cost = CostFun_MCMP(blkR1,blkR2);
                        if (min_cost<0)||(cost<min_cost)
                            min_cost = cost;
                            MV_best = MV;
                        end
                    end
                    MVF_blk(blk_ii,blk_jj,1) = MV_best(1);
                    MVF_blk(blk_ii,blk_jj,2) = MV_best(2);
                    error(blk_ii,blk_jj)  = 0;
                end
            end
        end
    end
end
MVF_blk_proc = MVF_blk;
end




