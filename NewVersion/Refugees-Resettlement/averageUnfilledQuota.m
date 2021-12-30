function val = averageUnfilledQuota(matching)
    global numSL numFL A b;
    
    x = reshape(matching, numFL, 1);
    tempA = A(1:numSL,:);
    tempb = b(1:numSL);
    
    diff = tempb - tempA * x ;
    
    len = length(diff);
    unfill = zeros(len, 1);
    for i = 1:len
        if tempb(i)== 0
            unfill(i) = 0;
        else
            unfill(i) = diff(i)/tempb(i);
        end
    end
    
    val = mean(unfill);
    
end