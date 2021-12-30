function bol = isHigherPriority(f1, f2, l)
    global LocPri;
    
    if isempty(f1)
        bol = false;
        return;
    end
    
    if isempty(f2)
        bol = true;
        return;
    end
    
    
    bol = LocPri(f1, l) > LocPri(f2, l);
end