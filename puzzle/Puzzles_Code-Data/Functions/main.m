image = getPhoto();
imshow(image);
puzzlePieces = getPieces(image);
    %Solve_Puzzle(puzzlePieces,2,1);
[angle, pairIndices] = Solve_Squares(puzzlePieces);
% pieceList = getPieceInformation();
% moveList = makeMoves(pieceList);
% move(moveList);