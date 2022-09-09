# Refugee-Resettlement

This repository contains all the codes implementing the algorithms in the paper "Matching Mechanisms for Refugee Resettlement". 
There are 2 folders, Refugee-Resettelment for weak accomodate, and Refugee-Resettlement-Accom for accomodate. They are almost the same exepcet the prodcedure implemented in the "weakAccomodate.m". 
  - Folder "Data" contains all the data for simulations. The current program use the data in Data/FY17_size.xlsx, Data/FY17_cap.xlsx, Data/FY17_Employment_weight.xlsx,       Data/FY17_Compatibility.xlsx. 
  
  - main.m is the main program. The program outputs simulation results (store in Excel files).
    Below are some important parameters in the main program. 
      1. dim: the number of constraints/dimensions, usually set it to 1 or 3. 
      2. pickfam: the order to pick family in the MTTCE algorithm, usually set it to 0 (random), 1 (ascending on size), 2 (descending on size)
      
  - The main program runs 4 algorithms:
      1. MTTC implemented in mttc.m 
      2. CDMA implemented in cdma.m 
      3. TMDA implemented in tmda.m
      4. MTTCE implemented in mttce.m
      
  - initGlobalVariablesforData.m: initializes all the global variables from data. 
  
  - employmentBasedEndowment.m: finds the initial endowment based on employment.
  
  - setParameters.m: takes a preference type (1,2,3, or4), and sets the correlation between refugees and localities.  
  
  - genFamPref.m: generates family preference based on the preference type set by setParameters procedure. 
  
  - countStrongEnvies.m, numberOfMatchedFamilies.m, averagePreferenceRank.m, averagePreferenceRankAll.m, cdfPreference.m, cdfPreferenceAll.m, averageUnfilledQuota.m, 
  averageMatchedPriority.m, averagefamsize.m, matchingToEW.m,... are for statistics.
  
  - Other functions like findCyles.m, findMostPreferred.m, getPriority.m,... are sub-procedures for implemeting the 4 alogrithms. They are self-contained with local comments.  
  


