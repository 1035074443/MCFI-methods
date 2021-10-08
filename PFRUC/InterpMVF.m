function MVF_blk = InterpMVF(imR1,imR2,MVF_blk_R1,MVF_blk_R2,blk_sz,enb_sz)

blk_rows = size(MVF_blk_R1,1);
blk_cols = size(MVF_blk_R1,2);
MVF_blk = zeros(blk_rows,blk_cols,2);

ext_sz = enb_sz + max(abs([MVF_blk_R1(:);MVF_blk_R2(:)])) + 3*blk_sz;
imR1_pad = cat(3,imextend(imR1(:,:,1),ext_sz),imextend(imR1(:,:,2),ext_sz),...
    imextend(imR1(:,:,3),ext_sz));
imR2_pad = cat(3,imextend(imR2(:,:,1),ext_sz),imextend(imR2(:,:,2),ext_sz),...
    imextend(imR2(:,:,3),ext_sz));

traP = MVF_blk;
for blk_ii = 1:blk_rows
    for blk_jj = 1:blk_cols
        iiR2 = (blk_ii-1)*blk_sz + 1 + ext_sz;
        jjR2 = (blk_jj-1)*blk_sz + 1 + ext_sz;
        MV = [MVF_blk_R2(blk_ii,blk_jj,1);MVF_blk_R2(blk_ii,blk_jj,2)];
        iiR1 = iiR2 + MV(1);
        jjR1 = jjR2 + MV(2);
        blkR1_ii = fix((iiR1-ext_sz-1)/blk_sz)+1;
        blkR1_jj = fix((jjR1-ext_sz-1)/blk_sz)+1;
        blkR1_ii_match = [];
        blkR1_jj_match = [];
        minD = -1;
        for mm = 0:1
            for nn = 0:1
                blkR1_ii_pred = blkR1_ii + mm;
                blkR1_jj_pred = blkR1_jj + nn;
                if (blkR1_ii_pred<=blk_rows)&&(blkR1_jj_pred<=blk_cols)&&...
                        (blkR1_ii_pred>0)&&(blkR1_jj_pred>0)
                    iiR1_pred = (blkR1_ii_pred-1)*blk_sz + 1 + ext_sz;
                    jjR1_pred = (blkR1_jj_pred-1)*blk_sz + 1 + ext_sz;
                    dist = (iiR1-iiR1_pred)^2+(jjR1-jjR1_pred)^2;
                    if (minD<0)||(dist<minD)
                        minD = dist;
                        blkR1_ii_match = blkR1_ii_pred;
                        blkR1_jj_match = blkR1_jj_pred;
                    end
                end
            end
        end
        if isempty(blkR1_ii_match)
            blkR1_ii_match = blk_ii;
            blkR1_jj_match = blk_jj;
        end 
        MV_match = [MVF_blk_R1(blkR1_ii_match,blkR1_jj_match,1);...
            MVF_blk_R1(blkR1_ii_match,blkR1_jj_match,2)];
        traP(blk_ii,blk_jj,1) = round((5*MV(1)/8)-(MV_match(1)/8)+iiR2);
        traP(blk_ii,blk_jj,2) = round((5*MV(2)/8)-(MV_match(2)/8)+jjR2);
    end
end

[Gird_C,Gird_R] = meshgrid(1:blk_cols,1:blk_rows);
offset = 1;
for blk_ii = 1:blk_rows
    for blk_jj = 1:blk_cols
        ii = (blk_ii-1)*blk_sz + 1 + ext_sz;
        jj = (blk_jj-1)*blk_sz + 1 + ext_sz;
        traP_cand = []; MV_cand = []; Gird_cand = [];
        for blk_ii_near = blk_ii-offset:blk_ii+offset
            for blk_jj_near = blk_jj-offset:blk_jj+offset
                if (blk_ii_near<=blk_rows)&&(blk_jj_near<=blk_cols)&&...
                        (blk_ii_near>0)&&(blk_jj_near>0)
                    temp = [traP(blk_ii_near,blk_jj_near,1);...
                        traP(blk_ii_near,blk_jj_near,2)];
                    traP_cand = [traP_cand,temp];
                    temp = [MVF_blk_R2(blk_ii_near,blk_jj_near,1);...
                        MVF_blk_R2(blk_ii_near,blk_jj_near,2)];
                    MV_cand = [MV_cand,temp];
                    temp = [Gird_R(blk_ii_near,blk_jj_near);...
                            Gird_C(blk_ii_near,blk_jj_near)];
                    temp = (temp-1)*blk_sz+ext_sz+1;
                    Gird_cand = [Gird_cand,temp];
                end
            end
        end
        len = size(traP_cand,2);                           
        temp = repmat([ii;jj],1,len);
        dist = sum((temp-traP_cand).^2);
        [minD,min_I] = min(dist);
        CS = []; SP = [];
        for kk = 1:len
            if minD == dist(kk)
                MV = MV_cand(:,kk);
                CS = [CS,MV];
                sp = Gird_cand(:,kk);
                SP = [SP,sp];
            end
        end
        CS_cnt = size(CS,2);
        if CS_cnt==1
            MVF_blk(blk_ii,blk_jj,1) = round(CS(1)/2);
            MVF_blk(blk_ii,blk_jj,2) = round(CS(2)/2);
        else
            min_cost = -1;
            for kk = 1:CS_cnt
                MV = CS(:,kk);
                sp = SP(:,kk);
                sp_match = sp + MV;
                blkR2 = imR2_pad(sp(1)-enb_sz:sp(1)+enb_sz+blk_sz-1,...
                    sp(2)-enb_sz:sp(2)+enb_sz+blk_sz-1,:);
                blkR1 = imR1_pad(sp_match(1)-enb_sz:sp_match(1)+enb_sz+blk_sz-1,...
                    sp_match(2)-enb_sz:sp_match(2)+enb_sz+blk_sz-1,:);
                SAD = CostFun_PFRUC(blkR1,blkR2);
                MV_half = round(MV/2);
                iiR1 = ii + MV_half;
                jjR1 = jj + MV_half;
                blkR1 = imR1_pad(iiR1-enb_sz:iiR1+blk_sz+enb_sz-1,...
                    jjR1-enb_sz:jjR1+blk_sz+enb_sz-1,:);
                iiR2 = ii - MV_half;
                jjR2 = jj - MV_half;
                blkR2 = imR2_pad(iiR2-enb_sz:iiR2+blk_sz+enb_sz-1,...
                    jjR2-enb_sz:jjR2+blk_sz+enb_sz-1,:);
                BSAD = CostFun_PFRUC(blkR1,blkR2);
                cost = SAD + BSAD;
                if (min_cost<0)||(cost<min_cost)
                    min_cost = cost;
                    MV_best = MV_half;
                end
            end
            MVF_blk(blk_ii,blk_jj,1) = MV_best(1);
            MVF_blk(blk_ii,blk_jj,2) = MV_best(2);
        end
    end
end

end



