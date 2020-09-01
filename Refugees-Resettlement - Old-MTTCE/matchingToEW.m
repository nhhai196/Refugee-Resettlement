% Takes a matching as input, and outputs the employment weight of the matching
function retval = matchingToEW(matching)
    global EW;
    [row, col] = size(matching);
    retval = 0;
    
    for f = 1:row
        for l = 1:col
            if matching(f,l) == 1
                retval = retval + EW(f,l);
            end
        end
    end
    fprintf("Employment Weight of the matching is %.2f\n", retval);
end