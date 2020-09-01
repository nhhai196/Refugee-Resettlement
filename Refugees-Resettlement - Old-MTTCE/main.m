%%%%%%%%%%%%%%%%%%%%%%% MAIN PROGRAM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear, clc;
global numF numL numFL numSL numS KAPPA NU FamPref LocPri EW COMP Matching ;
global FamPerMatch infinity A b W Y E U endowment;

tic

fsfile = "Data/FY17_size.xlsx";
lcfile = "Data/FY17_cap.xlsx";
ewfile = "Data/FY17_Employment_weight.xlsx";
compfile = "Data/FY17_Compatibility.xlsx";

%Initialize global variables for CMDA
% fsfile = "testcases/cmda/family-size.xlsx";
% lcfile = "testcases/cmda/locality-capacity.xlsx";
% ewfile = "testcases/cmda/employment-weight.xlsx";
% compfile = "testcases/cmda/compatibility.xlsx";

% 

initGlobalVariablesforData(fsfile, lcfile, ewfile, compfile);

for r = 1:1
% Set up
loops = 100;
preftype = 4;
envy = zeros(loops, 4);
nummatched = zeros(loops, 4);
avgprefrank = zeros(loops, 4);
avgprefrankall = zeros(loops, 4);

cdfpref = zeros(4, numL, loops);
cdfprefall = zeros(4, numL+1, loops);
avgunfilled = zeros(loops, 4);
totemp = zeros(loops, 4);

strictlybetter = zeros(loops, 1);
totemp_diff = zeros(loops, 1);

CurrMatches = zeros(numF, numL, 4); 

% Set parameters for preftype 
[delta, alpha, beta, gamma] = setParameters(preftype);

% Employment-based endowment for MTTCE 
[endowment, val] = employmentBasedEndowment();
%val = 77.75;
%endowment = xlsread('endowment.xlsx');
%[endowment, val] = randomEndowment();

endowment = round(endowment);

% if isWasteful(endowment)
%     fprintf("++++++++++ The endowment is wasteful\n");
% else
%     fprintf("++++++++++ The endowment is non-wasteful\n");
% end

for i = 1:loops
    fprintf("Round = %d\n", i);
    % First generate family preferences
    FamPref = genFamPref(delta, alpha, beta, gamma);
    
%     % Run MTTC algorithm
%     mttc();
%     CurrMatches(:,:,1) = Matching;
%     
%     % Run CMDA algorithm 
%     cmda();
%     CurrMatches(:,:, 2) = Matching;
% 
%     % Run TMDA algorithn
%     tmda();
%     CurrMatches(:,:, 3) = Matching;
% 
% 
% 
% 
%     %% Statistics
%     for j = 1:3
% 
%         temp = CurrMatches(:, :, j); 
%         % Envy
%         
%         envy(i, j) = countStrongEnvies(temp);
%         
%         % Efficiency
%         nummatched(i,j) = numberOfMatchedFamilies(temp);
%         avgprefrank(i,j) = averagePreferenceRank(temp, FamPref);
%         avgprefrankall(i,j) = averagePreferenceRankAll(temp, FamPref);
%         cdfpref(j,:,i) = cdfPreference(temp, FamPref);
%         cdfprefall(j,:,i) = cdfPreferenceAll(temp, FamPref);
%         avgunfilled(i,j) = averageUnfilledQuota(temp);
%         
%         % Total Employment
%         totemp(i, j) = matchingToEW(temp);
%     end
    
    % Run MTTCE algorithm 
    FamPref = updateFamPrefMTTCE(FamPref, endowment);
    mttce(endowment);
    CurrMatches(:,:, 4) = Matching;
    
    % Sannity check 
    if isParetoImprovement(Matching)
        fprintf("Sanity check passed: Pareto-improvemnt!!!!\n");
    else
        fprintf("Sanity check failed: not Pareto-improvement !!!!!!!!!\n");
    end
    
    j = 4;
    temp = CurrMatches(:, :, j); 
    % Envy

    envy(i, j) = countStrongEnvies(temp);

    % Efficiency
    nummatched(i,j) = numberOfMatchedFamilies(temp);
    avgprefrank(i,j) = averagePreferenceRank(temp, FamPref);
    avgprefrankall(i,j) = averagePreferenceRankAll(temp, FamPref);
    cdfpref(j,:,i) = cdfPreference(temp, FamPref);
    cdfprefall(j,:,i) = cdfPreferenceAll(temp, FamPref);
    avgunfilled(i,j) = averageUnfilledQuota(temp);

    % Total Employment
    totemp(i, j) = matchingToEW(temp);
    
    % For MTTCE
    strictlybetter(i) = countBetterOff(CurrMatches(:,:,4), endowment);
    totemp_diff(i) = totemp(i,4) - val; 

%     if envy(i,j) > 0
%         break;
%     end
end

%% Report 

