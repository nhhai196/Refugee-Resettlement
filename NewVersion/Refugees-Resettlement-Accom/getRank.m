function val = getRank(f, l, FP)
    temp = FP(f, :);
    order = sort(temp, 'descend');
    if FP(f,l)> 0 
       val = find(order == FP(f,l));
    else
        fprintf("+++++ Something wrong\n");
    end
end