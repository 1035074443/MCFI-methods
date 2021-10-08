function MVF_blk_proc = SmoothMVF_WVMF(MVF_blk,imR1,imR2,blk_sz,enb_sz)

blk_rows = size(MVF_blk,1);
blk_cols = size(MVF_blk,2);

ext_sz = enb_sz + max(abs(MVF_blk(:))) + 5*blk_sz;
imR1_pad = imextend(imR1,ext_sz);
imR2_pad = imextend(imR2,ext_sz);
 PredPosDis = [-1,-1,-1, 0, 0, 0, 1, 1, 1;
               -1, 0, 1,-1, 0, 1,-1, 0, 1];
 for blk_ii = 1:blk_rows
     for blk_jj = 1:blk_cols
         ii = (blk_ii-1)*blk_sz+1+ext_sz;
         jj = (blk_jj-1)*blk_sz+1+ext_sz;
         MV0 = [MVF_blk(blk_ii,blk_jj,1);MVF_blk(blk_ii,blk_jj,2)];
         iiR1 = ii + MV0(1);
         jjR1 = jj + MV0(2);
         blkR1 = imR1_pad(iiR1-enb_sz:iiR1+blk_sz+enb_sz-1,...
             jjR1-enb_sz:jjR1+blk_sz+enb_sz-1,:);
         iiR2 = ii - MV0(1);
         jjR2 = jj - MV0(2);
         blkR2 = imR2_pad(iiR2-enb_sz:iiR2+blk_sz+enb_sz-1,...
             jjR2-enb_sz:jjR2+blk_sz+enb_sz-1,:);
         cost0 = CostFun(blkR1,blkR2);
         CS = []; w = [];
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
                 cost = CostFun(blkR1,blkR2);
                 w = [w,cost];
             end
         end
         w = cost0./w;
         MV0c = WVMF(CS,w);
         MVF_blk(blk_ii,blk_jj,1) = MV0c(1);
         MVF_blk(blk_ii,blk_jj,2) = MV0c(2);
     end
 end       
 MVF_blk_proc = MVF_blk;

 
function MV_median = WVMF(MV_set,weight)

MV_num = size(MV_set,2);

if MV_num == 1
    MV_median = MV_set;
    return;
end

if MV_num ~= length(weight)
    error('The num of Motion vector is same with their weight!');
end

if size(weight,1)>1
    weight = weight.';
end

min_sum_diff = -1;
for ii = 1:MV_num
    MV_obj = MV_set(:,ii);
    temp = repmat(MV_obj,1,MV_num);
    sum_diff = sum(weight.*sqrt(sum((MV_set-temp).^2)));
    if (sum_diff<min_sum_diff)||(min_sum_diff<0)
        min_sum_diff = sum_diff;
        MV_median = MV_obj;
    end
end

         
         