% Mean
mean_avgprefrank = round(mean(avgprefrank), 3);
mean_avgprefrankall = round(mean(avgprefrankall), 3);
mean_avgunfilled = round(mean(avgunfilled), 3);
mean_cdfpref = round(mean(cdfpref, 3), 3);
mean_cdfprefall = round(mean(cdfprefall, 3), 3);
mean_envy = round(mean(envy), 3);
mean_nummatched = round(mean(nummatched), 3);
mean_strcitlybetter = round(mean(strictlybetter), 3);
mean_totemp = round(mean(totemp), 3);
mean_totemp_diff = round(mean(totemp_diff), 3);

% Standard deviation

std_avgprefrank = round(std(avgprefrank), 3);
std_avgprefrankall = round(std(avgprefrankall), 3);
std_avgunfilled = round(std(avgunfilled), 3);
%std_cdfpref = std(cdfpref, 3);
std_envy = round(std(envy), 3);
std_nummatched = round(std(nummatched), 3);
std_strcitlybetter = round(std(strictlybetter), 3);
std_totemp = round(std(totemp), 3);
std_totemp_diff = round(std(totemp_diff), 3);


fprintf("DONE\n");

%% Store statistics to file
% file name
endowtype = 'OPT';
prefname = 'type';
filename = strcat('one-dim-large-to-small', prefname, '-', int2str(preftype), '-', endowtype,'-', int2str(r), '.xlsx' );
sheet = 1;
xlRange = 'A1';
xlswrite(filename, {'mean number of strong envy violations'}, sheet, xlRange);
xlRange = 'A2';
xlswrite(filename, mean_envy, sheet, xlRange);

xlRange = 'A4';
xlswrite(filename, {'mean number of matched families'}, sheet, xlRange);
xlRange = 'A5';
xlswrite(filename, mean_nummatched, sheet, xlRange);

xlRange = 'A7';
xlswrite(filename, {'mean average pref rank'}, sheet, xlRange);
xlRange = 'A8';
xlswrite(filename, mean_avgprefrank, sheet, xlRange);

xlRange = 'A10';
xlswrite(filename, {'mean average pref rank all'}, sheet, xlRange);
xlRange = 'A11';
xlswrite(filename, mean_avgprefrankall, sheet, xlRange);


xlRange = 'A13';
xlswrite(filename, {'mean average fracion of unfilled quota'}, sheet, xlRange);
xlRange = 'A14';
xlswrite(filename, mean_avgunfilled, sheet, xlRange);


xlRange = 'A16';
xlswrite(filename, {'mean total employment'}, sheet, xlRange);
xlRange = 'A17';
xlswrite(filename, mean_totemp, sheet, xlRange);


xlRange = 'A16';
xlswrite(filename, {'mean cdf pref'}, sheet, xlRange);
xlRange = 'A17';
xlswrite(filename, mean_cdfpref, sheet, xlRange);

xlRange = 'A22';
xlswrite(filename, {'mean cdf pref all'}, sheet, xlRange);
xlRange = 'A23';
xlswrite(filename, mean_cdfprefall, sheet, xlRange);

xlRange = 'F1';
xlswrite(filename, {'std number of strong envy violations'}, sheet, xlRange);
xlRange = 'F2';
xlswrite(filename, std_envy, sheet, xlRange);

xlRange = 'F4';
xlswrite(filename, {'std number of matched families'}, sheet, xlRange);
xlRange = 'F5';
xlswrite(filename, std_nummatched, sheet, xlRange);

xlRange = 'F7';
xlswrite(filename, {'std average pref rank'}, sheet, xlRange);
xlRange = 'F8';
xlswrite(filename, std_avgprefrank, sheet, xlRange);

xlRange = 'F10';
xlswrite(filename, {'std average pref rank all'}, sheet, xlRange);
xlRange = 'F11';
xlswrite(filename, std_avgprefrankall, sheet, xlRange);



xlRange = 'F113';
xlswrite(filename, {'std average fracion of unfilled quota'}, sheet, xlRange);
xlRange = 'F14';
xlswrite(filename, std_avgunfilled, sheet, xlRange);


xlRange = 'F16';
xlswrite(filename, {'std total employment'}, sheet, xlRange);
xlRange = 'F17';
xlswrite(filename, std_totemp, sheet, xlRange);


% MTTCE
xlRange = 'A28';
xlswrite(filename, {'Unique for MTTCE'}, sheet, xlRange);

xlRange = 'A29';
xlswrite(filename, {'mean num of families stricly better off'}, sheet, xlRange);
xlRange = 'A30';
xlswrite(filename, mean_strcitlybetter, sheet, xlRange);

xlRange = 'A32';
xlswrite(filename, {'mean change in total employment'}, sheet, xlRange);
xlRange = 'A33';
xlswrite(filename, mean_totemp_diff, sheet, xlRange);

xlRange = 'F29';
xlswrite(filename, {'std num of families strictly better off'}, sheet, xlRange);
xlRange = 'F30';
xlswrite(filename, std_strcitlybetter, sheet, xlRange);

xlRange = 'F32';
xlswrite(filename, {'std change in total employment'}, sheet, xlRange);
xlRange = 'F33';
xlswrite(filename, std_totemp_diff, sheet, xlRange);

% Save endowment
sheet = 2;
xlRange = 'A1';
xlswrite(filename, {'endowment'}, sheet, xlRange);
xlRange = 'A2';
xlswrite(filename, endowment, sheet, xlRange);
end
toc


