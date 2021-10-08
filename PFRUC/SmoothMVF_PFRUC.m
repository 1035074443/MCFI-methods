function MVF_blk_proc = SmoothMVF_PFRUC(MVF_blk)

blk_rows = size(MVF_blk,1);
blk_cols = size(MVF_blk,2);


offset = 2;
for blk_ii = 1:blk_rows
    for blk_jj = 1:blk_cols
        CS = [];
        for blk_ii_pred = blk_ii-offset:blk_ii+offset
		    for blk_jj_pred = blk_jj-offset:blk_jj+offset
                if (blk_ii_pred>0)&&(blk_ii_pred<=blk_rows)&&(blk_jj_pred>0)&&...
                       (blk_jj_pred<=blk_cols)
                    MV = [MVF_blk(blk_ii_pred,blk_jj_pred,1);...
                    MVF_blk(blk_ii_pred,blk_jj_pred,2)];
                    CS = [CS,MV];
                end
		    end
        end
        MV0c = VMF(CS);
        MVF_blk(blk_ii,blk_jj,1) = MV0c(1);
        MVF_blk(blk_ii,blk_jj,2) = MV0c(2);
    end
end
MVF_blk_proc = MVF_blk;
end
         
         