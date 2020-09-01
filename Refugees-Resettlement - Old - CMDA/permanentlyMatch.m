% Permanently match every family to the locality to which the family 
% is proposing (use in CMDA and TMDA)
function currMatch = permanentlyMatch(currMatch)
    inds = currMatch == 2;
    currMatch(inds) = 1;
end