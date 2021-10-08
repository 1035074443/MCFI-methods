function cost = CostFun(blkC,blkR)

costY = sum(sum(abs(blkC(1:2:end,1:2:end,1)-blkR(1:2:end,1:2:end,1))));
costU  = sum(sum(abs(blkC(2:2:end,1:2:end,2)-blkR(2:2:end,1:2:end,2))));
costV  = sum(sum(abs(blkC(1:2:end,2:2:end,3)-blkR(1:2:end,2:2:end,3))));
costG  = sum(sum(abs(blkC(2:2:end,2:2:end,4)-blkR(2:2:end,2:2:end,4))));
cost   = costY + 8*costU + 8*costV + 0.1*costG;

end