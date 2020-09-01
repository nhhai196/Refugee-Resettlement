% A function that checks whether a locality l can accommodate a set 
% of families G or not. Note that G is an indicator vector (logical array)
% of length numF. 
function bol = isAbleToAccommodate(l,G)
    global NU KAPPA;

    bol = all(sum(NU(:, G),2) <= KAPPA(:, l));
end