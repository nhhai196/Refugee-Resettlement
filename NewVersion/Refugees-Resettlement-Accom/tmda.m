%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% TMDA ALGORITHM %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tmda()
    fprintf("Running TMDA algorithm...\n");
    global numF numL numS KAPPA NU FamPref LocPri Matching infinity;
    
    %init(); 
    resetMatching();
    round = 0;
    while true
        round = round + 1;
        %fprintf("**********************************  TMDA - Round %d *****************************************\n", round);
        %fprintf("++++++++++++++++++ Round = %d ++++++++++++++++\n", round);
        % Step 1: Every family proposes to its favorite locality that has not 
        % permanently rejected it yet.
        Matching = familyPropose(Matching);
        
        
        % Every locality l permanently rejects any proposing family f if f’s 
        % priority rank among all families that are proposing to l is 
        % strictly greater than f’s threshold at l  
        PI = Matching == 2;
        theta = thresholdCalculator(LocPri, PI);
        %fprintf("\n");
        %printTheta(theta);
        %fprintf("*********************************************************************************************\n");
        [flag, Matching] = permanentlyReject(Matching, theta, LocPri);
        
        % Step 3: If no family has been permanently rejected, permanently 
        % match every family to the locality to which the family is 
        % proposing and end. 
        if ~flag
            Matching = permanentlyMatch(Matching);
            %display(Matching);
            break; 
        end 
        
        %if round >1
        %   break;
        %end
    end
    
    % Print out the matching
    Matching = cleanMatching(Matching);
    %printMatching(Matching);
    fprintf("Done TMDA\n");
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%
function init()
    global numF numL numS KAPPA NU FamPref LocPri Matching infinity;
    numF = 7;
    numL = 4;
    numS = 2;
    KAPPA = [4 4 3 1;
             2 1 1 0];
    NU = [2 1 1 2 1 1 1;
          1 0 0 0 1 0 0];
    FamPref= [2, 4, 3, 1;
              3, 2, 1, 4;
              3, 4, 2, 1;
              4, 1, 3, 2;
              4, 3, 2, 1;
              4, 3, 2, 1;
              1, 2, 3, 4];
    
    LocPri = [7, 6, 5, 4;
              6, 5, 4, 6;
              5, 2, 3, 2;
              4, 1, 7, 1;
              3, 7, 2, 3;
              2, 3, 6, 5;
              1, 4, 1, 7];
          
   Matching = zeros(numF, numL);
   infinity = 1000;
end
% 
function [flag, currMatch] = permanentlyReject(currMatch, theta, LP)
    [row, col] = size(currMatch);
    flag = false;
    
    for f = 1: row
        for l = 1: col
            if (currMatch(f, l) == 2)
                rank = priorityRankAmongProposers(f, l, currMatch, LP);
                if rank > theta(f,l)
                    % Permanently rejects
                    currMatch(f, l) = -1;
                    %fprintf("Locality %d permanently rejected family %d\n", l, f);
                    flag = true;
                end
            end
        end
    end
end


% 
function rank = priorityRankAmongProposers(f, l, currMatch, LP)
    proposers = currMatch(:, l) == 2;
    rank = length(find(LP(proposers, l) >  LP(f, l))) + 1;
end