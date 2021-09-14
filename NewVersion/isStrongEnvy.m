% 
function bol = isStrongEnvy(f1, f2, matching)
    if (f1 == f2)
        bol = false;
    else
        l1 = familyMatchedTo(f1, matching);
        l2 = familyMatchedTo(f2, matching);
        
        % (i) f1 prefers f2's locality to its current match
        cond1 = isMorePreferred(f1, l2, l1);
        
        % (ii) f1 has higher priority at l2
        cond2 = isHigherPriority(f1, f2, l2);
        
        if (cond1 && cond2)
            % (iii)l2 cannot weakly accommodate f2 alongside all families 
            % with a higher priority than f2 at l2 that weakly prefer l2 to  
            % their current matches
            G = getFamilies(f2, l2, matching);
            bol = ~weaklyAccommodate(f2, l2, G); %&& isAbleToAccommodate(l2, G);
%             if bol
%                 fprintf("++++ (%d, %d) is a strong envy pair \n", f1, f2);
%             end
        else
            bol = false;
        end
    end
end

% Helper function
function hpfs = getFamilies(f, l, matching)
    global LocPri numF;
    hpfs = getHigherPriorityFamilies(f, transpose(LocPri(:, l)));
    for i = 1:numF
        if hpfs(i)
            if ~weaklyPrefer(i, l, familyMatchedTo(i, matching))
                hpfs(i) = false;
            end
        end
    end
end
