% A function that checks whether a locality l can accommodate a famimily f 
% along side a set of families G or not.
function bol = isAccommodateAlongside(l, f, G)
    % add family f to set of families G
    G(f) = 1;
    bol = isAbleToAccommodate(l,G);
end