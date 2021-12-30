% 
function printMatching(M)
    [m, n] = size(M);
    
    fprintf("++++++++++++++ Print out the matching +++++++++++++++++++\n");
    for f = 1:m
        for l = 1:n
            if (M(f,l) == 1)
                fprintf("Family %d matched with locality %d\n", f, l);
            end
        end
    end
end