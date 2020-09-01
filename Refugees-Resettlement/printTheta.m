function printTheta(theta)
    global KAPPA NU;
    [row, col] = size(theta);
    [s, ~] = size(KAPPA);
    
    for l = 1:col
        fprintf("l%d   ", l);
        fprintf("(");
        for j = 1:s
            fprintf("%d", KAPPA(j, l));
            if (j < s)
                fprintf(", ")
            end
        end
        fprintf(")");
        fprintf("      t     ");
    end
    fprintf("\n");
    
    for f = 1:col
        fprintf("--------------------   ");
    end
    fprintf("\n");
    
    for f=1:row
        for l = 1:col
            fprintf("f%d   ", f);
            fprintf("(");
            for j = 1:s
                fprintf("%d", NU(j, f));
                if (j < s)
                    fprintf(", ")
                end
            end
            fprintf(")");
            fprintf("   %4d     ", theta(f,l));
        end
        fprintf("\n");
    end
end