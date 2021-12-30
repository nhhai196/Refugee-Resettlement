function fp = updateFamPrefMTTCE(fp, endowment)
    global numF;
    
    for f = 1:numF
        l = find(endowment(f, :) == 1);
        if (length(l) == 1)
            % update the preference of f over localities
            lpf = fp(f,:) < fp(f, l);
            fp(f,lpf) = 0;
        elseif (length(l) >= 2)
            fprintf("+++++ ENDOWMENT: Something wrong!!!!\n");
        end
    end 
end