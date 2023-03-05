# Refugee-Resettlement

This repository contains the code that implements the algorithms in the paper "Matching Mechanisms for Refugee Resettlement". 
There are two folders: folder "Refugee-Resettelment" handles weak accomodation, and folder "Refugee-Resettlement-Accom" handles accomodation. They are almost identical except for the prodcedure implemented in file weakAccomodate.m. 

  - Folder "Data" contains all the data for simulations. The current program uses the data in Data/FY17_size.xlsx, Data/FY17_cap.xlsx, Data/FY17_Employment_weight.xlsx, Data/FY17_Compatibility.xlsx. 
  
  - main.m is the main program. The program outputs simulation results (stored in Excel files).
  
    Important parameters in the main program:
      1. dim: the number of constraints/dimensions, usually set it to 1 or 3. 
      2. pickfam: the order to pick family in the MTTCE algorithm, usually set it to 0 (random), 1 (ascending on size), 2 (descending on size)
      
  - The main program runs 4 algorithms:
      1. MTTC implemented in mttc.m 
      2. KDA implemented in cdma.m 
      3. TKDA implemented in tmda.m
      4. MTTCE implemented in mttce.m
      
  - initGlobalVariablesforData.m: initializes all the global variables from data. 
  
  - employmentBasedEndowment.m: finds the initial endowment based on employment.
  
  - setParameters.m: takes a preference type 1,2,3, or 4, and sets the correlation between refugees' preferences and localities' priorities.  
  
  - genFamPref.m: generates family preference based on the preference type set by setParameters.m procedure. 
  
  - countStrongEnvies.m, numberOfMatchedFamilies.m, averagePreferenceRank.m, averagePreferenceRankAll.m, cdfPreference.m, cdfPreferenceAll.m, averageUnfilledQuota.m, 
  averageMatchedPriority.m, averagefamsize.m, matchingToEW.m,... generate statistics.
  
  - Other functions, such as findCyles.m, findMostPreferred.m, getPriority.m,... are sub-procedures for implemeting the 4 alogrithms. They are self-contained with local comments.  
  


