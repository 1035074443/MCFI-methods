function MV_median = VMF(MV_set)

MV_num = size(MV_set,2);

if MV_num == 1
    MV_median = MV_set;
    return;
end

min_sum_diff = -1;
for ii = 1:MV_num
    MV_obj = MV_set(:,ii);
    temp = repmat(MV_obj,1,MV_num);
    sum_diff = sum(sum((MV_set-temp).^2));
    if (sum_diff<min_sum_diff)||(min_sum_diff<0)
        min_sum_diff = sum_diff;
        MV_median = MV_obj;
    end
end

end
    