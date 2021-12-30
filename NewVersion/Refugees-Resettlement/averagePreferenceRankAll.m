function val = averagePreferenceRankAll(matching, FP)
    global numF numL;
    inds = matching == 1;
    count = sum(sum(inds));
    
    totsum = 0;
    for f=1:numF
        for l=1:numL
            if matching(f,l)
                totsum= totsum+ getRank(f,l,FP);
            end
        end
    end
    
    totsum = totsum + (numF - count) * (numL +1);
    val = totsum/numF;

end