function [ PuzzlePieces ] = extractEdges( edgePhoto )
%EXTRACTEDGES Summary of this function goes here
%   Detailed explanation goes here
h = fspecial('prewitt');
g = imfilter(edgePhoto, h); 
C = corner(g,10);
imshow(g);
hold on;

rC = [];
for i=1:size(C)
    cornerOne = [C(i,1),C(i,2)];
    add = true;
    for j=1:size(C)
        if(i~=j)
            cornerTwo = [C(j,1),C(j,2)];
            if(distance(cornerOne,cornerTwo)<10)
                add = false;
            end
        end
    end
    if(add)
        rC(end+1,1) = cornerOne(1);
        rC(end,2) = cornerOne(2);
    end
end

plot(rC(:,1), rC(:,2), 'g*');

PieceOne = {};
PieceTwo = {};

for i=1:size(rC)
    if(i==1)
        PieceOne{end+1} = {rC(i,1),rC(i,2)};
        
    else if(distance([rC(1,1),rC(1,2)], [rC(i,1),rC(i,2)])<200)
        PieceOne{end+1} = {rC(i,1),rC(i,2)};
    else
        PieceTwo{end+1} = {rC(i,1),rC(i,2)};
    end
    end
end
    
size1 = size(PieceOne);
size2 = size(PieceTwo);

for i=1:size1(2)
    hold on;
    pair = PieceOne{i};
    plot(pair{1,1},pair{1,2}, 'b*');
end

for i=1:size2(2)
    hold on;
    pair = PieceTwo{i};
    plot(pair{1,1},pair{1,2}, 'r*');
end
PuzzlePieces = {PieceOne,PieceTwo};

end

