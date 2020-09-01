%%%%%%%%%%%%%%%%%% Employment-based endowment %%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [sol, val] = employmentBasedEndowment()
    fprintf("Finding optimal solution\n");
    global numF numL numSL numFL NU KAPPA EW A b COMP;
    
    f = -reshape(EW, 1, numFL);
    tempb = reshape(KAPPA, numSL, 1);
    
    % Construct the RHS bound
    b = zeros(numSL + numF,1);
    b(1:numSL) = tempb;
    b(numSL+1:numSL+numF) = ones(numF, 1);
    
    % Construct the cosntraint matrix
    tempA = NU;
    for l = 1:(numL-1)
        tempA = blkdiag(tempA, NU);
    end
    
    A = zeros(numSL+numF, numFL);
    A(1:numSL, :) = tempA;

    A(numSL+1:numSL+numF, :) = repmat(eye(numF), 1, numL);
            
    % integer variables
    intcon = 1:numFL;
    
    % lowerbound 
    lb = zeros(numFL, 1);
    
    % upperbound
    ub = ones(numFL, 1);
    options = optimoptions('intlinprog','Display','iter');
    
    % set non-compatible 
    comp = reshape(COMP, numFL, 1);
    ub(~comp) = 0;
    
    [x, val, ~, ~] = intlinprog(f, intcon, A, b, [], [], lb, ub, options);
    val = round(abs(val), 2);
    sol = reshape(x, numF, numL);
    
    fprintf("Found an optimal solution\n");
end