function FP = genFamPref(delta, alpha, beta, gamma)
    global numF numL W Y E U COMP;
    FP = zeros(numF, numL);
    
    % 
    [V, W, Y, E] = genTerms();

    U = computeUtilities(delta, alpha, beta, gamma, V, W, Y, E);
    
    % the higher value of utility, the more preferred
    for f = 1:numF
        [~, FP(f, :)] = sort(U(f, :), 'descend');
    end
    
    FP(~COMP) = 0;
end


function [V, W, Y, E] = genTerms()
    global EW numF numL;
    V = EW;
    W = rand(1, numF);
    Y = rand(1, numL);
    E = rand(numF, numL);
    
end


function U = computeUtilities(delta, alpha, beta, gamma, V, W, Y, E)
    global numF numL;
    U = zeros(numF, numL);
    for f = 1:numF
        for l = 1:numL
            U(f,l) = delta*V(f,l) + alpha*W(f) + beta*Y(l) + gamma*E(f,l);
        end
    end
    
    % set non-compatibale to zero
    %U(~COMP) = 0;
end
