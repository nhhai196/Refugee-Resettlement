function count = countStrictlyBetterOff(matching, endowment)
    global numF FamPref;
    count = 0;
    for f = 1:numF
        if isBetterOff(matching(f, :), endowment(f, :), FamPref(f,:))
            count = count + 1;
        end
    end
    
end

function bol = isBetterOff(ml, el, fp)
    l1 = find(ml == 1);
    l2 = find(el == 1);
    
    if (length(l1) > 1 || length(l2) > 1)
        fprintf("ERROR: something wrong\n");
        return;
    end
    
    if isempty(l1)
        bol = false;
    elseif isempty(l2)
        bol = true;
    else
        bol = fp(l1) > fp(l2);
    end
end