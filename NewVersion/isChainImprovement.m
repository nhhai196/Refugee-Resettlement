function bol = isChainImprovement(acyc)
    global numF FamPref endowment;
    bol = true;

    n = length(acyc);
    
    for j = 1:1:floor(n/2)
        l = acyc(2*j) - numF;
        f = acyc(2*j-1);
        
        muEf = find(endowment(f,:) == 1);
        
        if ~isempty(muEf) 
            if FamPref(f, l) < FamPref(f,muEf)
                bol = false;
                break;
            end
        end
    end
end