% Check if locality l can weakly accommodate family f alongside G
function bol = weaklyAccommodate(f, l, G)
    global numS KAPPA NU COMP;
    bol = true;
    comp = COMP(:, l) == 1;
    temp = G & comp;
    if (length(G) ~= length(temp))
        fprintf("========== ERRORRRRRRRRRRRRRRRRRRRRRRR\n");
    end
    
    for s = 1: numS
        if ((NU(s,f)~= 0) && (NU(s, f) + sum(NU(s, G))> KAPPA(s, l)))
            bol = false; 
            %fprintf("%d can't accommodate %d along side %d\n", l, f);
            %printVector(G);
            break;
        end
    end
end
