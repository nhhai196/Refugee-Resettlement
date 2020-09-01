
function cdf = cdfPreferenceAll(matching, FP)
    % makedist
    
    global numF numL;
    count = zeros(1, numL+1);
    
    for f = 1:numF
        for l = 1:numL
            if matching(f,l) == 1
                if FP(f, l) >= 1
                    rank = getRank(f,l, FP);
                    count(rank)= count(rank) + 1; 
                else
                    fprintf("++++ cdfPreference: something wrong !!!!!\n");
                end
            end
        end
    end
    
    count(numL +1) = numF - numberOfMatchedFamilies(matching);
    
    cdf = count;
    % Cumulate
    for i = 1:numL
        cdf(i+1) = cdf(i) + count(i+1);
    end
    
    % Normalize
    cdf = cdf/max(cdf);
end

