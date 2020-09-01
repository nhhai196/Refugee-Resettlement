function bol = weaklyPrefer(f, l1, l2)
    global FamPref;
    if isempty(l2)
        bol = true;
        return;
    end
    
    if isempty(l1)
        bol = false;
        return;
    end
    bol = FamPref(f, l1) >= FamPref(f, l2);
end