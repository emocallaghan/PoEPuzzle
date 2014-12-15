function [ sortedPieces ] = distanceSort( pieces )

sizeP = size(pieces);

for i=1:sizeP(1)-2
    currentPiece = [pieces(i,1),pieces(i,2)];
    nextPiece = [pieces(i+1,1),pieces(i+1,2)];
    dist = distance(currentPiece, nextPiece);
    
    for j = i+2:sizeP(1)
        jthpiece = [pieces(j,1),pieces(j,2)];
        jthdist = distance(currentPiece, jthpiece);
        if(jthdist<dist)
            pieces(i+1,1) = jthpiece(1);
            pieces(i+1,2) = jthpiece(2);
            
            pieces(j,1) = nextPiece(1);
            pieces(j,2) = nextPiece(2);
            
            nextPiece = jthpiece;
            dist = jthdist;
        end
    end

    
end
sortedPieces = pieces;
end
