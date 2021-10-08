function MVF_blk = BMA_Hie(imC,imR,blk_sz,enb_sz,sch_rd_top,sch_rd_nt,lev)

[im_rows_btm,im_cols_btm] = size(imC(:,:,1));
imC_pyr = subsamp_PFRUC(imC,lev);
imR_pyr = subsamp_PFRUC(imR,lev);

for kk = lev:-1:1
    
   im_rows  = im_rows_btm/(2^(kk-1));
   im_cols  = im_cols_btm/(2^(kk-1));
   blk_rows = im_rows/blk_sz;
   blk_cols = im_cols/blk_sz;
   MVF_blk  = zeros(blk_rows,blk_cols,2);
   
   if kk == lev
       
       ext_sz = sch_rd_top + enb_sz;
       temp = imC_pyr{kk};
       imC_pad = cat(3,imextend(temp(:,:,1),ext_sz),imextend(temp(:,:,2),ext_sz),...
           imextend(temp(:,:,3),ext_sz));
       temp = imR_pyr{kk};
       imR_pad = cat(3,imextend(temp(:,:,1),ext_sz),imextend(temp(:,:,2),ext_sz),...
           imextend(temp(:,:,3),ext_sz));
       
       for ii = 1+ext_sz:blk_sz:im_rows+ext_sz
           for jj = 1+ext_sz:blk_sz:im_cols+ext_sz

               blk_ii = fix((ii-ext_sz-1)/blk_sz) + 1;
               blk_jj = fix((jj-ext_sz-1)/blk_sz) + 1;

               blkC = imC_pad(ii-enb_sz:ii+blk_sz+enb_sz-1,...
                   jj-enb_sz:jj+blk_sz+enb_sz-1,:);
               min_cost = -1;
               for mm = ii-sch_rd_top:ii+sch_rd_top
                   for nn = jj-sch_rd_top:jj+sch_rd_top
                       blkR = imR_pad(mm-enb_sz:mm+blk_sz+enb_sz-1,...
                           nn-enb_sz:nn+blk_sz+enb_sz-1,:);
                       dx = mm-ii; dy = nn-jj;
                       cost = CostFun_PFRUC(blkC,blkR)+(dx^2+dy^2)*(blk_sz+2*enb_sz)^2/(2^(kk-lev));
                       if (min_cost<0)||(cost<min_cost)
                           min_cost = cost;
                           bestR_ii = mm;
                           bestR_jj = nn;
                       end
                   end
               end

               MVF_blk(blk_ii,blk_jj,1) = bestR_ii - ii;
               MVF_blk(blk_ii,blk_jj,2) = bestR_jj - jj;

           end
       end
       MVF_blk = SmoothMVF_PFRUC(MVF_blk);
       MVF_blk_pre = MVF_blk;
       
   else
       
       ext_sz = max(abs(2*MVF_blk_pre(:))) + sch_rd_nt + enb_sz + blk_sz;
       temp = imC_pyr{kk};
       imC_pad = cat(3,imextend(temp(:,:,1),ext_sz),imextend(temp(:,:,2),ext_sz),...
           imextend(temp(:,:,3),ext_sz));
       temp = imR_pyr{kk};
       imR_pad = cat(3,imextend(temp(:,:,1),ext_sz),imextend(temp(:,:,2),ext_sz),...
           imextend(temp(:,:,3),ext_sz));
       blk_rows_pre = size(MVF_blk_pre,1);
       blk_cols_pre = size(MVF_blk_pre,2);
       
       for blk_ii = 1:blk_rows
           for blk_jj = 1:blk_cols
               
               ii = (blk_ii-1)*blk_sz + 1 + ext_sz;
               jj = (blk_jj-1)*blk_sz + 1 + ext_sz;
               blk_ii_fa = fix((blk_ii-1)/2) + 1;
               blk_jj_fa = fix((blk_jj-1)/2) + 1;
               
               MV_pred = [];
               for blk_ii_pre = blk_ii_fa-1:blk_ii_fa
                   for blk_jj_pre = blk_jj_fa:blk_jj_fa+1
                       if (blk_ii_pre>0&&blk_ii_pre<=blk_rows_pre)&&...
                               (blk_jj_pre>0&&blk_jj_pre<=blk_cols_pre)...
                               &&~((blk_ii_pre==(blk_ii_fa-1))&&...
                               (blk_jj_pre==blk_jj_fa+1))
                           MV_temp_row = MVF_blk_pre(blk_ii_pre,blk_jj_pre,1);
                           MV_temp_col = MVF_blk_pre(blk_ii_pre,blk_jj_pre,2);
                           MV_pred = [MV_pred,[MV_temp_row;MV_temp_col]];
                       end
                   end
               end
               
               cnt_pred = size(MV_pred,2);
               MarchR = repmat([ii;jj],1,cnt_pred)+2*MV_pred;  %%%
               blkC = imC_pad(ii-enb_sz:ii+blk_sz+enb_sz-1,...
                   jj-enb_sz:jj+blk_sz+enb_sz-1,:);
               min_cost = -1;
               for tt = 1:cnt_pred
                   iiR = MarchR(1,tt);
                   jjR = MarchR(2,tt);
                   for mm = iiR-sch_rd_nt:iiR+sch_rd_nt
                       for nn = jjR-sch_rd_nt:jjR+sch_rd_nt
                           blkR = imR_pad(mm-enb_sz:mm+blk_sz+enb_sz-1,...
                               nn-enb_sz:nn+blk_sz+enb_sz-1,:);
                           dx = mm-ii; dy = nn-jj;
                           cost = CostFun_PFRUC(blkC,blkR)+...
                               (dx^2+dy^2)*(blk_sz+2*enb_sz)^2/(2^(kk-lev));
                           if (min_cost<0)||(cost<min_cost)
                               min_cost = cost;
                               bestR_ii = mm;
                               bestR_jj = nn;
                           end
                       end
                   end 
               end
               MVF_blk(blk_ii,blk_jj,1) = bestR_ii - ii;
               MVF_blk(blk_ii,blk_jj,2) = bestR_jj - jj;  
           end
       end
       MVF_blk_pre = MVF_blk;
   end 
end

end    