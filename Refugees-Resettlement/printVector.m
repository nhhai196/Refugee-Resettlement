function printVector(v)
    len = length(v);
    for i = 1: len
        if v(i)
            fprintf("%4d, ", i);
        end
    end
    fprintf("\n");
end