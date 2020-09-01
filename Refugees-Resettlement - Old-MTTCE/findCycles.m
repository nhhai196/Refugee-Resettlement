%G =sparse([0,1,0; 1,0,0;0,0,0]);
%view(biograph(G));
%paths = findcycles(G);

%for i= 1: length(paths)
%    display (paths{i})
%end


function pathCell = findcycles(G)
numNodes = size(G,1); 
pathCell = {};
for n = 1:numNodes
   [D,P]=graphtraverse(G,n);
   for d = D
       if G(d,n)
           pathCell{end+1} = graphpred2path(P,d);
       end
   end
   G(n,:)=0; 
end

%fprintf("Found %d cycle(s)\n", length(pathCell));
end