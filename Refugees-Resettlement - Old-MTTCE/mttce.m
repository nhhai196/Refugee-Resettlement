%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% GLOBAL VARIABLES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%global numF ;      % The number of families, so families are numbered as
                    % 1, 2, ..., numF
                    
%global numL ;      % The number of localities, so localites are numbered
                    % as 1, 2, ..., numL
                    
%global numS ;      % The number of services, so services are numbered as
                    % 1, 2, ..., numS
                    
%global KAPPA;      % A numS by numL matrix in which the (s,l) entry 
                    % represents the capacity of locality l for service s

%global NU;         % A numS by numF matrix in which the (s,f) entry
                    % represents the number of units of service s needed 
                    % by family f

%global FamPref;    % A matrix of size numF by numL represents 
                    % the prefereces of family over localites
                    % Convention: the larger value, the more preffered,
                    % to be positive integer 1, 2, 3,...
                    
%global LocPri;     % A matrix of size numF by numL represents 
                    % the priority of localities over families
                    
%global Matching;   % A matrix of size numF by numL
                    % Initally it is all zeros matrix
                    % -1 : permanently rejected
                    % 1 : permanently mathched 
                    
%global FamPerMatch;% A logical array of size numF by 1  idicating which 
                    % famimilies have been permanently matched
                   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% MTTCE ALGORITHM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mttce(currMatch)
    global FamPerMatch Matching numF;
    Matching = 2 * currMatch;
    
    
    fprintf("Running MTTCE algorithm...\n");
    % reset variable 
    FamPerMatch = zeros(numF, 1);
    
    %initGlobalVariables();
    round = 1;  % counter for the number of rounds
    
    % Sort families by size
    sorted = sortBySize(2);
    
    %picked = zeros(1, numF);
    while (~all(FamPerMatch))
        fprintf("===================== Round %d =========================\n",round);
        %Matching
        %Mui = Matching; % store the mathing of round i 
        Matching = permanentlyReject(Matching);
        G = constructGraph(Matching);
        cycles = findCycles(G);
        if isempty(cycles)
            break;
        end
        
        cycles = getFeasibleCycles(cycles, Matching);
        if (length(cycles) >= 1)
            fprintf("At least one cycle is feasible\n");
            Matching = matchingStage(cycles, G, Matching);
        else
            picked = zeros(1, numF);
            while true
            fprintf("No cycle is feasible\n");
            [f, fpointingto, picked, Matching] = rejectionStage(Matching, G, picked, sorted);

            %If f is permanently rejected by the locality at which f is pointing
            %fpointingto
            if (Matching(f, fpointingto) == -1)
                fprintf("Family %d is permanently rejected by the locality at which it is pointing\n", f);
                %Matching = Mui;
                break;
            else
                fprintf("Family %d is not permanently rejected by the locality at which it is pointing\n", f);
                [~, ~, ~,  Matching] = rejectionStage(Matching, G, picked, sorted);
            end
            end
        end
        %Matching
        
        round = round + 1;

    end
    
    % Print out the result
    Matching = cleanMatching(Matching);
    %printMatching(Matching);
    
    % Sanity check 
    if isWasteful(Matching)
        fprintf("The output of MTTCE is wasteful\n");
    else
        fprintf("The output of MTTCE is non-wasteful\n");
    end
    fprintf("The number of rounds is %d\n", round-1);
    
    fprintf("Done MTTCE\n");
    %fprintf("The number of rounds is %d\n", round);

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% take a cyle ( a list of nodes in the cycle)
function retval = labelCycle(acycle)
    global numF;
    len = length(acycle);
    if len == 0
        retval = [];
    else
        retval = acycle;
        if (acycle(1) > numF)   % start with a locality
            retval(1) = acyle(len);
            retval(2:len) = acycle(1:len-1);
        end 
    end
end

% Check if a cycle is feasible or not 
function bol = isFeasibleCycle(acyc, currMatch)
    global numF; 
    n = length(acyc);
    % Sanity check 
    if (rem(n,2) == 1)
        fprintf("EROOR: not an even lenght cycle\n");
    end
    
    bol = true;

    acyc(n+1) = acyc(1);
    % Asumming it is even
    acyc = labelCycle(acyc);
    
    for j = 1:1:floor(n/2)
        lj = acyc(2*j) - numF;
        fj = acyc(2*j-1);
        G = transpose(currMatch(:, lj) >= 1); % !!!!!!  Need to check this
        G(acyc(2*j+1)) = 0;          % Removing family f_{j+1}
        
        if ~isAccommodateAlongside(lj, fj, G)
            %fprintf("!!!!!!!!!!!!!!!!!!!!!! Found infeasible\n");
            bol = false;
            break;
        end
    end
end


% Takes a list of cycles, remove all the cycles that are not feasible 
function cycles = getFeasibleCycles(cycles, currMatch)
    len = length(cycles);
    if (len == 0)
        fprintf("CheckFeasibleCycles: input an empty list\n");
    end
    
    inds = zeros(1, len);
    
    for i = 1:len
        if isFeasibleCycle(cycles{i}, currMatch)
            inds(i) = 1;
        end
    end
    
    % Remove infeasible cycles
    cycles(inds == 0) = [];
