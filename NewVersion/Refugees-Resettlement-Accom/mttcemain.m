
%Initialize global variables for MTTC
fsfile = "testcases/mttce/family-size2.xlsx";
lcfile = "testcases/mttce/locality-capacity2.xlsx";
ewfile = "testcases/mttce/employment-weight2.xlsx";
compfile = "testcases/mttce/compatibility2.xlsx";
global numF numL numS KAPPA NU FamPref LocPri EW COMP Matching;
global FamPerMatch;

initGlobalVariables(fsfile, lcfile, ewfile, compfile);
FamPerMatch = zeros(numF, 1);

% Init endowment
currMatch = zeros(numF, numL);

currMatch(1,2) = 1;
currMatch(2,2) = 1;
currMatch(3,3) = 1;
currMatch(4,4) = 1;


% Run MTTCE algorithm 
mttce(currMatch);

