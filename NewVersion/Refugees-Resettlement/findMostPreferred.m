% Finds the most prerred locality among those that have not permanently
% rejected f, returns -1 if there is no such locality

function loc = findMostPreferred(f, currMatch)
    global FamPref;
    
    % Get a list of locality that have permanently rejected f
    lpr = currMatch(f, :) == -1; 
    
    % Get preferences of f over localities 
    fp = FamPref(f, :);
    
    % Set preferenrece of f with all localities that have permanently
    % rejected f to -1 (less preferred)
    fp(lpr) = -1;
    
    % Now find the most preferred localities (the index of the largest
    % rank in fp 
    [maxval, loc] = max(fp);
    
    % If there does not exist a such locality, returns -1 
    if (maxval < 1)
        loc = -1;
    end
end