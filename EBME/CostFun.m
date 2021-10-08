function cost = CostFun(blkC,blkR)

cost = sum(abs(blkC(:)-blkR(:)));
% cost = blkC(:)-blkR(:)
% cost = abs(cost)
% cost = sum(cost)

end