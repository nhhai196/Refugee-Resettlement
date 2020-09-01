function bol = isParetoImprovement(match)
    global numF FamPref endowment;
    bol = true;
    
    for f=1:numF
        muf = find(match(f,:) == 1);
        muEf = find(endowment(f,:) == 1);
        if (length(muf) >= 2 || length(muEf) >= 2)
            bol = false;
            fprintf("Pareto: Something wrong!!!!!!!\n");
            return;
        end
        if ~isempty(muEf)
            if isempty(muf)
                bol = false;
            else 
                if (FamPref(f, muf) < FamPref(f, muEf))
                    bol = false;
                    break;
                end
            end
        end
    end
        
end
