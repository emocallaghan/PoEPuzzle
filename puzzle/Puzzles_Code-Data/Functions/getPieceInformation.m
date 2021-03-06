
function [ pieceList ] = getPieceInformation(puzzlePieces)
%obtaining the vector positions of piece 2s overlying piece
%obtaining piece 1s overlying piece and theta.
Piece1 = Solve_Squares{:,2};
Piece2 = Solve_Squares{:,3};
theta = Solve_Squares{:,1};
[~, ~, transConst] = centerToEdge(puzzlePieces);
%testing for already given sutff

yold = y2pos - y1pos;
xold = x1pos - x2pos;
coeffx = cos(alpha)*transConst2;
coeffy = sin(alpha)*transConst2;

if yold > 0
    %ynew = yold + coeffy;
    %ytrans = y2pos-ynew;
    ytrans = y2pos-yold;
end
if yold < 0
    %ynew = yold-coeffy
    %ytrans = y2pos+ynew
    ytrans = y2pos - yold
end
if xold > 0
    xnew = xold-coeffx;
    xtrans = x2pos + xnew - transConst2;
    xtestpoint = x2pos + xnew + coeffx;
end
if xold < 0
    xnew = xold + coeffx;
    xtrans = x2pos + xnew - transConst2;
    xtestpoint = x2pos + xnew - coeffx;
end


end

