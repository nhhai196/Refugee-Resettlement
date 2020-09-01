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
function initGlobalVariables(famCap, locCap, ew, comp)
    global numF numL numS KAPPA NU FamPref LocPri EW COMP Matching;
    NU = xlsread(famCap);
    [numS, numF] = size(NU);
    
    KAPPA = xlsread(locCap);
    [~, numL] = size(KAPPA);
    
    EW = xlsread(ew);
    
    % Convention: 1 means compatible, 0 means non-compatible
    COMP = xlsread(comp);
    
    FamPref = generateFamilyPreferrence(EW, COMP);
    LocPri = generateLocalityPriority(EW, COMP);
    
    
    Matching = zeros(numF, numL);
    
    %numF = 3;
    %numL = 1;
    %numS = 2;
    %KAPPA = [2;1];
    %NU = [2, 1, 0; 0 , 0, 1];
    %FamPref = [1; 1; 1];
    %LocPri = [3;1;2];
%     numF = 5;
%     numL = 4;
%     numS = 2;
%     KAPPA = [3, 3, 3,3; 0, 2, 3, 1];
%     NU =[1,2,0,1,3;0,1,2,1,0];
%     FamPref= [4, 0, 0, 0;
%               0, 4, 0, 0;
%               0, 0, 4, 0;
%               0, 0, 4, 0;
%               0, 4, 0, 3];
%     
%     LocPri = [5, 0, 0, 0;
%               0, 0, 5, 0;
%               0, 5, 0, 0;
%               0, 4, 4, 5;
%               0, 0, 0, 4;]; 
%     Matching = zeros(numF, numL);
%     FamPerMatch = zeros(numF, 1);


end