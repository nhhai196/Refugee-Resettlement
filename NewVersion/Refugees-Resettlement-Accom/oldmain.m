%%%%%%%%%%%%%%%%%%%%%%% MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global numF numL numS KAPPA NU FamPref LocPri EW COMP Matching infinity;
%Initialize global variables for MTTC
% fsfile = "testcases/mttc/family-size.xlsx";
% lcfile = "testcases/mttc/locality-capacity.xlsx";
% ewfile = "testcases/mttc/employment-weight.xlsx";
% compfile = "testcases/mttc/compatibility.xlsx";

% fsfile = "Data/FY17_size.xlsx";
% lcfile = "Data/FY17_cap.xlsx";
% ewfile = "Data/FY17_Employment_weight.xlsx";
% compfile = "Data/FY17_Compatibility.xlsx";
% 
% global numF numL numS KAPPA NU FamPref LocPri EW COMP Matching;
% global FamPerMatch;
% 
% initGlobalVariablesforData(fsfile, lcfile, ewfile, compfile);
% FamPerMatch = zeros(numF, 1);
% 
% % Run MTTC algorithm
% mttc();


%Initialize global variables for CMDA
% fsfile = "testcases/cmda/family-size.xlsx";
% lcfile = "testcases/cmda/locality-capacity.xlsx";
% ewfile = "testcases/cmda/employment-weight.xlsx";
% compfile = "testcases/cmda/compatibility.xlsx";

initGlobalVariables(fsfile, lcfile, ewfile, compfile);

% Run CMDA algorithm
cmda();