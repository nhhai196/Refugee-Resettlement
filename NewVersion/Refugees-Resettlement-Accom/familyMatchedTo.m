function loc = familyMatchedTo(f, matching)
    loc = find(matching(f, :) == 1);
    if length(loc) > 1
        fprintf("ERROR: family %d matched to more than one localities\n", f);
    end
end