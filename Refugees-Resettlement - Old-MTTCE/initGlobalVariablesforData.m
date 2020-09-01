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
function initGlobalVariablesforData(famCap, locCap, ew, comp)
    global numF numL numS numSL numFL KAPPA NU LocPri EW COMP Matching;
    global FamPerMatch infinity;
    
    %NU = transpose(xlsread(famCap, 'B2:D330'));
    % one dimension
    NU = transpose(xlsread(famCap, 'E2:E330'));
    [numS, numF] = size(NU);
    

    %KAPPA = transpose(xlsread(locCap, 'C2:E21'));
    % one dimension
    KAPPA = transpose(xlsread(locCap, 'F2:F21'));
    [~, numL] = size(KAPPA);
    
    numSL = numS * numL;
    numFL = numF * numL;
    
    EW = xlsread(ew, 'B2:U330');
    % Normalize the employment weight
    p = max(max(EW));
    EW = EW/p;
    
    % Convention: 1 means compatible, 0 means non-compatible
    COMP = xlsread(comp, 'B2:U330');
    
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
end