end  
    

% A function that checks whether a locality l can accommodate a set 
% of families G or not. Note that G is an indicator vector (logical array)
% of length numF. 
function bol = isAbleToAccommodate(l,G)
    global NU KAPPA;
    bol = all(sum(NU(:, G),2) <= KAPPA(:, l));
end

% A function that checks whether a locality l can accommodate a famimily f 
% along side a set of families G or not.
function bol = isAccommodateAlongside(l, f, G)
    % add family f to set of families G
    G(f) = 1;
    bol = isAbleToAccommodate(l,G);
end

% A function that permanently rejects families that 
% locality l cannot accommodate along side the current match currMatch.
% @ currMatch: a binary matrix of size numF by numL, 1 means matched and
% 0 means unmatched. 
function currMatch = aLocalityPermanentlyReject(l, currMatch)
    global numF;
    % get the set of families that are permanently matched to locality l
    G = transpose(currMatch(:, l) == 1);
    
    for f = 1:numF
        if(currMatch(f, l) ~= -1)
            if (G(f) == 0) % family f still available
                % If locality l cannot accommodate family f alongside G
                if ~isAccommodateAlongside(l, f, G)
                    %fprintf("Locality %d permanently rejects family %d\n", l, f);
                    % Permanently rejects that family
                    currMatch(f, l) = -1;
                end
            end
        end
    end
end

% A function that iterates over all locality and permanently rejects all
% families that the locality cannot accommodate alongside the currMatch
function currMatch = permanentlyReject(currMatch)
    global numL;
    
    for l = 1:numL
        currMatch = aLocalityPermanentlyReject(l, currMatch);
    end
end

% Checks if family f is permanently matched to some locality  
function bol = isPermanentlyMatched(f)
    global FamPerMatch;
    bol = FamPerMatch(f);
    %bol = ~isempty(currMatch(f, :) == 1);
end


% Finds the highest-priority family that has not been permanently matched 
% and that l has not permanently rejected. If no such family exists, then
% returns -1
function fam = findHighestPriority(l, currMatch)
    global LocPri FamPerMatch;
    
    % Get a list of families that have been permanently rejected by l
    fpr = currMatch(:,l) == -1;
    
    % Get a list of famimilies that either have been permanently rejected
    % by l or have been permanently matched 
    temp = fpr | FamPerMatch;
    
    % Get the prirorities of locality l
    lp = LocPri(:, l);
    
    % Ignore priorities of families in temp by setting it to -1
    lp(temp) = -1;
    
    % Now find the highest priority family
    [maxval, fam] = max(lp);
    
    % If no such family exists, return -1
    if (maxval < 1)
        fam = -1;
    end
    %fprintf("The highest priority of locality %d is family %d\n", l, fam);
end

% Construct a graph (a square adjacency matrix numF+numL) such that every 
% family f that is not is not permanently matched points at its most 
% preferred locality among those that have not permanently rejected f. 
% Every locality l points at the highest-priority family that has not been 
% permanently matched and that l has not permanently rejected. If no such 
% family exists, then l does not point.
function G = constructGraph(currMatch)
    global numF numL;
    nodeIDs = cell(1, numF + numL);
    for i = 1:numF+numL
        if (i <= numF)
            nodeIDs{i} = strcat('Fam-', ' ', int2str(i));
        else
            nodeIDs{i} = strcat('Loc-', ' ', int2str(i-numF));
        end
    end
    
    % initialize the graph G with convention that 1,2,..., numF represents 
    % families and numF+1, ..., numF+numL represents localities 
    G = zeros(numF + numL);
    
    % Iterate over families to add edges to the graph
    for f = 1:numF
        if ~isPermanentlyMatched(f)
            loc = findMostPreferred(f, currMatch);
            
            if (loc >= 1)   % Found a valid locality 
                G(f, loc + numF) = 1; % family f points to locality loc
            end
        end
    end
    
    % Next, iterate over localities to add edges to the graph
    for l = 1: numL
        fam = findHighestPriority(l, currMatch);
        if (fam >= 1)       % Found a valid family 
            % Locality l points to highest-priority family 
            G(l + numF, fam) = 1;  
        end
    end
    
    %view(biograph(G, nodeIDs));
    % Convert G to a sparse array
    G = sparse(G);
end

% Takes a fammily f and a graph G, returns the locality that f is pointing 
function loc = pointingAtWhich(f, G)
    global numF;
    loc = find (G(f, :) == 1); 
    if isempty(loc)
        loc = -1;
    elseif (length(loc) > 1)
        fprintf("ERROR: Family %d pointing to more than one locality\n", f);
        full(G)
    elseif (loc <= numF)
        fprintf("ERROR: Family %d pointing to another family %d\n", f, loc);
    else
        loc = loc - numF; % offset by numF
    end 
end

