% Takes a matrix of employment weights M of size numF by numL and the
% compatibility matrix C.
% Returns a matrix of size numF by numL representing family preferences
function FP = generateFamilyPreferrence(M, C)
    global numF numL;
    FP = zeros(numF, numL);
    
    %
    for f = 1:numF
        % the higher value of employment weight, the more preferred
        %[~, FP(f, :)] = sort(M(f, :), 'ascend');
        FP(f, :) =  randperm(numL);
        % Ignore non-compatible localities
        % Get the list of non-compatible localities
        ncl = C(f, :) == 0; 
        FP(f, ncl) = 0;
    end
    % Overide it for now 
    % cmda
%     FP = [3, 4,	2, 1;
%             4, 1, 3,2;
%             4, 3, 2, 1
%             4, 1, 3, 2];

    
    
    % mttc
%     FP = [4, 0, 0, 0;
%           0, 4, 0, 0;
%           0, 0, 4, 0;
%           0, 0, 4, 0;
%           0, 4, 0, 3];
    % mttce
    FP = [3, 2, 4, 1;
          3, 2, 1, 4;
          2, 4, 3, 1;
          2, 4, 1, 3];
end




