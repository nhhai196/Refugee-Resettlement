function [match, val] = randomEndowment()
    global numF numL;
    
    matchedfams = false(1, numF);
    match = zeros(numF, numL);
    
    while isWasteful(match)
        % pick a family at random
        f = randi(numF);
        if ~matchedfams(f)
            [match, flag] = randommatch(f, match);
            
            if flag 
                matchedfams(f) = true;
            end
        end 
    end 
    
    val = matchingToEW(match);
end


function [match, flag] = randommatch(f, match)
    global numL COMP;
    free = true(1, numL);
    flag = false;
    
    while true
        l = randi(numL);
        G = match(:, l) == 1;
        
        if COMP(f,l) && isAccommodateAlongside(l, f, G) && free(l)
            match(f, l) = 1;
            flag = true;
            break;
        else
            free(l) = false;
        end
        
        if ~any(free)
            break;
        end
    end
end
