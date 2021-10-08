function cost = CostFun_MCMP(blkC,blkR)

costY1 = sum(sum(abs(blkC(1:2:end,1:2:end,1)-blkR(1:2:end,1:2:end,1))));
costY2 = sum(sum(abs(blkC(2:2:end,2:2:end,1)-blkR(2:2:end,2:2:end,1))));
costU  = sum(sum(abs(blkC(2:2:end,1:2:end,2)-blkR(2:2:end,1:2:end,2))));
costV  = sum(sum(abs(blkC(1:2:end,2:2:end,3)-blkR(1:2:end,2:2:end,3))));

cost   = costY1 + costY2 + 8*costU + 8*costV;

end