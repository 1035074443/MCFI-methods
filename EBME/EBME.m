function MVF_blk = EBME(imR1,imR2,blk_sz,sch_rd)

ext_sz = sch_rd+2*blk_sz;
[im_rows,im_cols] = size(imR1);
imR1_pad = imextend1(imR1,ext_sz);
imR2_pad = imextend1(imR2,ext_sz);

blk_sz_init = 2*blk_sz;
blk_rows_init = im_rows/blk_sz_init;
blk_cols_init = im_cols/blk_sz_init;
MVF_blk_init = zeros(2*blk_rows_init-1,2*blk_cols_init-1,2);


for ii = 1+ext_sz:blk_sz_init/2:im_rows+ext_sz-blk_sz+1
    for jj = 1+ext_sz:blk_sz_init/2:im_cols+ext_sz-blk_sz+1
        
        blk_ii = fix((ii-1-ext_sz)/(blk_sz_init/2)) + 1;
        blk_jj = fix((jj-1-ext_sz)/(blk_sz_init/2)) + 1;
        
        min_cost = -1;
        for mm = ii-sch_rd:ii+sch_rd
            for nn = jj-sch_rd:jj+sch_rd
                iiR1 = mm; jjR1 = nn;
                blkR1 = imR1_pad(iiR1:iiR1+blk_sz_init-1,...
                    jjR1:jjR1+blk_sz_init-1);
                iiR2 = 2*ii - mm; jjR2 = 2*jj - nn;
                blkR2 = imR2_pad(iiR2:iiR2+blk_sz_init-1,...
                    jjR2:jjR2+blk_sz_init-1);
                cost = CostFun(blkR1,blkR2);
                if (min_cost<0)||(cost<min_cost)
                    min_cost = cost;
                    bestR1_ii = mm;
                    bestR1_jj = nn;
                end
            end
        end
        MVF_blk_init(blk_ii,blk_jj,1) = bestR1_ii - ii;
        MVF_blk_init(blk_ii,blk_jj,2) = bestR1_jj - jj;
    end
end

blk_rows = im_rows/blk_sz;
blk_cols = im_cols/blk_sz;
MVF_blk = zeros(blk_rows,blk_cols,2);
Pos = [-1,-1,0 ,0;
       -1, 0,-1,0];
for ii = 1+ext_sz:blk_sz:im_rows+ext_sz
    for jj = 1+ext_sz:blk_sz:im_cols+ext_sz
        
        blk_ii = fix((ii-1-ext_sz)/blk_sz)+1;
        blk_jj = fix((jj-1-ext_sz)/blk_sz)+1;
        CS = [];
        for kk = 1:size(Pos,2)
            mm = ii + blk_sz*Pos(1,kk);
            nn = jj + blk_sz*Pos(2,kk);
            blk_mm = fix((mm-1-ext_sz)/(blk_sz_init/2)) + 1;
            blk_nn = fix((nn-1-ext_sz)/(blk_sz_init/2)) + 1;
            if (blk_mm>=1)&&(blk_mm<=2*blk_rows_init-1)&&...
                    (blk_nn>=1)&&(blk_nn<=2*blk_cols_init-1)
                MV = [MVF_blk_init(blk_mm,blk_nn,1);
                    MVF_blk_init(blk_mm,blk_nn,2)];
                CS = [CS,MV];
            end
        end
        min_cost = -1;
        for kk = 1:size(CS,2)
            MV = CS(:,kk);
            iiR1 = ii + MV(1);
            jjR1 = jj + MV(2);
            iiR2 = ii - MV(1);
            jjR2 = jj - MV(2);
            blkR1 = imR1_pad(iiR1:iiR1+blk_sz-1,...
                jjR1:jjR1+blk_sz-1);
            blkR2 = imR2_pad(iiR2:iiR2+blk_sz-1,...
                jjR2:jjR2+blk_sz-1);
            cost = CostFun(blkR1,blkR2);
            if (min_cost<0)||(cost<min_cost)
                min_cost = cost;
                MV_best = MV;
            end
        end
        MVF_blk(blk_ii,blk_jj,1) = MV_best(1);
        MVF_blk(blk_ii,blk_jj,2) = MV_best(2);
    end
end

end
    
