% Takes a matrix of employment weights M of size numF by numL and the
% compatibility matrix C.
% Returns a matrix of size numF by numL representing locality priorities
function LP = generateLocalityPriority(M, C)
    global numF numL;
    LP = zeros(numF, numL);
    
    %
    for l = 1:numL
        % the higher value of employment weight, the more preferred
        [~, LP(:, l)] = sort(M(:, l), 'descend');
        
        % Ignore non-compatible families
        % Get the list of non-compatible families
        ncf = C(:, l) == 0; 
        LP(ncf, l) = 0;
    end
    % Override it for now 
    % cmda
%     LP = [4, 3, 1, 4;
%           3, 1, 3, 3;
%           2, 4, 2, 2;
%           1, 2, 4, 1];

    %mttc 
%     LP = [5, 0, 0, 0;
%           0, 0, 5, 0;
%           0, 5, 0, 0;
%           0, 4, 4, 5;
%           0, 0, 0, 4;];
    % mttce
%     LP = [4, 4, 2, 3;
%           3, 3, 1, 2;
%           2, 3, 4, 1;
%           1, 1, 3, 4];
end