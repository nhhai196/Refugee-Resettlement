% hpfs is a logical array indicating families that have higher priority
% than f
function hpfs = getHigherPriorityFamilies(f, lp)
    hpfs = lp  > lp(f);
end
