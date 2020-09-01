%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% THRESHOLD CALCULATOR %%%%%%%%%%%%%%%%%%%%%%%%%%%%

function theta = thresholdCalculator(LP, PI)
    thetatilde = temporaryThreshold(LP, PI);
    theta = calculateThreshold(thetatilde, LP);
    
end

% LP : a matrix of size numF by numL containing locality priorities
% PI: a matrix of size numF by numL containing proposing families
function thetatilde = temporaryThreshold(LP, PI)
    global numF numL;
    thetatilde = zeros(numF, numL);
    
    for l = 1:numL
        for f = 1:numF
            lp = transpose(LP(:, l));
            pil = transpose(PI(:,l));
            hpfs = getHigherPriorityFamilies(f, lp);
            thetatilde(f,l) = temporaryThresholdOne(f, l, hpfs, pil);
        end
    end
end

% pil : a list families  (row vector) that are currently proposing to l
% lp : priorities of locality l (row vector) 
function retval = temporaryThresholdOne(f, l, hpfs, pil)
    global infinity;
    
    %hpfs = getHigherPriorityFamilies(f, lp);
    %fprintf("Higher priorities of f = %d, l = %d: ", f, l);
    %printVector(hpfs);
    %fprintf("Pi of %d is ", l);
    %printVector(pil);
    pfl = pil & hpfs;
    
    if weaklyAccommodate(f, l, hpfs)
        retval = infinity;
    elseif ~weaklyAccommodate(f, l, pfl)
        retval = 0;
    else
        %retval = findUniqueN(f, l, hpfs, pil);
        retval = findUniqueNEfficient(f, l, hpfs, pil);
    end 
    %fprintf("thetatilde(%d, %d) = %d\n", f, l, retval);
end



%
% This function is not optimized yet

function retval = findUniqueN(f, l, hpfs, pil)
    len = sum(hpfs);
    retval = -1;
    
    %fprintf("Start fiding the value n\n");
    for n = 1: len
        cond1= canWeaklyAccAlongsideAllSets(f, l, n, hpfs, pil);
        cond2 = cannotWeaklyAccAlongsideASet(f, l, n, hpfs, pil);
        if cond1 && cond2
            retval = n;
            %fprintf("Set threshold of %d %d = %d\n", f, l, n);
            break;
        end
    end
end

% A more effcient function to find the threshold n
function retval = findUniqueNEfficient(f, l, hpfs, pil)
    global numS NU;
    numFams = zeros(1, numS);
    inds = false(1, numS);
    
    for s = 1:numS
        if (NU(s, f) > 0)
            numFams(s) = getNumberOfFamilies(f, l, s, hpfs, pil);
            inds(s) = true; 
        end
    end
    
    retval = min(numFams(inds));
    
end 

% Take each service for which f needs at least one unit one at a time and 
% order the families with a higher priority from largest to smallest need 
% for that service. Starting from the family with the largest need, add
% one family at a time until the total need for that service (including f’s) 
% exceeds the capacity.
function retval =  getNumberOfFamilies(f, l, s, hpfs, pil)
    global NU;
    %both = hpfs & pil;
    
    temp = NU(s,:);
    G = hpfs & pil;
    temp(~G) = -1;
    [~, order] = sort(temp, 'descend');
    G(f) = true;
    retval = 0;
    
    for i = 1:length(hpfs)
        G(order(i)) = true;
        if ~weaklyAccommodateOneService(f, l, s, G)
            retval = length(find(G==1));
            break;
        end
    end    
end

%
function bol = weaklyAccommodateOneService(f, l, s, G)
    global NU KAPPA;
    bol = true;
    
    if ((NU(s,f)~= 0) && (NU(s, f) + sum(NU(s, G))> KAPPA(s, l)))
        bol = false; 
        %fprintf("%d can't accommodate %d along side %d\n", l, f);
        %printVector(G);
    end
end

%
function bol = canWeaklyAccAlongsideAllSets(f, l, n, hpfs, pil)
    % enumerate all the subsets of size n
    subsets = enumerateAllSubsets(hpfs, n-1);
    bol = true;
    [len, ~] = size(subsets);
    
    if (n == 1)
        return;
    end
    
    for i = 1:len
        G = subsets(i, :);
        if isSubset(hpfs & pil, G)
            if ~weaklyAccommodate(f, l, G)
                bol = false;
            end
        end
    end
end

function bol =  cannotWeaklyAccAlongsideASet(f, l, n, hpfs, pil)
    subsets = enumerateAllSubsets(hpfs, n); % This is expensive 
    bol = false;
    [len, ~] = size(subsets);
    for i = 1:len
        G = subsets(i, :);
        if isSubset(hpfs & pil, G)
            if ~weaklyAccommodate(f, l, G)
                bol = true;
            end
        end
    end
end

function retval = enumerateAllSubsets(hpfs, k)
    elements = find(hpfs == 1);
    subsets = nchoosek(elements, k);
    len = nchoosek(length(elements), k);
    
    retval = false(len, length(hpfs));
    for i = 1: len
        retval(i,:) = setToIndicator(subsets(i,:), k);
    end
end

function retval = setToIndicator(v, n)
    global numF; 
    retval = false(1, numF);
    for i = 1:n
        retval(v(i)) = 1;
    end
end

% Check if S is a subset of T
function bol = isSubset(S, T)
    bol = all(T == (S | T));
end

% 
function theta = calculateThreshold(thetatilde, LP)
    global numF numL;
    theta = zeros(numF, numL);
    
    for l = 1:numL
        for f = 1:numF
            hpfs = getHigherPriorityFamilies(f, LP(:, l));
            theta(f, l) = calculateThresholdOne(f, l, hpfs, thetatilde);
            %fprintf("theta(%d, %d) = %d\n", f, l, theta(f,l));
        end
    end
end

% 
function retval = calculateThresholdOne(f, l, hpfs, thetatilde)
    global infinity;
    if (thetatilde(f,l) == infinity)
        retval = thetatilde(f,l);
    else
        hpfs(f) = true;
        G = transpose(hpfs);
        retval = min(thetatilde(G, l));
    end
end
