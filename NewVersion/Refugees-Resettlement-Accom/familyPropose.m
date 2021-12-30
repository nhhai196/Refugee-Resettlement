% Every family proposes to its favorite locality that has not permanently
% rejected it yet (using in CMDA and TMDA)
function newMatch = familyPropose(currMatch)
    global numF;
    newMatch = currMatch;
    
    for f = 1:numF
        l = findMostPreferred(f, currMatch);
        %l
        if (l >= 1)
            newMatch(f,l) = 2;
            %fprintf("Family %d proposing to locality %d\n", f, l);
        end 
    end
end