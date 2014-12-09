function [ center1, center2, transConst] = centerToEdge(puzzlePieces, pairIndices)
%pulling list of four vertices for each puzzle piece.
Piece1 = puzzlePieces{:,1};
Piece2 = puzzlePieces{:,2};
x1posTot = 0;
x2posTot = 0;
y1posTot = 0;
y2posTot = 0;
size1 = size(Piece1);
size2 = size(Piece2);
corner1 = [];
corner2 = [];

for i=1:size1(2)
    corner = Piece1{i};
    corner1(end+1,1) = corner{1};
    corner1(end, 2)= corner{2};    
end
plot(corner1(:,1), corner1(:,2), 'c+');
for i=1:size2(2)
    corner = Piece2{i};
    corner2(end+1,1) = corner{1};
    corner2(end, 2)= corner{2};    
end
plot(corner2(:,1), corner2(:,2), 'y+');

%Use midpoint theorem to find center of square
%begin for piece 1
x1 = sum(corner1(:,1))/4;
x2 = sum(corner2(:,1))/4;
y1 = sum(corner1(:,2))/4;
y2 = sum(corner2(:,2))/4;

plot(x1,y1, 'c*');
plot(x2,y2, 'y*');

% sizeC1 = size(corner1);
% for callCorner = 1:1:sizeC1(2)
%     x1posTot = x1posTot + corner1(callCorner,1);
%     y1posTot = y1posTot + corner1(callCorner,2);
%     x2posTot = x2posTot + corner2(callCorner,1);
%     y2posTot = y2posTot + corner2(callCorner,2);
% end
%     centerx1 = x1posTot/4;
%     centery1 = y1posTot/4;
%     centerx2 = x2posTot/4;
%     centery2 = y2posTot/4;
    
    center1 = [x1,y1];
    
    center2 = [x2, y2];
    
    transConst = 0; %sqrt(((pairIndices(1,1)-center1(1,1))^2)+(pairIndices(1,2)-center1(1,2))^2);
end