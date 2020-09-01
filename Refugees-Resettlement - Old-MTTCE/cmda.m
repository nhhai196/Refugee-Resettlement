%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%% CMDA ALGORITHM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function cmda()
    fprintf("Running CMDA algorithm...\n");
    global numF numL numS Matching;
    
    %init();
    resetMatching();
    %Matching
    round = 0;
    while true
        round = round + 1;
        %fprintf("++++++++++++++++++ Round = %d ++++++++++++++++\n", round);
        
        % Step 1: Every family proposes to its favorite locality that has not 
        % permanently rejected it yet.
        Matching = familyPropose(Matching);
        %Matching
        
        % Step 2: Every locality tentatively accepts a proposing family if 
        % the locality can weakly accommodate the family alongside all 
        % families with a higher priority that are proposing to or have 
        % been permanently rejected by that locality. Otherwise the 
        % locality permanently rejects the family.
        [flag, Matching] = acceptOrReject(Matching);
        
        %display(Matching);
        
        % Step 3: If no family has been permanently rejected, permanently 
        % match every family to the locality to which the family is 
        % proposing and end. 
        if ~flag
            Matching = permanentlyMatch(Matching);
            %display(Matching);
            break; 
        end 
    end
    
    % Print out the matching
    Matching = cleanMatching(Matching);
    %printMatching(Matching);
    
    %countStrongEnvies(Matching);
    %matchingToEW(Matching);
    fprintf("Done CMDA\n");

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% HELPER FUNCTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% This function might not be needed anymore  
function init()
    global numF numL numS KAPPA NU FamPref LocPri Matching;
    numF = 4;
    numL = 4;
    numS = 1;
    KAPPA = [2, 1, 2, 5];
    NU =[1,2,1,1];
    FamPref= [3, 4, 2, 1;
              4, 1, 3, 2;
              4, 3, 2, 1;
              4, 1, 3, 2];
    
    LocPri = [4, 3, 1, 4;
              3, 1, 3, 3;
              2, 4, 2, 2;
              1, 2, 4, 1];
          
   Matching = zeros(numF, numL);
               
end


% Find all families with a higher priority than family f that are proposing 
% to or have been permanently rejected by locality l. 
function fams = findFamiliesWithHigherPriority(f, l, currMatch)
    global LocPri;
    lpri = LocPri(:, l);
    
%     % Get list of families that are proposing to or have been permanently 
%     % rejected by locality l
    lf = (currMatch(:, l) == 2) | (currMatch(:,l) == -1);
%      
%     proposing = currMatch(:, l) == 2;
%     hpri = lpri > lpri(f); 
%     
%     permrej = currMatch(:, l) == -1;
%     fams = (proposing & hpri) | permrej;  
%     % Ignore the other families
    lpri(~lf) = 0; 
%     
%     % Get families with higher priority than f only 
    fams = lpri > lpri(f);
    
    fams = transpose(fams);         % !!!! Check this
end

% flag if at least one family has been permanently rejected
function [flag, currMatch] = acceptOrReject(currMatch)
    flag = false;
    
    [row, col] = size(currMatch);
    for f = 1: row
        for l = 1: col
            if (currMatch(f, l) == 2)
                fams = findFamiliesWithHigherPriority(f,l, currMatch);
                if (~weaklyAccommodate(f, l, fams))
                    currMatch(f, l) = -1; 
                    flag = true;
                    %fprintf("Locality %d permanently rejected family %d\n", l, f);
                end
            end
        end
    end
end

