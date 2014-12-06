function [piecelist] = getPieceSquares(center2,pairIndices,angle,transConst)
longSide = sin(angle)*transConst;
baseSide = cos(angle)*transConst;

%calculate translation locations for piece 1 staying put and piece two
%moving.  If this is too inaccurate, consider creating a second transConst
%and simply summing those both, and then calculating based on that idea.

%not solving for distance moved?
    if angle > 0
        newPoscenter2x = pairIndices(1,1)-baseSide;
        xmove = newPoscenter2x-center2(1,1);
    else
        newPoscenter2x = pairIndices(1,1)+baseSide;
        xmove = newPoscenter2x-center2(1,1);
    end
newPoscenter2y = pairIndices(1,2) - longSide;
ymove = newPoscenter2y-center2(1,2);
piecelist = [newPoscenter2x, newPoscenter2y, angle]; 


end