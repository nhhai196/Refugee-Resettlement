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
                    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
% Initialize global variables
function initGlobalVariablesforData(famCap, locCap, ew, comp, dim)
    global numF numL numS numSL numFL KAPPA NU LocPri EW COMP Matching A b;
    global FamPerMatch infinity;
    
    if (dim == 1)
        % one dimension
        NU = transpose(xlsread(famCap, 'E2:E330'));
        KAPPA = transpose(xlsread(locCap, 'F2:F21'));
        
%         NU = transpose(xlsread(famCap, 'E2:E330'));
%         KAPPA = transpose(xlsread(locCap, 'F2:F21'));
    else
        NU = transpose(xlsread(famCap, 'B2:D330'));
        KAPPA = transpose(xlsread(locCap, 'C2:E21'));
%         NU = transpose(xlsread(famCap, 'B2:D10'));
%         KAPPA = transpose(xlsread(locCap, 'C2:E4'));
    end
        
    [numS, numF] = size(NU);
    [~, numL] = size(KAPPA);
    numSL = numS * numL;
    numFL = numF * numL;
    
    EW = xlsread(ew, 'B2:U330');
%     EW = xlsread(ew, 'B2:D10');
    % Normalize the employment weight
    p = max(max(EW));
    EW = EW/p;
    
    % Convention: 1 means compatible, 0 means non-compatible
    COMP = xlsread(comp, 'B2:U330');
%     COMP = xlsread(comp, 'B2:D10');
    % Update the compatibility: if a locality l can't accommodate a family
    % f, then they are not compatible
    for f = 1:numF
        for l = 1:numL
            if COMP(f,l)
                if ~weaklyAccommodate(f, l, false(1,numF))
                    COMP(f,l) = false;
                end
            end
        end
    end
    
    %FamPref = generateFamilyPreferrence(EW, COMP);
    LocPri = generateLocalityPriority(EW, COMP);
    
    
    Matching = zeros(numF, numL);
    FamPerMatch = zeros(numF, 1);
    infinity = 1000;
    
    % Init A, b
    tempb = reshape(KAPPA, numSL, 1);
    
    % Construct the RHS bound
    b = zeros(numSL + numF,1);
    b(1:numSL) = tempb;
    b(numSL+1:numSL+numF) = ones(numF, 1);
    
    % Construct the cosntraint matrix
    tempA = NU;
    for l = 1:(numL-1)
        tempA = blkdiag(tempA, NU);
    end
    
    A = zeros(numSL+numF, numFL);
    A(1:numSL, :) = tempA;

    A(numSL+1:numSL+numF, :) = repmat(eye(numF), 1, numL);
end