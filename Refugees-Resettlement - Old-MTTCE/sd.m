A = [1/3, 1/6; 1/4 1/4];
B = [1/6, 1/3; 1/3, 1/6];
s = staticaldistance(A,B)

tensor(A)
staticaldistance(tensor(A), tensor(B))

C = zeros(2,2);
get(C)
function C = get(C)
    C(1,1) = 2;
end

function val = staticaldistance(A,B)
    val = sum(sum(abs(A-B)));
end

function val = tensor(A)
    val = [A(1,1) * A, A(1,2) * A; 
           A(2,1) * A, A(2,2) * A];
end