% 
function newMatch = updateMatchingUtil(acyc, G, currMatch)
    global numF FamPerMatch;
    newMatch = currMatch;
    
    % Sanity check
    if isChainImprovement(acyc)
        %fprintf("Sanity check passed: chain-improvement!!!!!!!!!\n");
    else
        fprintf("Sanity check failed: not chain-improvement!!!!!!!!!\n");
    end
    
    for i = 1: length(acyc)
        f = acyc(i);
        if ((f >= 1) && (f <= numF))% Found a family in the cycle
            % Permanently match family f to the locality at which it is
            % pointing
            loc = pointingAtWhich(f,G); 
            if (loc >= 1)
                newMatch(f, loc) = 1;
                fprintf("Match family %d to locality %d\n", f, loc);
                % Also update that f has been permanently matched
                FamPerMatch(f) = 1;
                
                % Also left the endowment 
                inds = newMatch(f, :) == 2;
                newMatch(f, inds) = 0;
                %fprintf("Endowment: Family %d has left locality %d\n", f, find(inds == 1));
            end
        end
    end     
end

%
function newMatch = updateMatching(cycles, G, currMatch)
    newMatch = currMatch;
    for i = 1:length(cycles)
        newMatch = updateMatchingUtil(cycles{i}, G, newMatch);
    end
end

% Basically this work like updateMatching in MTTC. The only different is
% that we need to remove in-feasible cylces. So the parameter 'cycles'
% should contain feasible cycles only. 
%
function Matching = matchingStage(cycles, G, Matching)
    %fprintf("**** ENTERING MATCHING STAGE ******\n");
    Matching = updateMatching(cycles, G, Matching);
end


% Rejection Stage Function 
function [f, fpointingto, picked, newMatch] = rejectionStage(currMatch, G, picked, sorted)
    %fprintf("*****ENTERING REJECTION STAGE ******\n");
    global numL numF;
    % Pick one family f (at random or according to some exogenous rule) 
    % at whom at least one locality is pointing
    %[f, picked] = pickRandomFamily(picked,  G);
    
    %% Pick by size
    [f,picked] = pickBySize(picked, G, sorted);
    %bol = false;
    newMatch = currMatch;
    
    % find the locality at whom family f is poting at 
    fpointingto = find(G(f, :) == 1); 
    if (length(fpointingto) > 1)
        fprintf("++++++ ERROR: family %d not pointing to exactly one locality\n", f);
    end

    fpointingto = fpointingto - numF;
    
    %fprintf("Family %d is pointing to locality %d\n", f, fpointingto);
    
    for l = 1:numL
        if (currMatch(f, l) ~= -1)
            alongside = currMatch(:, l) >= 1;
            fprime = find (G(l + numF, :) == 1);

            if (length(fprime) > 1)
                fprintf("++++++ ERROR: locality %d not pointing to exactly one family\n", l);
            end

            alongside(fprime) = 0;  % Exclude fprime family 
            % Permanently reject f from all localities to which f cannot be matched
            %display(f);
            %display(l);
            %display(alongside);
            if ~isAccommodateAlongside(l, f, alongside)
                %fprintf("RS: Locality %d permanently rejects family %d\n", l, f);
                newMatch(f, l) = -1; %Permanently rejects 

                %if (l == fpointingto)
                %   fprintf("Family %d is permanently rejected by the locality at which it is pointing\n", f);
                %   bol = true;
                %end
            end
        end
    end

end

% Sort by family size, randomly breaking tie 
function sorted = sortBySize(type)
    global NU;
    if (type == 1)
        [~, temp] = sort(NU);
    else
        [~, temp] = sort(NU, 'descend');
    end
    
    % Count number of ties 
    len = max(NU);
    count = zeros(1, len);
    
    for i = 1:len
        count(i) = sum(NU == i);
    end
    
    % Randomly shuffle
    sorted = temp;
    cumcount = cumsum(count);
    cumcount = [0, cumcount];
    for i = 1:len
        si = cumcount(i)+1;
        ei = cumcount(i+1);
        sorted(si:ei) = shuffle(sorted(si:ei));
    end
    display(sorted);
end

function v = shuffle(v)
    v=v(randperm(length(v)));
end

% pick by family size: either small to large or vice versa
function [fam, picked] = pickBySize(picked, G, sorted)
    i = 1; 
    
    while true
        %f = randi(numF);
        f = sorted(i);
        % at least one locality is pointing at
        alolipa = length(find(G(:, f) == 1)) >= 1;
        if (~picked(f) && alolipa)
            fprintf("Pick a family %d at whom at least one locality is pointing\n", f);
            fam = f;
            % Update that family f is picked
            picked(f) = 1;
            break;
        end
        
        
        
        i= i+1;
    end
end

% 
function [fam, picked] = pickRandomFamily(picked, G)

    global numF;
    
    while true
        f = randi(numF);
        
        % at least one locality is pointing at
        alolipa = length(find(G(:, f) == 1)) >= 1;
        if (~picked(f) && alolipa)
            %fprintf("Randomly pick a family %d at whom at least one locality is pointing\n", f);
            fam = f;
            break;
        end
        
        % Update that family f is picked
        picked(f) = 1;
    end
end

