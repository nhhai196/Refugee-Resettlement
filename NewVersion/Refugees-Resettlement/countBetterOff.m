function count = countBetterOff(match, endowment)
    inds = match & endowment;
    count = sum(sum(match)) - sum(sum(inds));
end