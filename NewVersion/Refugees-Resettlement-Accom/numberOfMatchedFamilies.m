%
function count = numberOfMatchedFamilies(matching)
    count = sum(sum(matching == 1));
end