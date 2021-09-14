function avg = averageMatchedPriority(matching, LP)
    % makedist
    
    global numF numL;
    %count = zeros(1, numL);
    avg = zeros(1, numL);
    
    for l = 1:numL
        totsum = 0;
        count = 0;
        for f = 1:numF
            if matching(f,l) == 1
                if LP(f, l) >= 1
                    totsum = totsum + getPriority(f,l, LP);
                    count = count + 1;
                else
                    fprintf("++++ averagePriority: something wrong !!!!!\n");
                end
            end
        end
        
        if count >= 1
            avg(l) = totsum/count;
        end
        
    end
end