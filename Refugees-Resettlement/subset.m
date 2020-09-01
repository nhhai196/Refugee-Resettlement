
global numF;
numF = 5;
v = [2 4];
a = [1 2 4]; 
b = false(1,5);
b(1) = true;
b(2) = true;
b(4) = true;

subsets = nchoosek(a, 2);
b = true(1,30);

%retval = setToIndicator(v, 2);


function retval = setToIndicator(v, n)
    global numF; 
    retval = false(1, numF);
    for i = 1:n
        retval(v(i)) = 1;
    end
end

function retval = enumerateAllSubsets(hpfs, k)
    elements = find(hpfs == 1);
    subsets = nchoosek(elements, k);
    len = nchoosek(length(elements), k);
    retval = zeros(len, length(hpfs));
    for i = 1: len
        retval(i,:) = setToIndicator(subsets(i,:), k);
    end
end



