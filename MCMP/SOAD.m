function alpha = SOAD(blk0,blk_set,blk_sty,blk_sz,enb_sz_mc)

alpha = 0;
for kk = 1:length(blk_sty)
    blkN = reshape(blk_set(:,kk),blk_sz,blk_sz);
    switch blk_sty(kk)
        case 1
            temp1 = blkN(end-enb_sz_mc+1:end,end-enb_sz_mc+1:end);
            temp2 = blk0(1:enb_sz_mc,1:enb_sz_mc);
            alpha = alpha + sum(abs(temp1(:)-temp2(:)));
        case 2
            temp1 = blkN(end-enb_sz_mc+1:end,1:blk_sz);
            temp2 = blk0(1:enb_sz_mc,enb_sz_mc+1:enb_sz_mc+blk_sz);
            alpha = alpha + sum(abs(temp1(:)-temp2(:)));
        case 3
            temp1 = blkN(end-enb_sz_mc+1:end,1:enb_sz_mc);
            temp2 = blk0(1:enb_sz_mc,end-enb_sz_mc+1:end);
            alpha = alpha + sum(abs(temp1(:)-temp2(:)));
        case 4
            temp1 = blkN(1:blk_sz,end-enb_sz_mc+1:end);
            temp2 = blk0(enb_sz_mc+1:enb_sz_mc+blk_sz,1:enb_sz_mc);
            alpha = alpha + sum(abs(temp1(:)-temp2(:)));
        case 5
            temp1 = blkN(1:blk_sz,1:enb_sz_mc);
            temp2 = blk0(enb_sz_mc+1:enb_sz_mc+blk_sz,end-enb_sz_mc+1:end);
            alpha = alpha + sum(abs(temp1(:)-temp2(:)));
        case 6
            temp1 = blkN(1:enb_sz_mc,end-enb_sz_mc+1:end);
            temp2 = blk0(end-enb_sz_mc+1:end,1:enb_sz_mc);
            alpha = alpha + sum(abs(temp1(:)-temp2(:)));
        case 7 
            temp1 = blkN(1:enb_sz_mc,1:blk_sz);
            temp2 = blk0(end-enb_sz_mc+1:end,enb_sz_mc+1:enb_sz_mc+blk_sz);
            alpha = alpha + sum(abs(temp1(:)-temp2(:)));
        case 8 
            temp1 = blkN(1:enb_sz_mc,1:enb_sz_mc);
            temp2 = blk0(end-enb_sz_mc+1:end,end-enb_sz_mc+1:end);
            alpha = alpha + sum(abs(temp1(:)-temp2(:)));
    end
    
end

end
            
            

