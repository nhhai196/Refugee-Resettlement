% Count number of strong envies 
function count = countStrongEnvies(matching)
    global numF;
    count = 0;
    
    for f1 = 1:numF
        for f2 = 1:numF
            if isStrongEnvy(f1, f2, matching)
                count = count + 1;
            end
        end
    end
    fprintf("Number of strong envy pairs is %d\n", count);
end