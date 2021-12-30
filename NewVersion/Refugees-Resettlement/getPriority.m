function val = getPriority(f, l, LP)
    temp = LP(:,l);
    order = sort(temp, 'descend');
    if LP(f,l)> 0 
       val = find(order == LP(f,l));
    else
        fprintf("+++++ Something wrong\n");
    end
end