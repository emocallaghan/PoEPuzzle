image = getPhoto();
puzzlePieces = getPieces(image);
%Solve_Puzzle(puzzlePieces,2,1);
Solve_squares(puzzlePieces);
pieceList = getPieceInformation();
moveList = makeMoves(pieceList);
move(moveList);