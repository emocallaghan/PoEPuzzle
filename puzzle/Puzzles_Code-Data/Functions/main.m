%this is the main code to run. Starts by using getPhoto() to either pull an
%image from the camera or get a photo from the filepath. getPieces returns
%a cell array the contents of each cell is a 2 by x matrix where x is the
%number of points on the closed curve.

image = getPhoto();
puzzlePieces = getPieces(image);
Solve_Puzzle(puzzlePieces,2,1);
%load('integrationTestOne.mat');
%puzzlePieces = extractEdgesCorners(image, C);
sizephoto = size(image);
width = sizephoto(1);
[angle, pairIndices, sideLength] = Solve_Squares(puzzlePieces);
[ center1, center2, transConst] = centerToEdge(puzzlePieces,pairIndices);
[piecelist] = getPieceSquares(center2,pairIndices,angle,transConst);
Moving_Instructions(piecelist,center2, width, sideLength);