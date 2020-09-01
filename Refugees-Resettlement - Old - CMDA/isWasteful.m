function bol = isWasteful(match)
    global numF;
    
    % get list of unmatched families
    unmatchedFams = ~any(match, 2);
    bol = false;
    
    for f = 1:numF
        if unmatchedFams(f)
            if isWastefulUltil(f, match)
                bol = true;
                break;
            end
        end
    end
end

function bol = isWastefulUltil(f, match)
    global numL COMP;
    bol = false;
    
    for l = 1:numL
        G = match(:,l) == 1;
        G(f) = true;
            if COMP(f,l) && isAbleToAccommodate(l, G)
                bol = true;
                %fprintf("(%d, %d) is a wasteful pair\n", f, l);
                break;
            end
    end
end