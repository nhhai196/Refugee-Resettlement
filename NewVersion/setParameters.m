function [delta, alpha, beta, gamma] = setParameters(preftype)

    % Correlated between refugees: \beta is large (and others are zero)
    if (preftype == 1)
        delta = 0;
        alpha = 0;
        beta = 1;
        gamma = 0;
    
    % Uncorrelated between refugees and uncorrelated between refugees and 
    % localities: \gamma is large (and others are zero)
    elseif (preftype == 2)
        delta = 0;
        alpha = 0;
        beta = 0;
        gamma = 1;
     
    % Uncorrelated between refugees and correlated between refugees and 
    % localities: \alpha and \delta are large and reasonably similar 
    % (and others are zero) \delta*V_fl+\alpha*W_f dominates   
    elseif(preftype ==3)
        delta = 1;
        alpha = 0;
        beta = 0;
        gamma = 1;
    else % type 4
        delta = 1;
        alpha = 0;
        beta = 1;
        gamma = 0;
        
    end
end
