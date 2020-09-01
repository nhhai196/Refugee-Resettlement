
function cdf = cdfPreference(matching, FP)
    % makedist
    
    global numF numL;
    count = zeros(1, numL);
    
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
    
    cdf = count;
    % Cumulate
    for i = 1:numL-1
        cdf(i+1) = cdf(i) + count(i+1);
    end
    
    % Normalize
    cdf = cdf/max(cdf);
end

