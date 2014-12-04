function [ center1, center2, transConst1, transConst2 ] = centerToEdge(puzzlePieces)
%pulling list of four vertices for each puzzle piece.
Piece1 = puzzlePieces{:,1};
Piece2 = puzzlePieces{:,2};
x1posTot = 0;
x2posTot = 0;
y1posTot = 0;
y2posTot = 0;
%Use midpoint theorem to find center of square
%begin for piece 1
for callCorner = 1:1:length(Piece1(:,1))
    x1posTot = x1posTot + Piece1(callCorner, 1);
    x2posTot = x2posTot + Piece2(callCorner, 1);
    y1posTot = y1posTot + Piece1(callCorner, 2);
    y2posTot = y2posTot + Piece2(callCorner, 2);
end
    centerx1 = x1posTot/4;
    centery1 = y1posTot/4;
    centerx2 = x2posTot/4;
    centery2 = y2posTot/4;
    
    center1 = [centerx1,centery1];
    
    center2 = [centerx2, centery2];
   
   %middle points
   midCenter1Xpos = (Piece1(1,1)+Piece1(2,1))/2;
   midCenter2Xpos = (Piece2(1,1)+Piece2(2,1))/2;
   midCenter1Ypos = (Piece1(1,2)+Piece1(2,2))/2;
   midCenter2Ypos = (Piece2(1,2)+Piece2(2,2))/2;
   
   %get translational constant
   transConst1 = sqrt(((centerx1-midCenter1Xpos)^2) - ((centery1 - midCenter1Ypos)^2));
   transConst2 = sqrt(((centerx2 - midCenter2Xpos)^2)-((centery2 - midCenter2Ypos)^2));
   
end