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
%%%%%%%%%%%%%%%%%%%%%%%%% MTTC ALGORITHM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function G = mttc()
    fprintf("Running MTTC algorithm...\n");
    
    global FamPerMatch Matching numF;
    %initGlobalVariables();
    FamPerMatch = zeros(numF, 1);
    resetMatching();
    
    round = 1;  % counter for the number of rounds
    while (~all(FamPerMatch))
        %fprintf("===================== Round %d =========================\n",round);
        Matching = permanentlyReject(Matching);
        G = constructGraph(Matching);
        cycles = findCycles(G);
        if isempty(cycles)
%             for f = 1:10
%                 fprintf("family %d point at %d\n", f, pointingAtWhich(1, G))
%             end
            break;
        end
        
        %display(cycles);
        Matching = updateMatching(cycles, G, Matching);
        round = round + 1;
        % Debug
        %display(FamPerMatch);
        %display(Matching);
        %printMatching(Matching);
    end
    
    
    % Print out the result
    Matching = cleanMatching(Matching);
    %printMatching(Matching);
    
    % Sanity check 
    if isWasteful(Matching)
        fprintf("++++++++++++++++ Something must be wrong\n");
    else
        fprintf("------ Sanity check passed!!!!!\n");
    end
    fprintf("The number of rounds is %d\n", round-1);
    
    fprintf("Done MTTC\n");

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% A function that permanently rejects families that 
% locality l cannot accommodate along side the current match currMatch.
% @ currMatch: a binary matrix of size numF by numL, 1 means matched and
% 0 means unmatched. 
function updatedMatch = aLocalityPermanentlyReject(l, currMatch)
    global numF;
    % get the set of families that are permanently matched to locality l
    G = transpose(currMatch(:, l) == 1);
    
    updatedMatch = currMatch;
    for f = 1:numF
        if (G(f) == 0) % family f still available
            % If locality l cannot accommodate family f alongside G
            if ~isAccommodateAlongside(l, f, G)
                %fprintf("Locality %d permanently rejects family %d\n", l, f);
                % Permanently rejects that family
                updatedMatch(f, l) = -1;
            end
        end
    end
end

% A function that iterates over all locality and permanently rejects all
% families that the locality cannot accommodate alongside the currMatch
function updatedMatch = permanentlyReject(currMatch)
    global numL;
    updatedMatch = currMatch;
    for l = 1:numL
        updatedMatch = aLocalityPermanentlyReject(l, updatedMatch);
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

%%%%%%%%%%%%%%%%% New function %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Finds the highest-priority family that has not been permanently matched
% and pointing to at some locality
% If no such family exists, then returns -1
function fam = newfindHighestPriority(l, G, currMatch)
    global LocPri FamPerMatch;
    
    % Get a list of families that have been permanently rejected by l
    %fpr = currMatch(:,l) == -1;
    
    % Get a list of famimilies that have been permanently matched 
    temp = 0 | FamPerMatch;
    
    % Get the prirorities of locality l
    lp = LocPri(:, l);
    
    % Ignore priorities of families in temp by setting it to -1
    lp(temp) = -1;
    
    % Now find the highest priority family
    count = 0;
    while true
        [maxval, fam] = max(lp);    
        count = count +1;
        if pointingAtWhich(fam, G) > -1
            break;
        else
            lp(fam) = -999;
        end
        if count > length(lp)
            break;
        end
    end
    
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
    %display(nodeIDs);
    
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
        if (fam > 0)       % Found a valid family 
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
    
    for i = 1: length(acyc)
        f = acyc(i);
        if ((f >= 1) && (f <= numF))% Found a family in the cycle
            % Permanently match family f to the locality at which it is
            % pointing
            loc = pointingAtWhich(f,G); 
            if (loc >= 1)
                newMatch(f, loc) = 1;
                %fprintf("Match family %d to locality %d\n", f, loc);
                % Also update that f has been permanently matched
                FamPerMatch(f) = 1;
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


