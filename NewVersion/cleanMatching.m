function matching = cleanMatching(matching)
    inds = matching ~= 1;
    matching(inds) = 0;
end