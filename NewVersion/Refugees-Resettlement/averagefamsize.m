function avg = averagefamsize(match)
    global numL NU;
    avg = zeros(1, numL);
    for l = 1:numL 
        temp = NU(match(:, l) == 1);
        if length(temp) > 0
            avg(l) = mean(temp);
        else
            avg(l) = 0;
        end
    end
end