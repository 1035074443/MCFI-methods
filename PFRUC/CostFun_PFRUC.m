function cost = CostFun_PFRUC(blkC,blkR)

W = 4;
costY = sum(sum(abs(blkC(:,:,1)-blkR(:,:,1))));
costU = sum(sum(abs(blkC(:,:,2)-blkR(:,:,2))));
costV = sum(sum(abs(blkC(:,:,3)-blkR(:,:,3))));
cost   = costY + W*costU + W*costV;

end

